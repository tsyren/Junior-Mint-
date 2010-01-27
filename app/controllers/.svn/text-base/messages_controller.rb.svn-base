class MessagesController < ApplicationController
    include ApplicationHelper
    include MessagesHelper
    before_filter :login_required
    before_filter :is_author,:except => [:inbox,:sended,:new,:create,:auto_complete_for_user_full_name]
    layout 'users'
  	auto_complete_for :user,:full_name

    def auto_complete_for_user_full_name
      name = params[:user][:full_name]
      
      find_options = { :conditions => ["LOWER(last_name) LIKE ? OR LOWER(first_name) LIKE ? ",'%' + name + '%','%' + name + '%'],:order => "last_name ASC" }
  
      @users = User.find(:all, find_options).sort_by {|u| u.id}
      
      @u = @users.collect(&:full_name)
      
      #@photos = Datafile.find_all_users_avatars(@users).sort_by {|u| u.user_id}
       
      #with photo
      #render :inline => "<%= content_tag(:ul, @u.map { |u| content_tag(:li, h(u))}) %><%= content_tag(:ul, @photos.map { |photo| content_tag(:li, view_photo(photo,'people')) })%>"
      
      #name with information
      render :inline => "<%= content_tag(:ul, @u.map { |u| content_tag(:li, h(u))}) %>"
      
    end

    # inbox messages
    # access: private
    # valid: not valid
    def inbox
      @messages = Message.find :all, :conditions => ["reciever = ?",current_user.id], :order => ["updated_at DESC"]
      @messages =  @messages.paginate :page => params[:page], :per_page => 15
    end


    # view instance message
    # access: private
    # valid: yes
    def sended
      @messages =  current_user.messages.reverse
      @messages =  @messages.paginate :page => params[:page], :per_page => 15
    end


    # view instance message
    # access: private
    # valid: yes
    def view
      @message =  Message.find params[:id]
      @sender = User.find @message.user_id
      @message.update_attribute(:status,0) if @message.status == 1 && current_user.id == @message.reciever
    end

    
    # view instance message
    # access: private
    # valid: yes
    def new
       @message = Message.new
       if params[:id]
         @replay_msg = Message.find params[:id]
         @user = User.find @replay_msg.user_id
         @message.title = "Re: " + @replay_msg.title.gsub(/(Re:)/i," ").split("  ").join
       end
       if params[:user_id]
         @user = User.find params[:user_id]
       end
    end

    # view instance message
    # access: private
    # valid: yes
    def create

      @message = Message.new(params[:message])
      
      if params[:user_id].nil?
        
        full_name = params[:user][:full_name].split(" ")
        last_name = full_name[1].capitalize if full_name[1]
        first_name = full_name[0].capitalize if full_name[0]
  
        #identify by full name
        @users = User.find :all, :conditions => ["last_name = ? AND first_name = ?", last_name, first_name]
      
    
        if @users.nil?
          flash[:notice] = "Пользователь " + params[:user][:full_name].to_s + " не найден"
          render :action => 'new'
        else
          if @users.size.to_i == 1
          
            for user in @users      
              @user = user
            end
          send_message(@message,current_user.id,@user.id)
          if params[:id]
            save_sended(@message,:id => params[:id])
          else
            save_sended(@message)
          end
            
          else
            flash[:error] = "В система найдено #{@users.size.to_s} участника. <br />Уточните кому высобираетесь отправить сообщение:<br />" + @users.map{ |u| "<a href='new?user_id=#{u.id}'>#{u.full_name} </a>"}.join('<br />') + ""
            render :action => 'new'
          end
         end
      else
        send_message(@message,current_user.id,params[:user_id])
        save_sended(@message,:id => params[:id])
      end
    end

    # view instance message
    # access: private
    # valid: yes
    def delete
      Message.find(params[:id]).destroy
      respond_to do |format|
       format.html {
         flash[:notice] = "Сообщение удалено"
         redirect_to messages_url
       }
      end
    end

   private

   # checking if current_user is a author messages
   # run before filter
   #
   def is_author
     @msg =  Message.find params[:id]
     if current_user.id == @msg.user_id || current_user.id == @msg.reciever
       return true
     else
       redirect_to :action => :inbox
     end
   end
 
   def send_message(message,sender,reciever)
     
     message.user_id = sender
     
     message.reciever = reciever
   
     message.status = 1
     
  end
   
  def save_sended(message,params = nil)
    if request.post? && message.save #after save sending notify message
            
     #deliver through background_fu
     session[:job_id] = Job.enqueue!(:NotifyMashine,:new_message, message.id).id
     
     flash[:notice] = 'Сообщение было отправленно'
     redirect_to :action => "inbox"
             
    else
      flash[:notice] = 'Извените, произошла ошибка при отправке'
       if params[:id]
        @replay_msg = Message.find params[:id]
        @user = User.find @replay_msg.user_id
       end
      render :action => 'new'
     end
  end
 
end





