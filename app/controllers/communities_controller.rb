require 'rss/2.0'
require 'open-uri'

class CommunitiesController < ApplicationController
  include ApplicationHelper
  
  before_filter :login_required
  in_place_edit_for :community, :description
    
  #permission validate
  before_filter :permission_validate_only_creator, :only => [:edit,:destroy,:update,:edit_status,:change_status]
  before_filter :permission_validate_include_moderator,:only => [:answers,:requests,:accept_request,:forbidden_request,:delete]
  #before_filter :permission_validate_include_member,   :only => []
  #before_filter :permission_validate_include_reader,   :only => []
  
  before_filter :is_member, :except => [:show,:hole,:list,:new,:create,:add_question,:tag,:tag_cloud,:about,:jointo,:will_join,:remove_question]
  before_filter :is_private, :only => [:show, :jointo]
  

  layout :user_layout, :except => [:rss,:change_status,:edit_status,:answers]   
  
   
  #
  # access: public
  # 
  #check exists?
  def about 
  end
  
  #
  # access: public
  # 
  def list
    @communities_latest = Community.find(:all,:order => "created_at DESC")
   
	  @communities_own = Community.find(:all, :conditions => ["id in (select community_id from communities_users where user_id = ? order by created_at DESC )", current_user.id]) 
    
    @most_activity = Community.find_most_activites

    case params[:type]
        when  'latest'
         @community_view = @communities_latest
         @subtitle  = 'Новые'
        when  'popular'
         @community_view = @most_activity 
         @subtitle = 'Популярные '
        when  'mycom'
         
         @community_view = @communities_own
         @subtitle = 'Мои сообщества'
       when nil
         @community_view = @communities_own
         @subtitle  = 'Мои сообщества'
    end

    @communities= Community.paginate  @community_view, :page => params[:page],:per_page => 7, :order => 'created_at DESC'
    @tags = Community.tag_counts
	 
    respond_to do |format|
      format.html
      format.js {
       render :update do |page|
        page.replace_html 'list_communities', :partial => 'list_communities', :collection => @communities
       end
      } 
    end
  end
  
  
  #
  # access: public
  # 
  #check usage
  def tag_cloud
     @tags = Community.tag_counts
  end
  
  # view tags  within params
  #
  # access: public
  # 
  def tag
     @communities = Community.find_tagged_with(params[:id])
     #all tags
     @tags = Community.tag_counts
  end
  
   
  #hole is room where user will be redirect if he is not  
  def hole
    @community = Community.find(params[:id])
    if @community.status.to_s == 'private'
      @request = Justrequest.community_and_user @community.id, current_user.id
      if @community.questions
        @community.questions.size.times { @answer = Answer.new }
      end
    end
  end

  #
  # access: public 
  #
  def new
    @community = Community.new
    @community.questions.build
    
    respond_to do |format|
      format.html
    end
  end
  
  # access: public 
  # format: Javascript
  def add_question
    @question = Question.new
    respond_to do |format|
      format.js
    end
  end
  
  #
  # access: public
  #
  def create
    @community = Community.new(params[:community])
    
    if @community.status.to_s == 'private'
     
     if params[:question]
      params[:question].each_value do |question| 
       @community.questions.build(question) unless question.values.all?(&:blank?)
      end
     end
    
    end
    
    @community.tag_list = params[:tags]
      
    if @community.save
      @communities_user = CommunitiesUser.new
      @communities_user.status = 'creator'
      @communities_user.user_id = current_user.id
      @communities_user.community_id = @community.id
      
      if @communities_user.save
        flash[:notice] = 'Новое сообщество успешно создано.'
        redirect_to :action => 'show', :id => @community.id
      else
        render :action => 'new'
      end  
    else
      render :action => 'new'
    end
  end
  
  
  #
  # access: public or private
  # filter: is member
  # 
  def show
    @community = Community.find(params[:id])
    
    @members = CommunitiesUser.find(:all, :conditions => {:community_id => params[:id]} ) 
    
    @requests = Justrequest.communities_and_status @community.id,"waiting"
    
    @yet_invited = Invite.find_all_by_model_id_and_status @community.id,"waiting",:conditions => {:model_name =>"Community"}
    
    @not_members = User.find(:all, :conditions => ["id NOT IN (?)",(@members.collect(&:user_id) + @yet_invited.collect(&:user_id).uniq).uniq]) 
    
    @subtitle = @community.title
    
    @avatar = Datafile.find_avatar_by_community_id(params[:id])
    
    @tags = Tagging.find(:all, :conditions => ["taggable_id = ? AND taggable_type = ?",@community.id,'community'])
    
    @communities_user = CommunitiesUser.find(:first, :conditions => {:user_id => current_user.id, :community_id => params[:id]} ) 
    
    @author = User.find( :first, :conditions => { :id => @community.user_id } )
    
    @posts = Post.find :all,:conditions => ['community_id = ?',@community.id], :limit => 7
    
   
    
    respond_to do |format|
      format.html
    end
  end
  
  
  #
  # access: private
  # filter: filter: permission_validate_include_moderator
  #
  # ajax
  # get user answers
  # GET#=>Javascript
  def answers
     @community = Community.find params[:id] 
     @answers = Answer.find_user_answers_of_community(params[:user_id],@community)
     respond_to do |format|
      format.js 
     end
  end
  
  #
  # access: public
  # need validate status of community
  # 
  def jointo
    respond_to do |format|
    @community = Community.find params[:id]
    @member = CommunitiesUser.find(:first, :conditions => ["user_id = ? AND community_id = ?",current_user.id,@community.id])
    unless @member.nil?
      respond_to do |format|
       format.html {
        flash[:notice] = 'Вы уже участник этого сообщества.'
        redirect_to :action => 'show', :id => @community
        }
      end #end respond_to
    
    else
    
    if @community.status.to_s == "public"
      
    @communities_user = CommunitiesUser.new
    @communities_user.user_id = current_user.id
    @communities_user.community_id = @community.id
    
    @invite = Invite.find_invite_for_user_and_community current_user.id, @community.id
    unless @invite.nil?
      @invite.status = "accepted"
      @invite.save!
    end
    
      if @communities_user.save
        format.html {
          flash[:notice] = 'Вы успешно вступили в это сообщество.'
          redirect_to :action => 'show', :id => @community
        }
      else
        format.html {
        redirect_to :action => 'show', :id => @community
        }
      end  
 
    
    else
    
    format.html {
        redirect_to :action => 'hole', :id => @community
    }
    
    end #end if 
   
    end #end unless
    
   end #end respond_to 
  end
    
  #
  # access: private
  # filter: is_member
  #   
  def leave
    @member = CommunitiesUser.find(:first, :conditions => ["user_id = ? AND community_id = ?",current_user.id,params[:id]])
    @questions = Question.find :all, :conditions => {:community_id => params[:id]}
    @answers = Answer.find :all, :conditions => [ "user_id = ? and question_id IN (?)", current_user.id,@questions.collect(&:id) ]
    @answers.each {|a| a.destroy }
    @invites = Invite.find :all, :conditions => { :model_id =>  @community.id, :model_name => "Community", :user_id => @member.user_id }	
    @requests = Justrequest.find :all, :conditions => { :model_id =>  @community.id, :model_name => "Community", :user_id => @member.user_id  }
    @invites.each { |f| f.destroy }
    @requests.each { |f| f.destroy }	
    
    @member.destroy
    
	  respond_to do |format|
	     format.html { 
       flash[:notice] = 'Вы покинули это сообещство.'
       redirect_to :action => 'list',:type => 'mycom' 
       } 
    end 
  end
  
  #
  # access: private
  # filter: is_member
  # 
  def posts
    @community = Community.find params[:id]

    @posts = @community.posts 
    @posts = Post.paginate @posts, :order => 'created_at DESC', :per_page => 10, :page => params[:page]	
    
    respond_to do |format|
      format.html
    end
  end 
  
  #
  # access: private
  # filter: is_member
  # 
  def projects
  #   @community = Community.find(params[:id])
  #   @communities_user = CommunitiesUser.find(:first, :conditions => {:user_id => current_user.id, :community_id => params[:id]} ) 
  #  
  #  respond_to do |format|
  #    format.html
  #  end 
  end
  

  #
  # access: private
  # filter: is_member
  # 
  def members
  
   
     @show_type = case params[:view] 
        when 'creator'
           'creator'
        when 'readers'
           'reader'
        when 'moderators'   
           'moderator'
        else 
           "member"
       end
       
    @community = Community.find params[:id]

    @community_users = @community.users.find :all, :conditions => ["status = ?",@show_type.to_s]
    

    respond_to do |format|
      format.html
    end
  end
  
  
  #
  # access: private
  # filter: permission validate include moderator
  # 
  # delete the member of community
  # params user_id - id of user who will be deleted
  #
  # usega: not used
  # tested: not
  def delete
    begin
    @com_user = CommunitiesUser.find_by_user_id_and_community_id params[:user_id], params[:id]
    @community = Community.find params[:id]
    @user = User.find @com_user.user_id

    if @com_user.user_id != @community.user_id   
       @questions = Question.find :all, :conditions => {:community_id => params[:id]}
       @answers = Answer.find :all, :conditions => [ "user_id = ? and question_id IN (?)", params[:user_id],@questions.collect(&:id) ]
       @answers.each {|a| a.destroy }
   	   @invites = Invite.find :all, :conditions => { :model_id =>  @community.id, :model_name => "Community", :user_id => @com_user.user_id }	
	     @requests = Justrequest.find :all, :conditions => { :model_id =>  @community.id, :model_name => "Community", :user_id => @com_user.user_id  }
 
  	   @invites.each { |f| f.destroy }
	     @requests.each { |f| f.destroy }	
       @com_user.destroy
       flash[:notice] = @user.full_name.to_s + " будет оповещен об удалении из этого сообщества"
       redirect_to :action => :members, :id => params[:id]
    else
       flash[:notice] = "Вы не можите удалить себя"
       redirect_to :action => :members, :id => params[:id] 
    end

    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = "запись не найдена"
      redirect_to :action => :members, :id => params[:id] 
    else
     

    end
		
  end
  
  #
  # access: private
  # filter: permission validate include moderator
  # 
  # delete the member of community
  # params user_id - id of user who will be deleted
  #
  # usega: not used
  # tested: not
  def requests
     @community = Community.find(params[:id])
     @requests = Justrequest.communities_and_status @community.id,"waiting"
  end
  
  #
  # access: public
  # отпарвка заяки
  def will_join
    @community = Community.find(params[:id])
    @will_send = Justrequest.community_and_user @community.id, current_user.id
    @answers = true
    if @will_send.nil?
     
    if @community.questions
      if params[:answer]  
        params[:answer].each_value do |answer| 
          @a = Answer.new(answer) unless answer.values.all?(&:blank?)
          @a.save
          
          unless  @a.errors.empty?
             @answers = false
          end  
        end
      end
    end
    
    @request = Justrequest.new(params[:request])
    @request.user_id = current_user.id 
    @request.model_id = @community.id
    @request.model_name = "Community"
    @request.status = "waiting"
    
    if @request.save && @answers
       flash[:notice] = "Заявка отправленна. Ждите ответа"
       redirect_to :action => 'list'
    else
       flash[:notice] = "Заявка не отправленна."
       @request.destroy
       redirect_to :action => :hole, :id => @community.id
    end
      
    else
       flash[:notice] = "Заявку можно отсылать только 1 раз." if @will_send.status == "waiting" or @will_send.status == 'accepted'
       flash[:notice] = "Вам отказана во вступлении" if @will_send.status == "forbbiden"
       
       redirect_to :action => 'list'
    end
  end
  
  #
  # access: private
  # filter: permission validate include moderator
  # 
  def accept_request
    @user = User.find params[:user_id]
    @communities_user = CommunitiesUser.new
    @communities_user.user_id = params[:user_id]
    @communities_user.community_id = params[:id]
    @request = Justrequest.community_and_user params[:id],params[:user_id]
    @request.status = "accepted"
        
    respond_to do |format|
      if @communities_user.save && @request.save
        format.html {
        flash[:notice] = "#{ @user.full_name } добавлен как участник."
        redirect_to :action => 'requests',:id => params[:id]
        }
      else
        format.html {
        flash[:notice] = 'Ошибка.'
        redirect_to :action => 'requests',:id => params[:id]
        }
      end  
    end
  end
  
  #
  # access: private
  # filter: permission validate include moderator
  # 
  def forbidden_request
    @request_f = Justrequest.community_and_user  params[:id],params[:user_id]
    @request_f.status = "forbbiden"
    @questions = Question.find :all, :conditions => {:community_id => params[:id]}
    @answers = Answer.find :all, :conditions => [ "user_id = ? and question_id IN (?)", params[:user_id],@questions.collect(&:id) ]
    @answers.each {|a| a.destroy }
    
    respond_to do |format|
      if @request_f.save
        format.html {
        flash[:notice] = 'Пользователь получит оповещение об отказе.'
        redirect_to :action => 'requests',:id => params[:id]
        }
      else
        format.html {
        flash[:notice] = 'Ошибка.'
        redirect_to :action => 'requests',:id => params[:id]
        }
      end  
    end
  end
  
  # access: private 
  # need permission validate only Creator
  # 
  def edit
    @community = Community.find(params[:id])
     params[:tags] = @community.tag_list.split().join(", ")
  end
  
  #
  # access: private 
  # need permission validate only Creator
  #  
  def update
    @community = Community.find(params[:id])
    @posts = Post.find :all, :conditions => ["status = ? AND community_id = ? ", "private", @community.id]
    @posts.each do |post|
      post.status = params[:community][:status].to_s
      post.save
    end
    @community.tag_list = params[:tags] if params[:tags]
    @community.save_tags
    
    if params[:community][:status].to_s == 'private'
    
     if params[:question]
      params[:question].each_value do |attr| 
         unless attr["id"].blank?
           question = @community.questions.detect {|q| q.id == attr["id"].to_i}
           
          unless attr["should_destroy"].blank?
           question.destroy 
          else
           question.question = attr["question"]
           question.save(false)
          end 
         else
           @community.questions.build(attr)
         end #end unless attr["id"].blank?
       end # end block
      end # end if
  
    else
      
      params[:question] = nil
      
      unless @community.questions.nil?
        @community.questions.each do |q|
          q.destroy
        end
      end
    end #end if @community.status.to_s == 'private'
    
    if @community.update_attributes(params[:community]) 
      flash[:notice] = 'Общие настройки успешно сменены.'
      redirect_to :action => 'show', :id => @community
    else
      render :action => 'edit'
    end
  end

  #
  # access: private 
  # need permission validate only Creator
  # 
  def destroy
   @community = Community.find params[:id]
   @questions = Question.find :all, :conditions => {:community_id =>  @community.id }
   @answers = Answer.find :all, :conditions => [ "question_id IN (?)", @questions.collect(&:id) ]
   @answers.each {|a| a.destroy }
    
   @invites = Invite.find :all, :conditions => { :model_id =>@community.id, :model_name => "Community" }	
   @requests = Justrequest.find :all, :conditions => { :model_id => @community.id, :model_name => "Community" }
   @invites.each { |f| f.destroy }
   @requests.each { |f| f.destroy } 

   respond_to do |format|
    if Community.destroy params[:id]
      flash[:notice] = 'Сообщество успешно удалено.'	
      format.html { redirect_to :action => 'list',:type => 'latest' }
    else
      format.html { render :action => :show, :id => params[:id] }
    end
   end
  end
  
  #
  # access: private
  # filter: is_member
  # 
  #
  def email
    
    @sub = Subscribe.find :first, :conditions => ["user_id = ? AND model_id = ? AND model_type = ?", current_user.id,params[:id],"Community"]
    if @sub.nil? || @sub.status == "refused"
     @sub = Subscribe.new 
     @sub.user_id = current_user.id
     @sub.model_id = params[:id]
     @sub.model_type = "Community"
     @sub.status = "recieving"
     
     if @sub.save
       flash[:notice] = "Вы успешно подписались!"
       redirect_to :back
     else
       flash[:notice] = "Извените, произошла ошибка"
       redirect_to :back
     end  
    else
     flash[:notice]="Вы уже подписанны на этот сообщество"
     redirect_to :back
    end  
    
  end
  
  #
  # Ajax actions
  #
  
  #
  # accesss: private
  # filter: permission validate include creator
  # only for admin
  # 
  # method change the status of user in community
  # @com_user = CommunitiesUser.find_by_community_id_and_user_id params[:id], params[:user_id]
  # @com_user.status = "member"
  # @com_user.save

   def change_status
    @member = CommunitiesUser.find_by_community_id_and_user_id params[:id],params[:user_id]
    respond_to do |wants|
      wants.js do
        render :update do |page|
          if params[:do] == "edit"
            page.replace_html "member_status_#{@member.user_id}", :partial => "status.html.erb", :object => @member
            page.hide "link_edit_#{@member.user_id}"
          else if params[:do] == "hide"
            page.show "link_edit_#{@member.user_id}"
            page.replace_html "hide_status_edit", @member.status.to_s
           end #end if
          end
        end #end render
      end #end wants.js
    end #end wants
   end #end change_status
   
  #
  # accesss: private
  # filter: permission validate include creator
  # only for admin
  # 
  # method change the status of user in community
  # @com_user = CommunitiesUser.find_by_community_id_and_user_id params[:id], params[:user_id]
  # @com_user.status = "member"
  # @com_user.save

   def edit_status
    @member = CommunitiesUser.find_by_community_id_and_user_id params[:id],params[:user_id]
    @member.status = params[:status]
    @member.save
    
    respond_to do |wants|
      wants.js do
        render :update do |page|
            page.show "notice"
            page.replace_html "notice","Статус сменен"
            page.show "link_edit_#{@member.user_id}"
            page.replace_html "hide_status_edit", @member.status.to_s
         end #end render
      end #end wants.js
    end #end wants
    
   end
  
  private 
    
  def permission_validate_only_creator
     @community = Community.find params[:id]
     
     if !@community.admin(current_user,"only_creator")
        go_to_show(@community.id)
     end
  end 
  
  def permission_validate_include_moderator
     @community = Community.find params[:id]
     
     if !@community.admin(current_user,"include_moderator")
        go_to_show(@community.id)
     end
  end
   
  def permission_validate_include_member
     @community = Community.find params[:id]
     
     if !@community.admin(current_user,"include_member")
        go_to_show(@community.id)
     end
  end 
  
  def permission_validate_include_reader
     @community = Community.find params[:id]
     
     if !@community.admin(current_user,"include_reader")
        go_to_show(@community.id)
     end
  end 
  
  def is_member
    @community = Community.find params[:id]
      
     unless @community.admin(current_user,"include_reader")
       go_to_show(@community.id) and return false
     end
  
  end
  
  def is_private
     @community = Community.find params[:id]
     
     if @community.status.to_s == 'private' and !@community.admin(current_user,"include_reader")
       redirect_to :action => "hole", :id => @community.id
     end 
  end
  
  def go_to_show(id)
    redirect_to :action => :show,:id => id
  end
  
 end

