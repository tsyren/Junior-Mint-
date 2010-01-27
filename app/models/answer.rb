class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates_presence_of :answer, :message => "заполните ответ"
  
  def self.find_user_answers_of_community(user_id,community)
    find :all, :conditions => ["user_id = ? AND question_id IN (?)",user_id,community.questions ]
  end
  
  protected
  
  def validate
    errors.add_on_empty %w( answer )
  end
end
