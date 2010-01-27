class Message < ActiveRecord::Base
  has_many :users
  validates_presence_of  :title,:message => '^Тема сообщения'
  validates_presence_of  :content, :message => '^Текст сообщения'
  validates_length_of   :title,  :minimum => 4
  validates_length_of   :content,  :minimum => 4

  def formatted_content
     formating(content)
  end
 
  private
  
  def formating(text)
    
    text.gsub(/(\n)/i,"<br />").lstrip.rstrip.chomp
    
  end
  
end
class Message < ActiveRecord::Base
  has_many :users
  validates_presence_of :title, :content, :reciever, :message => 'Нужно заполнить'
  
  def formated_content
    return RedCloth.new(@content).to_html
  end
 
end
