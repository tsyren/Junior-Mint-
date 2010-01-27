class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    Job.enqueue!(:NotifyMashine,:sign_up_part, user.id,user.check_password)
  end

  def after_save(user)

    Job.enqueue!(:NotifyMashine,:forgot_password, user.id) if user.recently_forgot_password?
    Job.enqueue!(:NotifyMashine,:send_activation, user.id) if user.pending?

  end
end
