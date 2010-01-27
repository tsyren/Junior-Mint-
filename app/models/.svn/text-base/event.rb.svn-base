class Event < ActiveRecord::Base

  belongs_to :post
  has_many :events_users, :dependent => :destroy
  
  validates_presence_of :place, :started_on, :finished_on
  validates_length_of   :place, :maximum => 256

end
