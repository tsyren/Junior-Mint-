class Justrequest < ActiveRecord::Base
 
  attr_accessor :community_id
  belongs_to :community, :class_name => 'Community',:conditions => "model_id = #{id}" , :foreign_key =>'model_id'

  
  def self.find_communities_requests(user,status)
    find :all, :conditions => ["model_name = ? AND status = ? AND model_id IN (?) ","Community",status,user.communities.collect(&:community_id)]   
  end
  
  def self.communities_and_status(community_id, status)
    find :all, :conditions => ['model_id = ? AND model_name = ? AND status = ? ',community_id,"Community",status.to_s]
  end
  
  def self.community_and_status(community_id, status)
    find :first, :conditions => ['model_id = ? AND model_name = ? AND status = ? ',community_id,"Community",status.to_s]
  end
  
  def self.community_and_user(community_id, user_id)
    find :first, :conditions => ['model_id = ? AND model_name = ? AND user_id = ? ',community_id,"Community",user_id]
  end
 
  def self.event_and_status(event_id, status)
    find :all, :conditions => ['model_id = ? AND model_name = ? AND status = ? ',event_id,status.to_s]
  end
 
  def self.find_communities_user_and_status(user,status)
    find :all,  :conditions => ["user_id = ? AND model_name = ? AND status = ?", user, "Community",status.to_s]
  end
  
  def self.find_events_user_and_status(user,status)
    find :all,  :conditions => ["user_id = ? AND model_name = ? AND status = ?", user, "Event",status.to_s]   
  end
 
end
