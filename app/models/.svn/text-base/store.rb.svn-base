class Store < ActiveRecord::Base
  #paperclip	
  has_attached_file :store
  validates_attachment_presence :store
  validates_attachment_content_type :store, :content_type => ["application/x-compressed",
						     "application/x-zip-compressed", "application/zip", "multipart/x-zip",
						     "application/excel","application/msword","application/doc","application/pdf","image/tiff",
						     "text/plain","application/plain","text/html","application/rtf",
						     "application/powerpoint","application/x-mspowerpoint","application/pdf","image/bmp",
						     "image/jpeg"]
   acts_as_taggable
   
   belongs_to :user
   
end
