module SearchHelper
  def findtype_rus(params)
   rus_type = case params
      when 'blog'
        'Запись'
      when 'human'
        'Человек'
      when 'community'
        'Сообщество'
      when 'tag'
        'Метка'
      when 'interes'
        'Интерес'
    end  
    
    return rus_type
  end
end
module SearchHelper
end
