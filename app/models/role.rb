class Role < ActiveRecord::Base
   has_and_belongs_to_many :users
   has_and_belongs_to_many :communities
   has_and_belongs_to_many :posts
end
