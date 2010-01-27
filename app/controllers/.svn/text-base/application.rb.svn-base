require 'stringio'
require 'zlib'
class ApplicationController < ActionController::Base
 
  #after_filter { |c| c.response.body = ActiveSupport::Gzip::compress(c.response.body) }
  # after_filter :compress

  include AuthenticatedSystem
  include HoptoadNotifier::Catcher

  helper :all
  session :session_key => '_SocialNetWork_session_id'
  skip_before_filter :verify_authenticity_token


 
  private

  #def compress
#    if self.request.env['HTTP_ACCEPT_ENCODING'].match(/gzip/)
#      if self.response.headers["Content-Transfer-Encoding"] != 'binary'
#        begin 
#          ostream = StringIO.new
#          gz = Zlib::GzipWriter.new(ostream)
#          gz.write(self.response.body)
#          self.response.body = ostream.string
#          self.response.headers['Content-Encoding'] = 'gzip'
#        ensure
#          gz.close
#        end
#      end
#    end
 # end

 
end
