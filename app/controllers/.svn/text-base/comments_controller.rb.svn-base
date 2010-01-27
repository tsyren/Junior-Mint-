class CommentsController < ApplicationController
  before_filter :login_required
  before_filter :can_create_comment
                  
  def new 
    @comment = Comment.new
  end

  def create
    if can_commentable
    
    @post = Post.find(params[:id]).comments.create!(params[:comment])
    @comments = Comment.find_all_by_post_id(params[:id])
    
    #background task
    session[:job_id] = Job.enqueue!(:NotifyMashine,:new_comment, @post).id
    
    respond_to do |format|
      format.html { redirect_to :action => "show", :id => @post.id }
      format.js {
      	render :update do |page|
       		page.insert_html :bottom, :comments, :partial => 'comments/comment', :object => @post
            page.replace_html :comments_count, @comments.size.rus_items('комментарий', 'комментария', 'комментариев')
        	page[:review_form].reset
        	page.delay(0.5){
            	page.visual_effect :highlight, 'comments', :duration => 1.5
        	}
        	
     	 end
      } 
    end
    end
  end

  def edit
    @comment = Comment.find params[:comment_id]
    @post = Post.find params[:id]
    respond_to do |format|
          format.html {
              redirect_to :action => 'show', :id => @post.id,:com_id => @post.community_id }
          format.js {
            render :update do |page|
              page.insert_html :comments, :partial => "edit_comment", :object => @comment
			  page.hide 'review_form'
            end
          }
    end
  end  
    
  def destroy
    @comment = Comment.find(params[:id]).destroy
    @post = Post.find @comment.post_id

    respond_to do |format|
          format.html { redirect_to :controller => :posts,:action => 'show', :id => @post.id,:com_id => 	@post.community_id  }
    end		
  end
  
  # unused 
  #
  # user subscribe new comment 
  # format: xml
  #
#  def rss
#    headers["Content-Type"] = "application/xml"
#    @comments = Comment.find :all, :conditions => ["post_id = ? ", params[:id]]
#    render :layout => false
#  end
  
  #
  # read comments whrough email
  #
  def email
    @sub = Subscribe.find :first, :conditions => ["user_id = ? AND model_id = ? AND model_type = ?", current_user.id,params[:id],"Post"]
    if @sub.nil? or @sub.status == "refused"
     @sub = Subscribe.new 
     @sub.user_id = current_user.id
     @sub.model_id = params[:id]
     @sub.model_type = "Post"
     @sub.status = "recieving"
     if @sub.save
       flash[:notice] = "Вы успешно подписались!"
       redirect_to :controller => :posts, :action => :show, :id => params[:id]
     else
       flash[:notice] = "Извените, произошла ошибка"
       redirect_to :controller => :posts, :action => :show, :id => params[:id]
     end  
    else
     flash[:notice]="Вы уже подписанны на этот пост"
     redirect_to :controller => :posts, :action => :show, :id => params[:id]
    end
   
  end
  
  private
  
  def can_commentable
    @post = Post.find params[:id]
    if @post.commentable == 1
      @can_commentable = true
    else
      @can_commentable = false
    end
    
    @can_commentable
  end
  
  #for private communities
  def can_create_comment
    @post = Post.find params[:id]
    if @post.status !="private"
     @community = Community.find @post.community_id unless @post.community_id == 0 else return true
     if @community.status.to_s == 'private'
      @member = CommunitiesUser.find :first, :conditions => { :community_id => @community.id, :user_id => current_user.id} if @post.community_id!=0
      if @member.nil?
       redirect_to post_path(params[:id])
      end
     end 
    end
  end
end
