class DatafileController < ApplicationController
  layout 'users'
  include AuthenticatedSystem
  before_filter :login_required

  def index
    respond_to do |format|
	format.html { redirect_to :action => 'new' }
    end
  end

  def new
    @at_file = Datafile.new
  end

  def newphoto

  end

  def avatarcom
      @community = Community.find params[:id]
  end

  def avatarcomupdate
      @community = Community.find params[:id]
      @photo = Datafile.find_avatar_by_community_id(@community)
  end

  def changephoto
    @photo = Datafile.find(:first,:conditions => [" user_id = ? AND model_id = 0 AND avatar=1",current_user.id])
  end

  def create
    @at_file = Datafile.new(params[:at_file])
    @at_file.user_id = current_user.id
    @at_file.model_id = params[:com_id]
    @at_file.model_name = "Community"

	respond_to do |format|
    if @at_file.save
      flash[:notice] = 'Файл  успешно загружен'
      format.html
    else
	  flash[:notice] = 'Файл не был загружен'
      format.html
    end
	end
  end

  #test function
  #
  def start_task
    render :update do |page|
      page.replace_html 'progress', content_tag("div", "0%", { :id => "progress-value", :style => "width:0; background:none; color:#000;" })
      page.show 'progress'
      page << remote_function( :url => { :action => 'show_progress', :progress => 10  } )
    end
  end

  #test function
  #called from start_task
  def show_progress
    progress = params[:progress].to_i
    if progress >= 100
      render :update do |page|
        page.replace_html 'progress', content_tag("div", "Загрузка завершена", { :id => "progress-complete" })
        page.visual_effect :highlight, 'progress', :duration => 2
        page.delay(5) { page.hide 'progress' }
      end
    else
      render :update do |page|
        page.delay(0.5) do
          page.replace_html 'progress', content_tag("div", "#{progress}%", { :id => "progress-value", :style => "width:#{progress}%;" })
          page << remote_function( :url => { :action => 'show_progress', :progress => progress + 10  } )
        end
      end
    end
  end

  #загрузка фото-аватара юзера
  def createphoto
   return unless request.post?
    @file = Datafile.new(params[:userphoto])
    @file.user_id = current_user.id
	  @file.model_id = 0
	  @file.avatar = 1


	respond_to do |format|
	if @file.save
      flash[:notice] = 'Аватар был успешно заргужен'
	  format.html { redirect_to myprofile_url }
	else
      format.html { render :action => 'newphoto' }
    end
	end

	rescue ActiveRecord::RecordInvalid
	render myprofile_url
  end

  #Смена  фото-аватара юзера
  def updatephoto
    return unless request.post?

    @user = User.find current_user.id
    @photo = Datafile.find(:first,:conditions => [" user_id = ? AND model_id = 0 AND avatar=1",current_user.id])

    respond_to do |format|
    if @photo.update_attributes(params[:userphoto])
         flash[:notice] = "Аватар был успешно сменен"
     format.html { redirect_to myprofile_url }
    else
         flash[:notice] = "Это не фото"
     format.html { render :action => 'changephoto' }
    end

    end
  rescue ActiveRecord::RecordInvalid
     render  myprofile_url
  end

  def upload_image
    return unless request.post?
    @file = Datafile.new(params[:eventphoto])
    @file.user_id = current_user.id
    @event = Event.find params[:id]
    @file.model_id = @event.id
    @file.model_name = "Event"
    @file.avatar = 1

    respond_to do |format|
    if @file.save
      format.html {
        flash[:notice] = 'Изображение успешно заргужено'
        redirect_to :controller => 'events', :action => 'edit', :id => params[:id] }

    else
        flash[:error] = "Ошибка загруки файла"
        format.html { redirect_to :controller => 'events', :action => 'edit', :id => params[:id] }
    end
    end

  end

   #Создание  фото-аватара сообщества
  def createphotocom
   return unless request.post?
    @file = Datafile.new(params[:userphoto])
    @file.user_id = current_user.id
    @community = Community.find_by_id params[:id]
    @file.model_id = @community.id
    @file.model_name = "Community"
    @file.avatar = 1

    respond_to do |format|
    if @file.save
      format.html {
        flash[:notice] = 'Аватар был успешно заргужен'
        redirect_to :controller => 'communities', :action => 'show', :id => params[:id] }

    else
        flash[:error] = "Ошибка загруки файла: такой файл уже загружался или вы пытайтесь закачать не фото"
        format.html { render :action => :avatarcom, :id => params[:id] }
    end
    end

  rescue ActiveRecord::RecordInvalid
    render mypage_url
  end

  #Смена  фото-аватара сообщества
  def updatephotocom
    return unless request.post?
    @community = Community.find params[:id]
    @photo = Datafile.find_avatar_by_community_id(@community)

    respond_to do |format|
    if @photo.update_attributes(params[:userphoto])
        format.html { redirect_to :controller => 'communities', :action => 'show', :id => params[:id]  }
    else
        format.html {
          flash[:notice] = "Такой файл существует или вы пытайтесь закачать не изображение"
          render  :action => 'avatarcomupdate', :id => params[:id]
        }
    end
    end
  rescue ActiveRecord::RecordInvalid
	render mypage_url
  end

  def delete
    @file = Datafile.find_by_user_id_and_avatar current_user, 1
    @file.destroy

    respond_to do |format|
       format.html { redirect_to myprofile_path  }
    end
  end

  def destroy
    @file = Datafile.find_by_model_id_and_model_name params[:id], "Community"
    @file.destroy

    respond_to do |format|
       format.html { redirect_to :controller => 'communities', :action => 'show', :id => params[:id]  }
    end
  end

end
