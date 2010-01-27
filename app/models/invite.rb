class Invite < ActiveRecord::Base
  belongs_to :user
  
  def self.find_invite_for_user_and_community current_user_id, parent_id
    find_by_user_id_and_model_id current_user_id, parent_id, :conditions => ["model_name =? ", "Community"] 
  end  
  
  def self.find_invite_for_user_and_event current_user_id, parent_id
    find_by_user_id_and_model_id current_user_id, parent_id, :conditions => ["model_name =? ", "Event"] 
  end  

 
  def self.find_communities_user_and_status(user,status)
    find :all,  :conditions => ["user_id = ? AND model_name = ? AND status = ?", user, "Community",status.to_s]
  end
  
  def self.find_events_user_and_status(user,status)
    find :all,  :conditions => ["user_id = ? AND model_name = ? AND status = ?", user, "Event",status.to_s]   
  end
  
  def self.find_events_sender_and_status(user)
    find :all,  :conditions => ["sender_id = ? AND model_name = ?", user, "Event"]   
  end
end
