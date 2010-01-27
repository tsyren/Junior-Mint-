# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'session'
   
  def new
  end
  
  def about
   
     render :layout => 'users'
    
  end
  
  def help
    @sub_title = 'help'
    @js_true = true
  end

  def rules
  end 
  
  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:email], params[:password])
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Вы успешно вышли!"
    redirect_back_or_default(RAILS_URL)
  end
  
  protected
  
  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url,:required => [:nickname,:email]) do |result, identity_url, registration|
      if result.successful?
        login_failed = false
         unless @user = User.find_by_identity_url(identity_url)
	  @user = User.new
	  unless registration['nickname'].nil?
	 
          @user.first_name = registration['nickname']
          @user.last_name = registration['nickname']
	  else
	  @user.first_name = identity_url
	  @user.last_name = identity_url
	  end
          @user.email = registration['email']
	  @user.identity_url = identity_url
	  
          if @user.save
           @profile = Profile.new(:user_id => @user.id,:access => 'public')
           @profile.save(false)
	   
          else
           failed_msg = "Что-то пошло не так. Извените за неудобства. " + @user.errors.full_messages.to_sentence
	   	   
	   login_failed = true
          end
        end
        self.current_user = @user
	
        unless login_failed
          successful_login
        else
          failed_login failed_msg
        end
      else
        failed_login result.message
      end
    end
  end
  
  def password_authentication(email, password)
    self.current_user = User.authenticate(email, password)
    if logged_in?
      successful_login
    else
      failed_login
    end
  end
  
  def failed_login(message = "Неверный пароль или email.")
    flash.now[:error] = message
    render :action => 'new'
  end
  
  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    redirect_to mypage_url
    flash[:notice] = "Авторизация прошла успешно."
  end
end
