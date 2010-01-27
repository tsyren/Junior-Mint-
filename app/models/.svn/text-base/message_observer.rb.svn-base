class MessageObserver < ActiveRecord::Observer
  
  def after_create(message) 
    UserMailer.deliver_new_letter_notification(message)
  end
 
end
