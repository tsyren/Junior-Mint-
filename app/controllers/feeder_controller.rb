require 'open-uri'
require 'hpricot'
require 'feed-normalizer'
require 'feed_finder'

class FeederController < ApplicationController
  layout 'users', :except => [:notes, :community]
  before_filter :login_required
  before_filter :permission_validate_include_moderator, :only => [:edit,:destroy,:update,:new]
  before_filter :is_member
  
  def new
    @feed = Feed.new
    @community = Community.find params[:id]
    
  end
  
  def checking
    @urls = Rfeedfinder.feeds(params[:feed][:url],
                        {
                         :from => "nsu1team@gmail.com",
						 :use_google => true
                        })  unless params[:feed][:url].empty?
    respond_to do |format|
      format.html { redirect_to :action => "new", :id => params[:id] }
      format.js do
       render :update do |page|
          if params[:feed][:url].empty?   
              page.replace_html "finded_urls", "Стоит указать источник"
                     
          elsif @urls.empty?
              
			  page.replace_html "finded_urls", "По указанному источнику не найдено ниодного канала RSS"
          else
              page.replace_html "step_title", "Шаг 2"
	          page.replace_html "finded_urls", "Список найденных канала для источника <b>" +params[:feed][:url].to_s+"</b><br /><br />"+@urls.join('<br />')
              @@urls_checked = true
              page.show "step_2"
              page.hide "step_1"
		  end	
       end
      end
    end
  end
  
  def create
    
    @feed = Feed.new params[:feed]
    @feed.encoding = "UTF-8"
    @community = Community.find params[:id]
    @feed.community_id = @community.id

    if @feed.save
      
      session[:job_id] = Job.enqueue!(:RssReader,:start_read,@feed.id).id
      flash[:notice] = 'Новый канал новостей готов.'
      redirect_to :action => 'show', :id => params[:id]
   
    else
      render_with_flash("new")
    end
    
  end
  
  #params[:id] is community id
  #
  def edit
    @feed = Feed.find_by_community_id params[:id]
    @community = Community.find params[:id]
  end
  
  def update
    @feed = Feed.find_by_community_id params[:id]
    @community = Community.find_by_id @feed.community_id
    
    if @feed.update_attributes(params[:feed])
      flash[:notice] = 'Канал успешно обновлен.'
      redirect_to :action => 'show',:id => @feed.community_id
    else
      flash[:error] = 'Возникли проблемы.'
      render :action => 'edit',:id => @feed.id
    end
  end
  
  def delete
    @feed = Feed.find_by_community_id params[:id]
    @feed.destroy
    redirect_to :action => 'show', :id => params[:id]
  end
  
  def show
  
    @community = Community.find params[:id]
    @feeds = Feed.find_all_by_community_id @community.id
        
  end
 
  protected

 
  
  def render_with_flash(url,flash = nil)
     flash[:notice] = flash unless flash.nil?
     render :action => url
  end

  private

  def permission_validate_include_moderator
     @community = Community.find params[:id]
     
     unless @community.admin(current_user,"include_moderator")
       redirect_to :controller => :communities, :action => :show,:id => @community.id
     end
  end
    
  def is_member
    @community = Community.find params[:id]
      
     unless @community.admin(current_user,"include_reader")
      redirect_to :controller => :communities, :action => :show,:id => @community.id and return false
     end
  
  end


end
