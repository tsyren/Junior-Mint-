require "digest/sha1"
class User < ActiveRecord::Base
  
  #if uncomment this, ActiveRecord will not work with datatime fields
  #
  #self.record_timestamps = false
  #

  #plugins
  #search
  indexes_columns  :first_name, :last_name, :using=>:like, :into=>'searchable'
  acts_as_taggable #тэгирование

  #отношения между моделями
  has_one  :profile
  has_many :posts, :conditions => 'community_id = 0', :order => 'created_at DESC'
  has_many :messages
  has_many :datafiles
  has_many :invites
  has_many :stores
  has_many :answers
  has_many :friends,           :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => :created_at
  has_many :pending_friends,   :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => :created_at
  has_many :friendships,       :dependent => :destroy
  has_and_belongs_to_many   :events_users
  has_and_belongs_to_many   :communities
  has_and_belongs_to_many   :projects
 
  validates_presence_of     :email,      :message => '^email'
  validates_presence_of     :first_name, :message => '^имя'
  validates_presence_of     :last_name,  :message => '^фамилия'
  validates_length_of       :first_name, :maximum => 25,      :allow_nil => :true, :message => '^ваша фамилия'
  validates_length_of       :last_name,  :maximum => 50,      :allow_nil => :true, :message => '^ваша фамилия'
  validates_email_format_of :email, :message => '^не действительный адрес электронной почты'
  validates_uniqueness_of   :email,      :case_sensitive => false
  before_create             :make_activation_code_and_password


  attr_accessible :email,:first_name,:last_name, :identity_url 

  attr_accessor :password, :password_confirmation


  #return the full name of user
  def full_name
    return first_name + ' ' + last_name
  end

  def formatted_content
    return RedCloth.new(content).to_html
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Returns true if the user has just been activated.
  def pending?
    @activated
  end

  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end


  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

   def forgot_password
     @forgotten_password = true
     self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
     save(false)
   end

   def reset_password
     # First update the password_reset_code before setting the
     # reset_password flag to avoid duplicate email notifications.
     @reset_password = true
     self.password_reset_code = nil
     save(false)
   end


   #used in user_observer
   def recently_forgot_password?
      @forgotten_password
   end

   def check_password
     @password
   end

   def new_pass
     @new_password
   end

   def self.change_password(current_user,password)

     current_user.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{current_user.email}--")
     current_user.crypted_password = encrypt(password,current_user.salt)

   end

   

  protected

    def make_activation_code_and_password
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(generated_password)
    end

    def generated_password
      @password = Password.generate(8, Password::ONE_DIGIT | Password::ONE_CASE)
    end

    def make_new_password
      @new_password =  Password.generate(8, Password::ONE_DIGIT | Password::ONE_CASE)
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(@new_password)
    end
end
