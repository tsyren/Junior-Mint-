require 'open-uri'
require 'hpricot'
require 'feed-normalizer'

class Feed < ActiveRecord::Base
  belongs_to :community
    
  validates_presence_of :name,:url, :description
  validates_length_of   :name,    :maximum => 255
  validates_length_of   :url,  :maximum => 255
  validates_length_of   :description,  :maximum => 3000
  validates_uri_existence_of :url, :with =>
        /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  def self.observer
   Feed.find :all, :conditions => ["updated_at < ?",Time.now - 15.minutes]
  end
 
 
  def self.resource_has_rss_link(url)
     
      if  get_rss_link(url)
         true
      else
         false
      end  

  end

  def get_rss_link(url)
      doc = Hpricot(open(url))
      #if is not doc				
      unless doc.doc?
        return nil
      else
       if doc.xmldecl?	#if XML
        return url	
       else
        links = doc.search("/html/head//link")
        links.each do |link|
    	 if link.attributes['type'] == "application/rss+xml"
	  return link.attributes['href']
	 end 
        end		
	end	
      end
  end
  
  def idendify_encoding(url)
  
  end
end
