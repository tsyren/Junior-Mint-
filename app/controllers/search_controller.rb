require 'iconv'
#require 'whatlanguage'
class SearchController < ApplicationController
    layout 'users'
    before_filter :login_required
    
    def index
       @title = 'Поиск'
       unless params[:query].blank?

       @search = params[:query].to_s.chars.downcase
       
       
        case params[:findtype]
          when 'blog'
            then Post.simply_reindex!
                 @results = Post.indexers[0].query(@search)
          when 'human' 
            then 
		 User.simply_reindex!
                 @results = User.indexers[0].query(@search)
          when 'community' 
            then Community.simply_reindex!
                 @results = Community.indexers[0].query(@search)
          when 'interes' 
            then @results_communities = Community.find_tagged_with(@search)
                 @results_users = User.find_tagged_with(@search)
            
          when 'tag' 
            then @results = Post.find_tagged_with(@search)
        end
        

      else
        render :action =>'index'
      end
    end			
end
