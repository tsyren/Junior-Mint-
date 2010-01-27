desc "Write feed into table Posts"
task :write_feed => :environment do
    feeds = Feed.find :all, :conditions => {:community_id =>  ENV["COMMUNITY_ID"] }
      for feed in feeds
        lenta = SimpleRSS.parse(open(feed.url)).items
        lenta.each do |news|
          post = Post.new
          post.title = news.title
          post.content = news.description
          post.content += "<br>Источник: " + news.link
          post.user_id = ENV["CURRENT_USER_ID"]
          post.community_id =  ENV["COMMUNITY_ID"]
        end  
      end
end
