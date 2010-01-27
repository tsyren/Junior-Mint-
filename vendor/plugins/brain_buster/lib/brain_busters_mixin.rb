# DEPRECATED in favor of just using filters (see: BrainBusterFilters), which is 
# cleaner and less obtrusive to your code.  

# This module will be removed in a future version!

# This mixin is intended to be mixed into your controller(s) that need captchas
module BrainBustersMixin

  def self.included(obj)
    obj.helper_method(:captcha_previously_passed?, :previous_captcha_attempt_failed?)
  end

  private

  # returns true if user passes captcha
  def captcha_passed?
    if captcha_previously_passed? || !BrainBuster.captcha_enabled?
      logger.debug { "BrainBuster previously passed or BrainBuster is not enabled." }
      return true
    end
    if __captcha_exists?
      captcha = BrainBuster.find(params[:captcha_id])
      if !captcha.attempt?(params[:captcha_answer])
        flash[:captcha_failed], flash[:error] = true, "Please double check your captcha answer below and try again..."
        params[:captcha_id] = captcha.id
        return false
      else
        __set_previously_passed
        return true
      end
    else
      flash[:error] = "There was an error with the captcha system - please retry."
      return false
    end
  end

  # returns true if user just had a previous captcha attempt fail
  def previous_captcha_attempt_failed?
    flash[:captcha_failed]
  end

  # returns true if user passed captcha previously in session
  def captcha_previously_passed?
    cookies[:captcha_passed] == "true"
  end
  
  # Internal methods below prefaced with "__" - you probably shouldn't be calling these directly
  
  # set cookie so we know the user has already passed a captcha
  def __set_previously_passed
    flash[:captcha_failed] = false
    cookies[:captcha_passed] = { :value => "true" }
  end

  def __captcha_exists?
    params[:captcha_id]
  end

end
