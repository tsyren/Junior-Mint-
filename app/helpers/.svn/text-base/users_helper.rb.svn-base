module UsersHelper
  def table_helper_profile_list(iterm,value)
     if value.blank? or value.eql? nil
       valid_value = "<font color='gray'>Информация &nbsp;отсутствует</font>"
     else
       valid_value = value
     end
     return <<-END
       <tr>
       <td> #{iterm }</td>
       <td>#{ valid_value }</td>

       </tr>
       END
  end
  
  
  def current_column(column)
    return true if current_user.profile.column.to_s == column
  end
  
  def marker
    "&uarr;"
  end
  
  def list_of_news_options
      
      {"События" => "events",
       "Записи в сообществах " =>"communities",
       "Записи друзей" => "friends",
       "Лента новостей"=>"everything"}
       
  end
  
  def list_of_access_options
      
      {"Друзья" => "private","Любой" =>"public","Никто" =>"custome"}
       
  end
  
end