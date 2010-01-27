require 'RMagick'
require 'builder'
class UsersController < ApplicationController
  include ApplicationHelper
  #before_filter :set_online 
  layout :user_layout

  before_filter :profile_permission, :only => [:dude]
  before_filter :login_required, :except => [:new,:notify,:index,:create,:forgot_password,:reset_password,:activate,:feedback]

  #render new.rhtml
  def new
  end

  def feedback
    
  end
  
  def index
   
   respond_to do |format|
    if logged_in?
     format.html{ redirect_to mypage_url }
    else
     format.html
    end
   end
  end

  def notify
     @user = User.find(params[:id])
     @sub_title = "После регистрации"
     render :layout => 'default'
  end


   def create
     cookies.delete :auth_token
     @user = User.new(params[:user])
     @user.save
     @profile = Profile.new(:user_id => @user.id,:access => 'public')
     @profile.save

     if @user.errors.empty? and @profile.errors.empty?
       
      redirect_to :action => "notify", :id => @user.id
      flash[:notice] = "Спасибо за регистрацию!"
      
     else
      @user.destroy
      @profile.destroy
      flash[:error] = "Ошибка создания"
      render :action => 'new'
     end
   end

   def activate
     self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
     if logged_in? && !current_user.active?
       current_user.activate
     end

     respond_to do |format|
        format.html {
          flash[:notice] = "Регистрация завершена! Осталось войти"
          redirect_to login_url
        }
     end
   end

   #страница юзера
   #login_required
   def mypage
     respond_to do |format|
      if params[:view]   
        @posts = Post.find_with_param( params[:view], current_user )
      else
        @posts = Post.find_with_param( current_user.profile.column.to_s, current_user )
      end   
   
      @most_discuss = Post.find_most_discuss
     
      @posts = Post.paginate_by(@posts,params[:page])
      
       format.html
       format.xml { render :xml => @posts }
     end
    end
 
   

    #view another user page
    #login_required
    def dude
     @user = User.find params[:id]
     @userphoto = Datafile.find_by_user_id @user.id,:conditions => "model_id = 0 AND avatar=1"
     @tags = Tagging.find_all_by_taggable_id_and_taggable_type( params[:id],'user' ) if params[:type] == "social" or params[:type] == nil
    
     case params[:type]
       when "communities"
         @communities = Community.find_all_user_communities(@user)
         @communities =  @communities.paginate :page => params[:page], :per_page => 10
       
       when "friends"
         @friends = @user.friends 
         @friends =  @friends.paginate :page => params[:page], :per_page => 10
       when 'answers'
         @answers = @user.answers
         if params[:com]
          @u = User.find params[:com] 
          @communities = Community.find :all, :conditions => ["user_id = ? ",@u ], :select => ["id"]
          @q = Question.find :all,:conditions => ["community_id IN (?) ", @communities]
          @answers =  @answers.find :all, :conditions => ["question_id IN (?) ",@q ]
         end
     end
     
     respond_to do |format|
       format.html
     end
    end

    #user's profile page
    #access: customizable
    #login_required
    def profile
     
     if params[:id]
        @user = User.find params[:id]
     else
        @user = current_user
     end
     @profile = @user.profile
     @userphoto = Datafile.find_by_user_id current_user.id, :conditions => "model_id = 0 AND avatar=1"
     @tags = Tagging.find_all_by_taggable_id_and_taggable_type( @user.id,'user' ) if params[:type] == "social" or params[:type] == nil
     
    
     respond_to do |format|
        format.html
	format.rdf
     end
    end

    #unused
    #ajax
    #login_required
