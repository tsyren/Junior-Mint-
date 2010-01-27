class ActiveRecord::Base
  def self.validates_uri_existence_of(*attr_names)
    configuration = { :message => "не правильный или он не отвечает на запросы", :on => :save, :with => nil }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
 
    raise(ArgumentError, "A regular expression must be supplied as the :with option of the configuration hash") unless configuration[:with].is_a?(Regexp)
 
    validates_each(attr_names, configuration) do |r, a, v|
        if v.to_s =~ configuration[:with] # check RegExp
              begin # check header response
                  case Net::HTTP.get_response(URI.parse(v))
                    when Net::HTTPSuccess then true
                    else r.errors.add(a, configuration[:message]) and false
                  end
              rescue # Recover on DNS failures..
                  r.errors.add(a, configuration[:message]) and false
              end
        else
          r.errors.add(a, configuration[:message]) and false
        end
    end
  end
end

