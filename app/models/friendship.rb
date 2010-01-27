class Friendship < ActiveRecord::Base
   #has_and_belongs_to_many :users
   belongs_to :user
   belongs_to :friend, :class_name => 'User', :foreign_key =>'friend_id'
end