#    def profiler
#      if params[:id]
#        @user = User.find params[:id]
#      else
#        @user = User.find current_user.id
#      end
#      @tags = Tagging.find_all_by_taggable_id_and_taggable_type( @user.id,'user' ) if params[:type] == "interests"
#      respond_to do |format|
#        format.js
#      end
#
#    end

    #ajax
    #login_required
    def setup_access_users
       respond_to do |format|
        format.js
      end
    end

    #show all users who have current interests
    #login_required
    #access public
    def tag
     @users = User.find_tagged_with(params[:id])  if params[:id]
     @tags = User.tag_counts
     respond_to do |format|
	     format.html
     end
    end

    #edit the user personal infomation
    #login_required
    def edit
     @user = User.find(current_user.id)
     @profile = @user.profile

     params[:tags] = @user.tag_list.join(', ')
    end

    #update from edit page
    #login_required
   def update
        
     @user = User.find current_user.id
     
     
     if  !params[:tags].nil?
       @user.tag_list = params[:tags]
     end
     
    

     respond_to do |format|
      if @user.update_attributes(params[:user]) && @user.profile.update_attributes(params[:profile])
        flash[:notice] = "Изменения приняты"
        format.html { redirect_to myprofile_url }
        format.xml  { head :ok }
      else
        flash[:notice] = "Ошибка. Изменения не приняты"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
     end

   end

   #user's blog
   #login_required
   def blog
     if params[:id].nil?
      @user = User.find current_user.id
      @posts = Post.find_all_personal_posts(current_user)
      #@posts = Post.paginate_by_id @posts, :page => params[:page],:per_page => 7, :order => ["created_at DESC"]
      @groupposts = Post.find_all_pesonal_with_group(current_user)
     else
     if params[:id] != current_user.id
       @user = User.find(params[:id])
       @posts = Post.find_all_personal_posts params[:id]
       #@posts = Post.paginate_by_id @posts, :page => params[:page],:per_page => 7, :order => ["created_at DESC"]
       @groupposts = Post.find_all_pesonal_with_group(params[:id])
     end
    end
     @posts = Post.paginate_by_id @posts, :page => params[:page],:per_page => 7, :order => ["created_at DESC"] 
     @taggings = Post.tag_counts
     respond_to do |format|
      format.html # blog.html.erb
      format.xml  { render :xml => @posts }
     end
    end

    #user's blog for community
    #login_required
    def blogcom
     if params[:id].nil?
      @user = User.find current_user.id
      @posts = Post.find_all_nonpersonal_posts(current_user)
      @groupposts = Post.find_all_share_and_grouped(current_user)
     else
      if params[:id] != current_user.id
       @user = User.find params[:id]
       @posts = Post.find_all_nonpersonal_posts(params[:id])
       @groupposts = Post.find_all_share_and_grouped(params[:id])
      end
    end
     @posts = Post.paginate_by_id @posts, :page => params[:page],:per_page => 7
     @taggings = Post.tag_counts

     respond_to do |format|
      format.html # blogcom.html.erb
      format.xml  { render :xml => @posts }
     end
    end

    #login_required
    def change_password
      return unless request.post?
      if User.authenticate(current_user.email, params[:old_password])
        if ((params[:password] == params[:password_confirmation]) &&
                              !params[:password_confirmation].blank?)
          User.change_password(current_user,params[:password])

          if current_user.save
            flash[:notice] = "Пароль сменён"
            redirect_to myprofile_path
          else
            flash[:alert] = "Пароль не сменен"
            redirect_to myprofile_path(:type => "options")
          end
        else
          flash[:alert] = "Новый пароль неверный"
          @old_password = params[:old_password]
         redirect_to myprofile_path(:type => "options")
        end
      else
        flash[:alert] = "Старый пароль не верный"
       redirect_to myprofile_path(:type => "options")
      end
    end

    #gain email address
    def forgot_password
      return unless request.post?
      if @user = User.find_by_email(params[:user][:email]) and !params[:user][:email].blank?
       @user.forgot_password
       @user.save

       respond_to do |format|
  	    format.html do
          flash[:notice] = "На адрес #{@user.email} была отправлена информация о новом пароле"
  	      redirect_to RAILS_URL
        end
	     end
      else
        flash[:error] = "Пустой email!"  if params[:user][:email].blank?
        flash[:error] = "Пользователя с таким электронным адресом  у нас не зарегестрирован." if @user.nil?
        render :action => "forgot_password"
      end
    end

   def reset_password
    @user = User.find_by_password_reset_code(params[:id]) unless params[:id].nil?
    if @user.nil?
    flash[:error] = "неверные код восстановления"
    redirect_to RAILS_URL
    end
    return unless request.post?
      if ((params[:user][:password] == params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
        User.change_password(@user,params[:user][:password])
        @user.reset_password
        @user.save
        flash[:notice] = "Пароль успешно сменён для #{@user.email}"
        redirect_to RAILS_URL
      else
        render :action => :reset_password
      end
   end

   #send_feedback
   #login_required
    def send_feedback
      return unless request.post?
      respond_to do |format|
      unless params[:feedback].blank?

      UserMailer.deliver_send_feedback(current_user,params[:feedback])
       flash[:notice] =  "Спасибо за отправку"
       format.html { redirect_to mypage_url }

      else
       flash[:notice] =  "Форма отправки пуста!"
       format.html
      end
      end
    end

  
  private
  
  
   
  def profile_permission
     @user = User.find params[:id]

     case @user.profile.access.to_s
        when "private":
            @is_friend = Friendship.find_by_user_id_and_friend_id @user.id, current_user.id, :conditions => {:status => "accepted"}
            respond_to do |format|
            format.html {
            if @is_friend.nil?
              flash[:notice] = "Доступ к профайлу закрыт"
              redirect_to :back

            end
            }
            end
        when "custome":
            #@access = Access.find_by_user_id_and_model_id @user.id, current_user.id, :conditions => {:model_name => "User"}
            
            respond_to do |format|
            format.html {
            if @user.id != current_user.id
              flash[:notice] = "Доступ к профайлу закрыт"
              redirect_to :back
            end
            }
            end
     end
  rescue ActionController::RedirectBackError => e
    
    flash[:notice] = "Доступ к профайлу закрыт"
    redirect_to mypage_url
    
  end
end
