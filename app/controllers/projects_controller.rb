class ProjectsController < ApplicationController
   layout 'users'
   before_filter :login_required
  
   def new
     @project = Project.new
     @community = Community.find params[:id]
   end
   
   def create
     @community = Community.find params[:com_id]
     @project = Project.new(params[:project])
     @project.user_id = current_user.id
     @project.community_id = params[:com_id]
     @project.players = 1
     @project.tag_list = params[:tags]
	
    if @project.save
      flash[:notice] = 'New project was successfully create.You mast to activate your project'
      redirect_to :controller => 'communities', :action => 'projects', :id => params[:com_id]
	else
      render :action => 'new'
    end
   end
   
   def overview
     @project = Project.find params[:id]
	 @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
	 @author = User.find( :first, :conditions => { :id => @project.user_id } )
   end
   
   def dashboard
	@project = Project.find params[:id]
	 @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
   
   def messages
    @project = Project.find params[:id]
	 @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
   
   def to_do
    @project = Project.find params[:id]
    @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
   
   def milestones 
    @project = Project.find params[:id]
    @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
   
   def files
    @project = Project.find params[:id]
    @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
   
   def time
    @project = Project.find params[:id]
    @projectmembers =  ProjectsUser.player(current_user.id,params[:id])
   end
end
