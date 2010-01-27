require 'iconv'
class PostsController < ApplicationController
  include ApplicationHelper
  before_filter :login_required
  before_filter :is_private, :only => [:show,:get_file]
  before_filter :access_only_author, :only => [:edit, :update, :destroy,:delete_attache_file]
  before_filter :access_inlcude_member, :only => [:show,:get_file]
  layout :post_layout, :except => [:rss]   
  in_place_edit_for :post, :title
 
  def monthly_index
    @posts = Post.find_all_by_month_year(params[:month])
    @entry = @posts[1]
    @all_posts = Post.find(:all)
  end
  
  def archive
    @monthly_posts = Post.find_all_by_user_id( current_user.id, :group => "DATE_FORMAT(created_at, '%Y%m')" )
    @posts = Post.find(:all, :conditions => ["user_id = ? AND status = ? AND YEAR(created_at) = ? and MONTH(created_at) = ?",current_user.id,"public",params[:year], params[:month]])
  end 
  
  def tag
    @posts = Post.find_tagged_with params[:id],  :conditions => ["status = ?","public"]
    @tags = Post.tag_counts
  end 
  
  #access
  #if private only can view(community all type members or it may be friends or only creator)
  def show
    @post = Post.find(params[:id])
    
    @parti = EventsUser.find_by_user_id_and_event_id current_user.id, @post.event
    
    @tags = @post.tag_list
    
    @taggings = Post.tag_counts
    
    @community = Community.find @post.community_id unless @post.community_id == 0
    
    @at_file = Datafile.find_by_model_id_and_model_name @post.id, "Post",:conditions => {:avatar => 0}
    
    @comments = @post.comments
    
    @bookmark = Bookmark.find_all_by_bookmarkable_id_and_user_id  @post.id, current_user.id
    
    if @post.commentable == 1
       @can_commentable = true
    else
       @can_commentable = false
    end
    
    @timeleft = nil
    @show_form = false
    
    if observe_last_comment(@comments.last, @timeleft)
      @show_form = true
    else
      @remaining_time = @timeleft
      @show_form = false
    end          
      
    respond_to do |format|
            format.html
            format.xml { render :xml => @post.to_xml }
    end
  end
  
  #access
  #if private only can view(community all type members or it may be friends or only creator)
  def get_file
  
    @file = Datafile.find params[:file]
    send_file @file.full_filename,:type => @file.content_type,:disposition => 'inline'

  end


  #access public
  #filter: no
  def new
    @post = Post.new

    respond_to do |format|
      format.html
    end
  end
  

  #access public
  #filter: no
  def create

   @post = Post.new(params[:post])
   @post.tag_list = params[:tags] if params[:tags]
   @post.save ? post_created = true : post_created = false
   
   if params[:postfile][:uploaded_data] != ""
     @attacheFile = Datafile.new(params[:postfile])
     @attacheFile.model_name = "Post"
     @attacheFile.model_id = @post.id 
     @attacheFile.avatar = 0
     @attacheFile.user_id = current_user.id
     @attacheFile.save ?  post_created = true :  post_created = false
   end

   if params[:type] == 'event'
      #if params[:event][:started_on][:1i] <= params[:event][:finished_on][:1i] 
        @event = Event.new params[:event] 
        @event.post_id = @post.id
        @event.save ? post_created = true : post_created = false
      #else
      #  post_created = false
      #   datetime_error = true
      #end 	 
      datetime_error = false
      if post_created
        @event_user = EventsUser.new :event_id => @event.id, :user_id => current_user.id
        @event_user.save ? post_created = true : post_created = false
      end
   end
   
   respond_to do |format|
     if post_created 
        flash[:notice] = 'Запись была успешно создана!'
        format.html { redirect_to :controller => 'posts',:action => 'show', :id => @post.id }    
        format.xml { render :xml => @post,
                      :status => :created, :location => @post }
     else
        flash[:error] = 'Ошибка создания записи!'
        @post.destroy
        format.html { 
          flash[:error] = 'Дата начала и завершения события не соответствуют'  if datetime_error
          render :action => 'new',:type => "event"    }  if params[:type] == "event"
        format.html { render :action => 'new',:type => "post" }  if params[:type] == "post" or params[:type].nil?
        format.xml { render :xml => @post.errors,
                      :status => :unprocessable_entity }
     end
   end

  end
  #access private
  #only creator OR create and moderator
  # 
  #filter: access author or community administration
  #tested: yes
  def edit
    @post = Post.find(params[:id])
    @file = Datafile.find_by_model_id_and_model_name @post.id, "Post"
    @event = @post.event if @post.final.to_s == "event"
    params[:tags] = @post.tag_list.split().join(", ")
  end

  
  #access private
  #only creator OR create and moderator 
  #
  #filter: access author or community administration
  #tested: yes
  def update
    @post = Post.find(params[:id])
    @post.tag_list = params[:tags] if params[:tags]
    @post.save_tags
    
    file_saved = true 
    
    if params[:postfile][:uploaded_data] != ""
     
     @attacheFile = Datafile.new(params[:postfile])
     @attacheFile.model_name = "Post"
     @attacheFile.model_id = @post.id 
     @attacheFile.avatar = 0
     @attacheFile.user_id = current_user.id
     @attacheFile.save ? file_saved = true : file_saved = false
     
    end

    if @post.update_attributes(params[:post]) && file_saved
      flash[:notice] = 'Запись успешно обнавлена.'
      redirect_to :action => 'show', :id => @post
    else
      flash[:notice] = 'Возникли проблемы.' + @attacheFile.errors.each{|loop| loop.to_s+"<br />"}.to_s
      render :action => 'edit'
    end
  end

 
  #access only creator
  #
  #filter: access author or community administration
  #tested: yes
  def destroy
     
     @post = Post.find params[:id]
     community_id = @post.community_id 
     begin
     #destroing dependencies 
     #rails method delete dependencies ( via model assossiation ) does not work propertly
     
	   @files = Datafile.find :all, :conditions => { :model_id => @post.id, :model_name => "Post" }	
     @files.each {|f| f.destroy }
     if @post.status.to_s == "event"
   	 @invites = Invite.find :all, :conditions => { :model_id => @post.id, :model_name => "Event" }	
	   @requests = Justrequest.find :all, :conditions => { :model_id => @post.id, :model_name => "Event" }
     @invites.each { |f| f.destroy }
	   @requests.each { |f| f.destroy }
     end
     
	   #finally destroy post object
     @post.destroy
     respond_to do |format|
       format.html {
       flash[:notice] = "Запись успешно удалена"
       if community_id.eql? 0 	
        redirect_to mynotes_url if community_id ==0 
	     else
		    redirect_to :controller => :communities, :action => :show, :id => community_id
	     end	
      }
     end 
    rescue => e
      flash[:notice] = e.to_s
      render :action => :show, :id => @post.id
    end    
  end
  
  def delete_attache_file
    @post = Post.find params[:id]
    @file = Datafile.find_by_model_id_and_model_name @post.id, "Post"
    @file.destroy if @file
 
    respond_to do |format|
      format.js do
        render :update do |page|
          page.hide "file_edit"
        end #end render
      end # end format.js
    end #end respond_to
    
  end
  #access public
  #return xml format width PUBLIC posts
  def rss
    @events = Post.find(:all, {:conditions=> "status=public"},:order => "id DESC")
    render :layout => false
    headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  protected
  
  def post_layout
    if logged_in?
      'users'
    else  
      'default'
    end
  end  
  #observe the last comment of current user
  #
  # return TRUE if differences of time created_at comment and time right now is hight than 5 minutes
  #
  # last modified at 23 aug 2008
  #
  def observe_last_comment( comment, timeleft)
    unless comment.nil?
      timeleft = (Time.now - comment.created_at).minutes 
      if timeleft <= 5.minutes
        return false
      else
        return true
      end  
    else
      return true	
    end	
  end 
  
  private
  
    #helper
    def redirect_and_flash(url,type_of_flash, message = nil)
        flash[type_of_flash.to_sym] = message
        redirect_to url
    end

    #validate access
    #only for :edit, :update, :destroy
    def access_only_author
      @post = Post.find params[:id]

      if @post.community_id == 0  
       if current_user.id != @post.user_id
        redirect_to RAILS_URL
       end
      else
        @community = Community.find_by_id @post.community_id 
        unless @community.nil?
         if validate_author_for(@community,@post)
           #if true then redirect
           redirect_to RAILS_URL
         end
        end   
      end
    end

    #validate access
    #only for :show
    def access_inlcude_member
      @post = Post.find params[:id]

      unless @post.community_id == 0  
        @community = Community.find_by_id @post.community_id 
        if @community.status.to_s == "private"
         if validate_member_for(@community,@post)
           #if true then redirect
           redirect_to RAILS_URL
         end
        end   
      end
    end

    def validate_author_for(community,post)
      if current_user.id == post.user_id  or community.admin(current_user,"include_moderator")
        false
      else 
        true
      end  
    end

    def validate_member_for(community,post)
      if community.admin(current_user,"include_reader")
        false
      else 
        true
      end  
    end

    def is_private
      @post = Post.find params[:id]

      unless @post.community_id == 0

       @com = Community.find @post.community_id 
       @member = CommunitiesUser.find :first, :conditions => { :community_id => @com.id, :user_id => current_user.id}

       if @com.status.to_s == "private"
          if @member.nil?
            redirect_to :controller => 'communities',:action => 'list'
          else

           if @post.status.to_s == 'private'

              redirect_to :controller => 'communities',:action => 'list' unless @com.admin(current_user,"include_member")

          end   
        end 
       end 
      else  

       case  @post.status.to_s
         when 'private'
                          #if not author\
                          if @post.user_id != current_user.id	
                      flash[:notice] = "Your are not author. It's a private post" 
              redirect_to mypage_url
                      end
         when 'protected'
              @author = User.find @post.user_id

              unless @author.id == current_user.id or @author.friends.collect(&:id).include?(current_user.id)
                            flash[:notice] = "Your are not author or friend. It's a protected post"
                redirect_to mypage_url
              end
       end

      end

    end
end