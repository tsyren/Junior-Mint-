class ProjectsUser < ActiveRecord::Base
  belongs_to :users
  belongs_to :projects
	
  def self.player( user,params )
    find_by_user_id_and_project_id( user,params )
  end
end
