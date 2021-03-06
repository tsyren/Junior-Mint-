require 'digest/sha2'
# Controller level system that actually does the work of creating and validating
# the captcha via filters, and also providing helpers for determining if the captcha was already
# passed or if a previous captcha attempt failed.
#
# This module gets mixed directly into ActionController::Base on init, so you
# can add the filters in whatever controller needs them.
module BrainBusterSystem

  # Expose helper methods and setup config for brain buster
  def self.included(obj)
    obj.helper_method :captcha_passed?, :last_captcha_attempt_failed?
    obj.class_eval do
      @@brain_buster_salt ||= "fGr0FXmYQCuW4TiQj/x3yPBTp5lcJ9l6DbO8CUpReDk="
      @@brain_buster_error_message = "Your captcha answer failed - please try again."
      @@brain_buster_enabled = true
      cattr_accessor :brain_buster_salt, :brain_buster_error_message, :brain_buster_enabled
    end
  end
  
  # Puts the BrainBuster model onto the controller
  def create_brain_buster
    raise_if_salt_isnt_set
    return true if (captcha_passed? || !brain_buster_enabled)
    debug_brain_buster { "Initializing the brain_buster object."}
    assigns[:captcha] = find_brain_buster
  end
  
  # Ensure that the answer attempt from the params successfully passes the captcha.
  # If it fails, captcha_failure is called, which by default will place an error message in the
  # flash and return false (therefore halting the filter chain).
  # If the captcha passes, this just returns true so the filter chain will continue.
  def validate_brain_buster
    raise_if_salt_isnt_set 
    return true if (captcha_passed? || !brain_buster_enabled)
    return captcha_failure unless (params[:captcha_id] && params[:captcha_answer])
      
    captcha = assigns[:captcha] = find_brain_buster
    is_success = captcha.attempt?(params[:captcha_answer])
    debug_brain_buster { is_success ? "Captcha successfully passed." : "Captcha failed - #{ captcha.inspect }" }
    set_captcha_status(is_success)
    return is_success ? captcha_success : captcha_failure
  end
  
  # Encrypting status strings and the like, as plain text in the cookies is bad for business
  def self.encrypt(str, salt)
    Digest::SHA256.hexdigest("--#{str}--#{salt}--")
  end

  # Has the user already passed the captcha, signifying we can trust them?
  def captcha_passed?
    cookies[:captcha_status] == encrypt("passed")
  end
  alias :captcha_previously_passed? :captcha_passed?
  
  # Determine if the last (and only the last) captcha attempt failed
  def last_captcha_attempt_failed?
    flash[:failed_captcha]
  end
  
  protected
  
  # Called when the captcha is passed
  # Override if you want to store the flag signallying a "safe" user somewhere else, of if you don't want to
  # store it at all (and therefore will challenge users each and every time.)
  def captcha_success
    return true
  end
  
  # Override this method for your own handling of captcha failure.
  # Just make sure it returns false if you want the filter chain to be halted when a captcha fails.
  def captcha_failure
    flash[:error] = brain_buster_error_message and return false
  end
  
  # Save the status of the captcha in a cookie.  If the captcha failed, we also store the id of the captcha in a cookie.
  # This is later checked in the filters to see if we should just bypass the captcha (if the captcha was passed before), 
  # or to see if we need to display the captcha error message.
  def set_captcha_status(is_success)
    status = is_success ? "passed" : "failed"
    flash[:failed_captcha] = params[:captcha_id] unless is_success
    cookies[:captcha_status] = encrypt(status)
  end

  # We raise an exception immediately if the brain_buster_salt isn't set.
  def raise_if_salt_isnt_set
    raise "You have to set the Brain Buster salt to something other then the default." if ActionController::Base.brain_buster_salt.blank?
  end
  
  # Find a captcha either from an id in the params or the flash, or just find a random captcha
  def find_brain_buster
    BrainBuster.find_random_or_previous(params[:captcha_id] || flash[:failed_captcha])
  end
  
  private

  # Log helper
  def debug_brain_buster(&msg)
    logger && logger.debug { msg.call }
  end
  
  def encrypt(str)
    BrainBusterSystem.encrypt(str, brain_buster_salt)
  end
  
end