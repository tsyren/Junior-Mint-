class Question < ActiveRecord::Base
  belongs_to :community
  has_many :answers
  attr_accessor :should_destroy
  
  def should_destroy?
    
    should_destroy.to_i = 1
  end
end
