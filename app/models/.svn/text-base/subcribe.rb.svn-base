class Subcribes < ActiveRecord::Base
   belongs_to :communities
   
   validates_presence_of :url, :decription
   validates_length_of   :url,    :maximum => 255
   validates_length_of   :decription, :maximum => 1999
end
