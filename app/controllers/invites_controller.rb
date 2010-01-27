class InvitesController < ApplicationController
  include ApplicationHelper
  layout 'users'
  before_filter :login_required
  
  def index
    if params[:show] == "eve"
     @response = Invite.find_events_user_and_status current_user.id, "waiting" if params[:type] == "in"
     @response = Invite.find_events_sender_and_status current_user.id  if params[:type] == "out"
		
     @invites = Post.find :all, :conditions => ["id IN (?)",@response.collect(&:model_id) ]
	 @class = "event"
	 
    else      
  	 @response = Invite.find_communities_user_and_status current_user.id, "waiting"
     @invites = Community.find :all, :conditions => ["id IN (?)",@response.collect(&:model_id) ]
     @class = "community"
    end 
  end
  
  def requests
    if params[:show] == "eve" or params[:show] == nil
     @response_in = Justrequest.find_events_user_and_status current_user.id, "waiting"
     @requests = Post.find :all, :conditions => ["id IN (?)",@response_in.collect(&:model_id)]
     @class = "event"
    else
     @response_in = Justrequest.find_communities_user_and_status current_user.id,"waiting" if params[:type] = "out"
     @response_in = Justrequest.find_communities_requests(current_user,"waiting") if params[:type] = "in"
     @requests = Community.find :all, :conditions => ["id IN (?)",@response_in.collect(&:model_id)]
     @class = "community"
    end 
  end
  
  def deined
    if params[:show] == "eve" || nil
  	 @forbidden_events = Invite.find_events_user_and_status current_user.id, "forbidden"
  	 @forbi = Event.find :all,  :conditions => ["id IN (?)",@forbidden_events.collect(&:model_id)]
     @class = "event"
    else
     @forbidden_communities = Invite.find_communities_user_and_status current_user.id, "forbbiden" if params[:type] = "in"
     @forbidden_communities = Justrequest.find_communities_user_and_status(current_user,"forbbiden") if params[:type] = "out"
     @forbi = Community.find :all, :conditions => ["id IN (?) ",@forbidden_communities.collect(&:model_id)]
     @class = "community"
    end
  end  
  
  def new
    @community = Community.find params[:id] 
    @communities_users = CommunitiesUser.find(:all, :conditions => {:community_id => @community.id},:select => "user_id" ) 
    @yet_invited = Invite.find :all, :conditions => {:model_name => "Community",:model_id => @community.id}      
    
    #выборка всех пользователей исключая тех кто уже в этом сообществе
    @users = User.find(:all, :conditions => ["id NOT IN (?)",@communities_users.collect(&:user_id)]) 
  end
  
  def create
    
    @inviter = params[:invite_users].find_all{|key, value| value.to_i == 1 }
   
    @inv = @inviter.map{ |k| k[0] }
    
    @inv.map { |user_id|
    
    invite = Invite.new 
    invite.user_id = user_id
    invite.sender_id = current_user.id
    invite.model_id = params[:id]
    invite.status = "waiting"
    if !params[:type].nil? && params[:type] == "event"
      invite.model_name = "Event"
    else  
      invite.model_name = "Community"
    end
    
    invite.save 
    }

    
    if params[:type].nil?
      flash[:notice] = "Приглашения отправленны."
      redirect_to :controller => :communities, :action => 'show', :id => params[:id]
    else
      if params[:type] == "event"
        flash[:notice] = "Приглашения отправленны" 
        redirect_to :controller => :events, :action => 'index'
      end
    end
    
  end
  
  #
  #apply invite from coommunity or events
  #
  def apply
    #@invite = Invite.find :first, :conditions => {:user_id => current_user.id, :invite_id => params[:id],:model => params[:type].capitalize}
    unless @invite.nil?
     @invite.status = "accept" 
     respond_to do |format|
      case params[:type]
        when "community"
          then 
              @communities_user = CommunitiesUser.new
              @communities_user.user_id = current_user.id
              @communities_user.community_id = params[:id]
              @community = Community.find params[:id]
              
              @role = Roleship.new
              @role.user_id = current_user.id
              @role.community_id = params[:id]
              @role.role_id = 3 # 3 mean member
              current_destroy params[:id] 
          
                if @communities_user.save && @role.save && @invite.save
                  format.html {
                  flash[:notice] = 'Вы успешно вступили в это сообщество.'
                  redirect_to :action => 'index'
                  }
                else
                  format.html {
                  redirect_to :action => 'index'
                  }
                end  
             
        when "events"
          then 
              @participants = EventsParticipant.new(params[:participant])
              @event = Event.find(params[:id])
              @roleship = Roleship.new
              @roleship.parent_id = @event.id
              @roleship.user_id = current_user.id
              @roleship.model = "Event" 
              @roleship.role_id = 3
              
              if @participants.save && @event.save && @roleship.save
               flash[:notice]  = "Вы отказались учавствовать в мероприятии " + @event.post.title.capitalize.to_s
               redirect_to :action => :index, :id => params[:id]
              else
               render :action => :new_participants, :id => params[:id]
              end 
        end  
    end          
    else
      
    end
  end
  
  def destroy
    current_destroy params[:id]
    redirect_to invites_path
  end
   
  
  def friend
     
  end
   									

  #params
  # :friend, :message
  #													
  def invite_friend	
     
	  if can_send_invite && not_at_list(:email => params[:email]) && params[:email]
         create_invite(:email => params[:email],:message => params[:message])
      else
         flash[:notice] =  "Приглашения можно отправлять 1 раз в 15 минут" 
		flash[:notice] =  "email пуст"  if not params[:email]
      end
      
	  respond_to do |format|
        format.html { redirect_to :action => "friend" }
      end
  end
  
  
  def create_invite(options)
    unless wrong_format(options[:email])

	   #create new Invite	
       @invite = Invite.new(
       :sender_id => current_user.id,
       :user_id => nil,
       :model_name => "Email",
       :message => params[:message],
       :about =>  options[:email])
       
       #set in order of background server to delivering message
       session[:job_id] = Job.enqueue!(:NotifyMashine,
									   :invite_friend,
									   current_user.id,
									   options[:email],
									   options[:message]).id	
    
       if @invite.save
          flash[:notice] =  "Спасибо за отправку приглашения. #{options[:email]} получит ваше приглашение" 
       else
          flash[:notice] =  "Произошла ошибка. Попробуйте чуть позже" 
       end  
    else
       flash[:notice] = "Убедитесь что вы ввели правильный формат email #{options[:email]}" 
    end
  end

  def putup
    req = Justrequest.community_and_user params[:id], current_user
    req.destroy
    questions = Question.find_by_community_id params[:id], :select => :id
    ans = Answer.find :all,
					  :conditions => ["user_id = ? AND question_id IN (?)",current_user.id, questions]
    for an in ans
      an.destroy
    end
    
    if params[:do] == "d"
      flash[:notice] = "Вы смерились со судьбою"
      redirect_to :action => :deined
    else
      redirect_to :controller => "communities",:action => :hole, :id => params[:id]
    end
  end
  
  private
  
  
  def can_send_invite
      @emails = Invite.find :all, :conditions => ["model_name = ? AND sender_id = ? ","Email",current_user.id]
      unless @emails.nil?
        date_array = []
       for email in @emails
        date_array << email.created_at  
       end
        
       max_in_date_array = date_array.max 
       
       if max_in_date_array.eql?  Time.now - 15.minutes 
        return false #означает что пользователь больше не может отправить преглашение :)
                     #в течении 15 минут 
       else
        return true 
       end
      else
       return true
      end
  end
  
  def not_at_list(options)
  	@friend = User.find_by_email options[:email]

	if @friend.nil?
		return true
	else
		return false
    end
	
  end
  
  def wrong_format(email)

     #validate format email
     if email =~ /(.+)@(.+)/
       false
     else  
       true
     end
     
  end
  
  def current_destroy( parent_id )
    @invite = Invite.find_invite_for_user_and_community current_user.id, parent_id
    @invite.destroy
    #@invite.status = "refuse"
    #@invite.save!
  end
  
end
