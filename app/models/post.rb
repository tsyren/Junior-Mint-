class Post < ActiveRecord::Base
  indexes_columns :using=>:like, :into=>'searchable'
  acts_as_taggable
  acts_as_bookmarkable

  has_one    :event
  has_many   :comments, :dependent => :destroy
  
  belongs_to :communities
  belongs_to :user
 

  cattr_reader :per_page
	@@per_page = 50
 
  validates_presence_of :title,    :message => "^ Нет название. Стоит заполнить"
  validates_presence_of :content,  :message => "^ Нет описание. Стоит заполнить"
  validates_length_of   :title,    :maximum => 255
  validates_length_of   :content,  :maximum => 15000
  
  def community param_id
    Communities.find_by_id param_id
  end
  
  def formatted_content
    
     formating(content)
     
  end
  
  
  def self.find_with_param( param, user )
    case param.to_s
      
     when 'everything'
       self.find_all_publics

     when 'events'
       self.find_all_public_and_final('event')

     when 'friends'
       self.find_friends_posts(user)

     when 'communities'
       self.find_users_communities_posts(user)
     end
  end
  
  def self.status_type( param )
      find_all_by_status  param 
  end
  
  def self.find_all_public_and_final(param)
      find( :all, :conditions => ['status = ? AND final = ?', "public", param ], :order => "created_at DESC" ) 
  end
  
  def self.find_all_publics
   
      communities = Community.find_all_by_status "public"
      posts = Post.find( :all, :conditions => ['community_id IN (?) OR community_id = ?',communities.collect(&:id),0], :order => "created_at DESC" ) 
      find(:all,:conditions => ['status IN (?) AND id IN (?)',["public", "external"],posts.collect(&:id)]) 
        
  end
  
  def self.find_friends_posts(user)
      find :all, :conditions => ['status != ? AND community_id = ? AND user_id IN (?)', "private",0,user.friend_ids ], :order => "created_at DESC"  
  end
  
  def self.find_users_communities_posts(user)
      find :all, :conditions => ['community_id IN (?)',user.communities.collect(&:community_id) ], :order => "created_at DESC"
  end
    
  def self.find_all_not_personal_public_and_final(param = nil)
      find( :all, :conditions => ['community_id != ? AND status = ? AND final = ?', 0,"public", param ], :order => "created_at DESC" ) unless param == nil
      find( :all, :conditions => ['community_id != ? AND status = ?', 0,"public" ], :order => "created_at DESC" )if param == nil
  end
  
  def self.paginate_by( param,page )
     paginate_by_id param, :page => page,:per_page => 5, :order => 'created_at DESC'
  end
  
  def self.paginate_with_condition_and_for(user,page,community_id)
      paginate( :page => page,:conditions=>["user_id = ? AND community_id != ?",user,community_id], :per_page => 1,:order => 'created_at DESC') 
  end

  def self.find_all_personal_posts(user)
    find(:all, :conditions => {:community_id => 0,:user_id => user},:order => 'created_at DESC')
  end
  
  def self.find_all_nonpersonal_posts(user)
    find(:all, :conditions => ["community_id != 0 and user_id = ?",user], :order => 'created_at DESC')
  end
  
  def self.find_all_share_and_grouped(user)
    find(:all, :conditions => ["community_id !=0 AND user_id = ?", user],:group => "DATE_FORMAT(created_at, '%Y%m')",:order => 'created_at DESC')
  end
  
  def self.find_all_pesonal_with_group(user)
    find_all_by_community_id_and_user_id(0,user,:group => "DATE_FORMAT(created_at, '%Y%m')",:order => 'created_at DESC',:limit => 1)
  end
    
  #most discuss posts 
  #call from Communiteies
  def self.find_most_discuss
 
    #if user == nil
      posts = Post.find_all_publics
    #else
    #  posts = Post.find_all_publics :conditions => ["user_id = ? ", user.id]
    # end
    
    sorted_posts = posts.sort_by do |post|
      Comment.count(:conditions => ["post_id = ? ", post.id],:select => "distinct(user_id)") + Comment.count(:conditions => ["post_id = ? ", post.id])
    end
    
    sorted_posts.reverse
  end

  #def self.uniq(post)?
#     results = Post.find :first, :conditions =>["title = ? ", post.title]
#     if results.nil?
#		return true
#     else
#        return false
#     end
#  end

  
  private
  
  def formating(text)
    return text.gsub(/\n{1,}/m,"<br />").lstrip.rstrip.chomp
  end
end
