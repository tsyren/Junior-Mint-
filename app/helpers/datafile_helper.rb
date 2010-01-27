module DatafileHelper
  def datafile_description
   
   rules = '' 
   rules =<<-END 
     Вы можете загружать JPG, GIF или PNG. Максимальный размер файла 5 Мб. 
     В случае возникновения проблем попробуйте загрузить фотографию меньшего размера.
   END
   
   return "<small>#{rules}</small>"
   
  end
end
module DatafileHelper
end
