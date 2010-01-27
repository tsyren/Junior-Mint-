class Community < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :feeds, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :subcribes
  has_many :questions, :dependent => :destroy
  has_many :requests  #, :conditions => "model_name = Community",:dependent => :destroy

  acts_as_taggable
  indexes_columns  :title, :description, :using=>:like, :into=>'searchable'
  cattr_reader :per_page
  @@per_page = 50
  
  validates_presence_of :title,  :message => "^Название: это неотъемлемая часть при создании сообщества"
  validates_presence_of :description, :message => "^ Описание: вы наверное забыли заполнить"
  validates_uniqueness_of :title, :message => "^такое сообщество уже существут"  
  validates_length_of :title, :maximum => 100, :message => "^Длина названия: придумайте что-нибудь покороче"

    
  def admin(user,wich_status)
    @member = CommunitiesUser.find :first, :conditions => {:user_id => user, :community_id => id }
    return false if @member.nil?
    
    case wich_status
     when "only_creator" 
         if user.id == user_id
          true
         else
          false
         end
     when "include_moderator"  
         if user.id == user_id or @member.status.to_s == "moderator"
          true
         else
          false
         end
     when "include_member"
         if user.id == user_id or @member.status.to_s == "moderator" or @member.status.to_s == "member" 
          true
         else
          false
         end
     when "include_reader"
         if user.id == user_id or @member.status.to_s == "moderator" or @member.status.to_s == "member" or @member.status.to_s == "reader"
          true
         else
          false
         end
     else return false 
    end
  end
  
  #virtual method
  def question_attributes=(attributes)
    attributes do |attr|
      #questions.build(attr)
      puts attr.to_s
    end
  end
 
  def self.find_all_user_communities(user)
     find( :all, :conditions => ["id in (select community_id from communities_users where user_id = ?)", user.id])
  end
 
  def self.find_most_activites
    #отбираем самые активные
    # Кол-во постов + 0.4 * количество комментариев (за последние 7 дней) = индекс активности.
   communities = Community.find :all
       
   active_communities = communities.sort_by do |com|
     com.posts.size + 0.4*Comment.count(:conditions => ["created_at < ? AND post_id IN (?)",Time.now - 7.days, com.posts.collect(&:id)])
   end
   active_communities
 end
 
 def size_of_comments(com) 
   Comment.count(:conditions => ["created_at < ? AND post_id IN (?)",Time.now - 7.days, com.posts.collect(&:id)])
 end
  
end
class Community < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :feeds
  has_many :posts, :dependent => :destroy
  has_many :projects
  has_many :subcribes

  
  indexes_columns  :title, :description, :using=>:like, :into=>'searchable'
  
  cattr_reader :per_page
  @@per_page = 50
  
  
  validates_presence_of :title,:description,
                        :message => "Поле нужно заполнить "
						 
  validates_uniqueness_of :title,
                          :message => "такое сообщество уже существут"  
  validates_length_of :title, :maximum => 100
  
  acts_as_taggable
  
  
   def rus_status
     case status
      when  'member'
	      return 'Участник'
	  when  'creator'
	      return 'Создатель'
      when  'admin'		  
	      return 'Администратор'
	 end
	  
   end 
	  
   def self.find_all_user_communities(user)
     find( :all, :conditions => ["id in (select community_id from communities_users where user_id = ?)", user.id])
   end
end
