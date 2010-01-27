class Datafile < ActiveRecord::Base
   belongs_to :post 

   
   has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain','application/x-compressed','application/x-zip-compressed','application/x-gzip-compressed',:image], 
                  :storage => :file_system,
        		      :path_prefix => "public/postfiles/",
                  :size => 0.kilobytes..10000.kilobytes,
                  :resize_to => 'x60',
                  :thumbnails => { :thumb => [150,150], :geometry => 'x50' },
                
                  :processor => 'Rmagick'
  
   #проводим валидацию
   validates_as_attachment 

   def self.find_avatar_by_community_id(id)
      find_by_model_id id,:conditions => ["model_name = ? AND avatar=1","Community" ]   
   end
  
   def self.find_user_avatar(user_id)
      find_by_user_id user_id,:conditions => ["model_name = ? AND avatar=1","User" ]   
   end
   
   def self.find_all_users_avatars(users)
      collect_users = users
      find :all, :conditions => ["avatar=1 AND model_id = ? AND user_id IN (?)",0,collect_users.collect(&:id)]   
   end
  
end
