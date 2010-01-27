class CommunitiesUser < ActiveRecord::Base
 belongs_to :users
 belongs_to :communities
 
 def self.rus_status
   rus_status = case status.to_s
        when 'creator'
           then 'создатель'
        when 'admin'
           then  'Модератор'    
        when 'member'
           then 'Участник'
        when 'reader'
           then 'Читатель'
        
    end #end case   
    
    rus_status
 end #end self.rus_status
end
