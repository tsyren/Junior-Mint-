class NotifyMashine
   def new_comment(comment)
     
     UserMailer.deliver_new_comment_notification(comment)   #send to post author
     
     subscribers = Subscribe.find :all, :conditions => ["model_id = ? AND model_type = ? AND status = ?",comment.post_id,"Post","recieving"]
     users = User.find :all, :conditions => ["id IN (?)",subscribers.collect(&:user_id)]
     for user in users 
       UserMailer.deliver_comment_subscribe(user,comment) if user.id != comment.user_id
     end
   end
   
   def new_message(msg_id)     
     msg = Message.find msg_id
     UserMailer.deliver_new_letter_notification(msg)
   end
   
   def forgot_password(user_id)
     user = User.find user_id
     UserMailer.deliver_forgot_password(user)
   end
  
   def send_activation(user_id)
     user = User.find user_id
     UserMailer.deliver_activation(user)
   end
  
   def sign_up_part(user_id,password)
     user = User.find user_id
     UserMailer.deliver_signup_notification(user,password)
   end

   def invite_friend(user_id,email,msg)
	 user = User.find user_id
     unless email.nil? or email.empty? 	
   	 UserMailer.deliver_invite_friend(user,email,msg)
     else
     return "email is nil"
     end
   end	
end
