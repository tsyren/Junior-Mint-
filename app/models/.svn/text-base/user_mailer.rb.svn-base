class UserMailer < ActionMailer::Base
  def signup_notification(user,password)
    setup_email(user)
    @subject    += 'Активация!'
    @body[:url]  = RAILS_URL + "activate/#{user.activation_code}"
    @body[:password]  = password
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Успешная активация!'
    @body[:url]  = RAILS_URL + "login"
  end

  def forgot_password(user)
    setup_email(user)
    @subject    += 'Ссылка на новый пароль'
    @body[:url]  = RAILS_URL + "reset_password/#{user.password_reset_code}"
  end

  def send_feedback(user,feedback)
    @subject = "New feed back from #{user.email}"
    @from = user.email
    @recipients  = "nsu1team@gmail.com"
    @sent_on     = Time.now

    body[:user] = user
    body[:feedback] = feedback
  end

  def invite_friend(user,friend, message = nil)

    @recipients  = friend.to_s
    @from        = "nsu1team@gmail.com"
    @subject     = "[My NSU]"
    @content_type = "text/html"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:best_regards] = "--<br/> Всего наилучшего, команда My NSU.﻿ "
    @subject += "Приглашение от #{user.full_name}"
   

    body[:user] = user
    body[:message] = message unless message.nil?
    body[:url] = RAILS_URL
    body[:about] = <<-END
         <p><b>MyNSU</b> задумывалось, как место где:<br/>
        &nbsp;- студенты могут общаться между собой, осуждать вопросы связанные с учебой и не только<br/>
        &nbsp;- студенты могут общаться с преподавателями<br/>
        &nbsp;- студенты могут выкладывать учебные материалы, делится интересными ссылками и тд<br/>
        &nbsp;- можно найти самую свежую информациию о учебной и внеучебной жизни Университета<br/><br/>

        Проект разрабатывается самими студентами, и сейчас находится в стадии активного становления и бета-тестирования,
        еще не все работает так, как нам хотелось, но уже можно зарегисрироваться и посмотреть что это такое :)</p>
    END
  end

  #The notification arrive when
  #someone comment the post, which user have subscribed
  def new_comment_notification(comment)

    blog = Post.find comment.post_id
    sender = User.find comment.user_id
    blog_owner = User.find blog.user_id
    #@subscribe = Subscribe.find :all, :conditions => ["model_id = ? and model_type = ?",blog.id, "Post"],:select => ["user_id"]
    #@subscribers = User.find :all, :conditions => ["id in (?)",@subscribe], :select => ["email"]
    setup_email(blog_owner)

    @subject += "У ваc новый комментарий"

    body[:comment]= comment
    body[:from_who] = sender
    body[:url] = RAILS_URL +  "posts/show/#{comment.post_id}#comments"

  end

  #The notification arrive when
  #someone post to community user have subscribed
  def new_post_notification(post)
    #author
    reciever = User.find_by_id post.user_id
    setup_email(reciever)
    @subject +="Новый пост в вашем сообществе"
    body[:url] = RAILS_URL + "posts/show/#{post.id}"
    body[:post] = post
  end

  #The notification arrive when
  #user have new personal message
  def new_letter_notification(message)
    sender = User.find message.user_id
    reciever = User.find message.reciever
    setup_email(reciever)
    @subject += "Вам пришло личное сообщение от #{sender.full_name}"
    body[:sender] = sender
    body[:message] = message
    body[:url] = RAILS_URL + "messages/view/#{message.id}"
  end

  def comment_subscribe(user,comment)
    
    
    setup_email(user)
    @subject += "Новый комментарий"

    body[:user]= user
    body[:comment] = comment
    body[:url] = RAILS_URL + "posts/show/#{comment.post_id}#comments"
    
  end

  def posts_subscribe(user,com_id)
    posts = Post.find :all, :conditions => ["community_id = ? ", com_id]
    community = Community.find com_id
    setup_email(user)
    @subject += "Подписка на новые записи"

    body[:posts] = posts
    body[:community] = community
    body[:url] = RAILS_URL + "communities/posts/#{com_id}"
  end

  protected
  
  
  def setup_email(user,many = nil)
    @recipients  = "#{user.email}" if many.eql? nil
    @recipients += many.collect(&:email).join(', ') unless many.eql? nil
    @from        = "nsu1team@gmail.com"
    @subject     = "[My NSU]"
    @content_type = "text/html"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:best_regards] = "--<br/> Всего наилучшего, команда My NSU.﻿ "
  end

end
