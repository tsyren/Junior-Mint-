class BookmarksController < ApplicationController
  include ApplicationHelper
  before_filter :login_required
  layout :user_layout, :except => [:rss]


  def index
   @bmarks = Bookmark.find :all, :conditions => { :user_id => current_user.id }
  end

  def new
    @post = Post.find(params[:id])
    bmark = Bookmark.new(:title => @post.title, :bookmarkable_id => @post.id,:user_id => current_user.id)
	  @post.bookmarks << bmark
	  respond_to do |format|
		 format.html {
        flash[:notice] = "Запись добавлена в закладки."
        redirect_to :controller => :posts, :action => :show, :id => @post.id }
	  end
  end

  def destroy
    @post = Post.find(params[:id])
    bmark = Bookmark.find(:first, :conditions =>{ :bookmarkable_id => @post.id })
    bmark.destroy
    respond_to do |format|
     format.html {
        flash[:notice] = "Закладка удалена"
        redirect_to  bookmarks_path
       }
    end
  end


  def faq
    render :update do |page|
          page[:faq].replace_html :partial => 'faq'
    end
  end

end
