# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
  def user_layout
      if logged_in?
        'users'
      else
        'default'
      end
  end
  
  def user_logged_in?
      session[:user_id]
  end
  
  def  check_friends
     @check_friends = Friendship.find( :all, :conditions => { :friend_id => current_user.id, :applied => 0 } )
  end 
  
  def link_title
     @link_title
  end 
  
  def newlink(link_title,link,rraw)
   	 
	 link_title << link
   
		 if rraw == 1 
			 link_title << "&nbsp;&rarr;&nbsp;" 
		 end		 
		 if rraw == -1 
			 link_title << "&nbsp;&#8594;&nbsp;" 
		 end
	end
   
  def add_to_title( name )
     @title = name.to_s
  end
  
  def title
     @title
  end
 
 
  def namegsub(name)
       name.gsub(" ","")
  end

  #
  # helper to view photo 
  # using attachment_fu lib
  # 
  def view_photo(object,type_of_avatar,thumbnail = nil)
    default = case type_of_avatar
       when "people"
         then image_tag('thumb_user.jpg') 
       when "community"  
         then image_tag("community.jpg")
       when "event"        
         then image_tag("event_default.gif", :size => "110x80")
      end
    if object
      image_tag(object.public_filename(:thumb)) unless thumbnail == nil
      image_tag(object.public_filename) if thumbnail == nil
    else
       default   
    end
  rescue ActionController::RoutingError => e
     default
  end
  
  # Returns a div
  def clear_div
    '<div class="clear"></div>'
  end
  
  
 
  #help to check params
  # example
  # if params_check(:object)
  # if params_check(:object, value)
  # if params_check([:object, :attribute])
  # if params_check([:object, :attribute], value)
  def params_check(*args)
    if args.length == 1
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && !params[args[0][0]][args[0][1]].nil?
          true
        end
      else        
        if params[args[0]] && !params[args[0]].nil?
          true
        end
      end
    elsif args.length == 2
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && params[args[0][0]][args[0][1]] == args[1]
          true
        end
      else
        if params[args[0]] && params[args[0]] == args[1]
          true
        end
      end  
    end
  end

  #more easy way to check params value
  #
  # 
  def params_valid(param,value)
    unless param.nil?
      if value == param
        return true
      else
       return false
      end  
    else
      return false
    end
  end
  
  def popup(title,options,&content)
     if title.kind_of?(Hash) # called like this: <%= popup :title => 'aaa', :partial => 'mypopupcontent' %>
        options = title
        title = options[:title]
      end

      close = "Закрыть"
      
      result = ''

      result << "<p><a href='#{options[:id]}' class='popup'>#{title} &raquo;</a><br /></p>"
      
      result << "<div class='popup' id='#{options[:id]}' style='display: none'>"
      
      result << content.to_s  if block_given?
      
      result << "<p class='popup_close'><a href='javascript: Element.closePopup('#{options[:id]}')'>#{close}</a></p></div></div>"   
     
      return result
  
  end
  
  def  rus_time_ago_in_words(from_time,include_seconds = false)
    
    rus_distance_of_time_in_words(from_time,Time.now,include_seconds)
    
  end
  
  def rus_distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs)/60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        case distance_in_minutes
          when 0..1
            return (distance_in_minutes == 0) ? 'меньше минуты' : '1 минуту' unless include_seconds
            case distance_in_seconds
              when 0..4   then 'менее чем 5 секунд'
              when 5..9   then 'менее чем 10 секунд'
              when 10..19 then 'менее чем 20 секунд'
              when 20..39 then 'пол минуты'
              when 40..59 then 'меньше минуты'
              else             '1 минуту'
            end

          when 2..44           then "#{distance_in_minutes} минут"
          when 45..89          then 'около 1 часа'
          when 90..1439        then "около #{(distance_in_minutes.to_f / 60.0).round} часов"
          when 1440..2879      then '1 день'
          when 2880..43199     then "#{(distance_in_minutes / 1440).round.rus_items("день","дня","дней") }"
          when 43200..86399    then 'около 1 месяца'
          when 86400..525599   then "#{(distance_in_minutes / 43200).round} месяцев"
          when 525600..1051199 then 'около 1 года'
          else                      "больше #{(distance_in_minutes / 525600).round} лет"
        end
  end
  
  def link_to_remote_unless_current(name, options = {}, html_options = {}, *parameters_for_method_reference, &block)
      if current_page?(options[:url])
        if block_given?
         block.arity <= 1 ? yield(name) : yield(name, remote_function(options), html_options, *parameters_for_method_reference)
        else
          name
        end
      else
        link_to_function(name, remote_function(options), html_options)
      end
  end
end
