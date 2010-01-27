class EventsController < ApplicationController
  include ApplicationHelper
  before_filter :login_required
  layout :user_layout

  def index
	@user_events = EventsUser.find(:all, :conditions => ["user_id = ?  ", current_user.id ])
    
    if params[:id]
    @events = Event.find( :all,  :conditions => ["id IN (?) and started_on < ?",@user_events.collect(&:event_id),Time.now])
    else
    @events = Event.find( :all,  :conditions => ["id IN (?) and started_on > ?",@user_events.collect(&:event_id),Time.now], :select => :post_id)
    end
    
    @events = Post.find :all, :conditions => ["final = ? and id IN (?)","event", @events.collect(&:post_id) ]

    @events = Post.paginate @events, :page => params[:page], :per_page => 10
  end
  
  def  friends
    @user_events = EventsUser.find :all, :conditions => ["user_id IN (?)", current_user.friends.collect(&:id) ]
    
	@events = Event.find :all, :conditions => ["id IN (?)",@user_events.collect(&:event_id) ]
    
    @events = Post.find :all, :conditions => ["final = ? and id IN (?)","event", @events.collect(&:post_id) ]

    @events = Post.paginate @events, :page => params[:page], :per_page => 10
  end

  def participants
    @event = Event.find_by_post_id params[:id]

    #current participants
    @partis = @event.events_users

    #creator of event
    @user = User.find @event.user_id

    #not participants
    @users = User.find(:all, :conditions => ["id NOT IN (?)",@partis.collect(&:user_id)])

    respond_to do |format|
      format.html
    end
  end

  def taken
    @event = Event.find_by_post_id params[:id]
    
    invite = Invite.find_invite_for_user_and_event(current_user.id,@event.post_id)
    
    @participant = EventsUser.find :first, :conditions => {:user_id => current_user.id,:event_id => @event.id}
    
    if @participant.nil?
     event_user = EventsUser.new(:user_id => current_user.id,:event_id => @event.id)
     if event_user.save
      unless invite.nil?
      invite.status = "accepted"
      invite.save
      end 
      flash[:notice] ="Теперь вы участник события " + @event.post.title
      redirect_to :controller => "posts", :action => :show,:id => params[:id]
     else 
       flash[:notice] ="Что-то пошло не так. Попробуйте чуть позже"
       redirect_to :controller => "posts", :action => :show,:id => params[:id]
     end
    else
      flash[:notice] ="Вы уже участник или вам запретили учавствовать"
      redirect_to :controller => "posts", :action => :show,:id => params[:id]
    end
  end

  def cancle
    @post = Post.find params[:id]
    @response = Invite.find_all_by_model_id_and_sender_id  @post.id,current_user.id, :conditions => [ "status =? AND model_name = ?",  "waiting","Event"]
    if @response.nil?
      flash[:notice] = "Ошибочка"
      redirect_to :controller => "invites", :action => :index,:show => "eve",:type => :in
    else
      Invite.destroy(@response)
      flash[:notice] ="Приглашение отменены"
      redirect_to :controller => "invites", :action => :index,:show => "eve",:type => :out
    end
  end

  #участник отказывается от приглашения на участие
  def refuse
    @post = Post.find params[:id]
    @response = Invite.find_by_model_id_and_user_id  @post.id,current_user.id, :conditions => [ "status =? AND model_name = ?",  "waiting","Event"]
    if @response.nil?
      flash[:notice] = "Ошибочка"
      redirect_to :controller => "invites", :action => :index,:show => "eve",:type => :in
    else
      @response.update_attribute(:status,"refuse")
      flash[:notice]  = "Вы отказались учавствовать в мероприятии " + @post.title.capitalize.to_s
      redirect_to :controller => "invites", :action => :index,:show => "eve",:type => :in
    end
  end

  #пользователь больше не участник
  def drop
    @event = Event.find_by_post_id params[:id]
    
    begin
      @event.events_users do |u|
        u.destroy if current_user.id == u.user_id
      end
      flash[:notice] ="Теперь вы не участник события #{@event.post.title}"
      redirect_to :controller => "posts", :action => :show,:id => params[:id]
    rescue => e
      flash[:notice] ="Что-то случилось " + e.to_s
      redirect_to :controller => "posts", :action => :show,:id => params[:id]
    end
  end
end
