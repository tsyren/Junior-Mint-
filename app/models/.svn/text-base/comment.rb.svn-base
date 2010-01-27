class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :content
  validates_length_of :content, :maximum => 3000

  def formatted_content
    return RedCloth.new(@content).to_html
  end
  
  
end
