module CommunitiesHelper
   def table_helper(&block)
     raise ArgumentError, 'Missing block in tableize call' unless block_given?
     
     start_table <<-END
     <div class="pmeta_bubble_bg"><div class=rounded_ul><div class=rounded_ur><div class=rounded_ll><div class=rounded_lr> 
     <table class="pmeta"> 
     END
     
     block.each do |elem|
       iterms <<  "<tr><td>#{elem}</td></tr>"
     end
     
     end_table <<-END 
     </table>
     </div></div></div></div></div>  
     END
     
     return start_table + iterms.to_s + end_table
   end
  
   def add_question_link(name)
     link_to_function name do |page| 
      page.insert_html :bottom, :question, :partial => 'regis_questions'
    end 
   end
 
   def up_conner
    @up_conner
    <<-END
      <div class='pmeta_bubble_bg'><div class=rounded_ul><div class=rounded_ur><div class=rounded_ll><div class=rounded_lr> 
      <table class='pmeta'>
     END
   end
    
   def down_conner
     @down_conner 
     <<-END
      </table>
      </div></div></div></div></div>  
     END
   end
  
   def edit(community)
     "<small>" + link_to( 'изменить', :action => 'edit', :id => community.id) +"</small>"
   end
   
   def rus_status(status)  
   @rus_status = case status.to_s
    when 'public'
      'открытый'
    when 'private'
      'закрытый'
    end 

    return @rus_status 
  end  
  
end
