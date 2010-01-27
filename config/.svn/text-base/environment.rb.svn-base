# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
  ENV['RAILS_ENV'] = 'production'

# Specifies gem version of Rails to use when vendor/rails is not present

RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

#before start the server be sure that your url is like this
#Rails url
RAILS_URL = "http://i-lab.nsu.ru/social_network/"

ENV['RECAPTCHA_PUBLIC_KEY'] = "6LepwAQAAAAAAEAT5RrXNw6Y91yf68XFYzyiLwDM"

ENV['RECAPTCHA_PRIVATE_KEY'] = "6LepwAQAAAAAAG2ZroTWflgpj3GAWxPYjwDZiqwa"

#SERVER_EXCEPTIONS = [TimeoutError,
#                      IOError,SMTP::SMTPUnknownError, Net::SMTPServerBusy, Net::SMTPAuthenticationError]
#                      
#CLIENT_EXCEPTIONS = [ Net::SMTPFatalError, Net::SMTPSyntaxError]
#
#SMTP_EXCEPTIONS = SERVER_EXCEPTIONS + CLIENT_EXCEPTIONS 



# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')



Rails::Initializer.run do |config|
 
  config.action_controller.session = {
    :session_key => '_mynsu_session',
    :secret      => '690b47f890b2603a34fb4536575c7f5460d3daef5ccbfc33204f98261561c62b6f8a4528a513d3cb06f5f1a74eb99067018115117fd2cbf75acf48e292922df5'
  }
   
  config.active_record.observers = :user_observer, :comment_observer
  

 
end

# Include your application configuration below
Time::DATE_FORMATS[:time] = "%H:%M"
Time::DATE_FORMATS[:date] = "%d.%m.%Y"
Time::DATE_FORMATS[:full] = "%d.%m.%Y %H:%M"

Date::MONTHS =  {"января" => 1, "февраля" => 2, "марта" =>3,
 "апреля" => 4, "майя" => 5, "июня" => 6,
 "июля" => 7, "августа" => 8, "сентября" => 9,
 "октября" => 10,"ноября" => 11,"декабря" => 12  }.invert 
#разделитель для тэгов
TagList.delimiter = ", "
		  
#переопределение классов
#класс Time
class Time
    alias :strftime_nolocale :strftime
		      
	def rus_date
	 format = "%d %m %Y в %H:%M"
	 format.gsub!(/%m/, Date::MONTHS[self.mon])
	 self.strftime_nolocale(format)
	end
end
#класс Целочисленных значений
class Integer
   def rus_items(form1, form2, form3)
    last_digit = to_s.to_i
    if last_digit == 1
      result = form1
    elsif last_digit >=2 && last_digit <=4
      result = form2
    else
      result = form3
    end

    return to_s + ' ' + result  
  end
end

#подключаемые модули
require 'will_paginate'
require 'simple-rss'  
require 'open-uri' 
require 'rubygems' 
require 'hpricot'
require 'validates_uri_existence_of'

#настройка отправки email
#ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "i-lab.nsu.ru", #наду будет заменить, когда будет домен

 :user_name => "mynsuadmin@gmail.com",
  :password => "bro20080921",
  :authentication  => :plain
}	


#обработка исключений и отправка их на email
#ExceptionNotifier.exception_recipients = %w(nsu1team@gmail.com)
#ExceptionNotifier.sender_address = %w(admin@social.nsu.ru)

#кэширование
if ENV['RAILS_ENV'] == "production" 
  ActionController::Base.page_cache_directory = "public/cached_pages"
  ActionController::Base.fragment_cache_store = :file_store, "#{RAILS_ROOT}/public/caches"
end
