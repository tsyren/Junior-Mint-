 require 'iconv'
 require 'net/http'
 require 'net/https'
 require 'rubygems'
 require 'simple-rss'
class RssReader
    
    def start_read(feed_id)
      feed = Feed.find feed_id
      com = Community.find feed.community_id
      encoding = define_encoding(feed.url)|| "utf-8"
      feed.update_attribute("encoding",encoding)

      news = SimpleRSS.parse(open(feed.url)).items
      news.each do |article|
         write_article(feed,article,com)
      end
      feed.update_attribute("updated_at",Time.now)
	 
    end
    
    def periodicaly_read_for_update_feeds
      feeds = Feed.observer
      for feed in feeds
        create_article(feed)
        feed.update_attribute("updated_at",Time.now)
      end
    end
  
    def create_article(feed)
      com = Community.find feed.community_id
      news = SimpleRSS.parse(open(feed.url)).items
      news.each do |article|
         write_article(feed,article,com)
      end
    end
  
    def write_article(feed,article,com)
     @signature = "<br /> источник: <a href='#{article.link}'>#{article.link}</a>"
      description = article.summary || article.description
      
      post = Post.new(:user_id => com.user_id, 
      :community_id => com.id,
      :title => to_utf(feed.encoding,article.title), 
      :content => to_utf(feed.encoding,description)+@signature,
      :status => 'external',
      :final => 'post')  
    
      post.save
    end
    
    def uniq(title)
      res = Post.find :all, :conditions => ["title = ?",title]
      if res.nil?
        true
      else
        false
      end 
    end

    def to_utf(encoding,text)
        textilize(Iconv.iconv("utf-8",encoding,text.to_s).join).to_s
    end
   
    def define_encoding(url)
     	url = URI.parse(url)
		  http = Net::HTTP.new(url.host, url.port)

		  http.open_timeout = http.read_timeout = 10  # Set open and read timeout to 10 seconds
 	 	  http.use_ssl = (url.scheme == "https")
        
		  headers = {
		    'User-Agent'          => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.12) Gecko/20080201 Firefox/3.0.0.1',
		    'If-Modified-Since'   => 'store in a database and set on each request',
		    'If-None-Match'       => 'store in a database and set on each request'
		  }
		    
		  response, body = http.get(url.path, headers)
		      
		  encoding = body.scan(
		   /^<\?xml [^>]*encoding="([^\"]*)"[^>]*\?>/
		  ).flatten.first
			  
  	  if encoding.nil?
     		if response["Content-Type"] =~ /charset=([\w\d-]+)/
			   encoding = $1.downcase
     		else
       		   encoding = "UTF-8"
		end
    	  end
    end
end
