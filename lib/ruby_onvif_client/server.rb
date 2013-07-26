require 'eventmachine'
require 'em-http-server'

module ONVIF
  class Server < EM::HttpServer::Server
      # def post_init
      #     super
      # end

      def process_http_request
          puts  @http_request_method
          puts  @http_request_uri
          puts  @http_query_string
          puts  @http_protocol
          puts  @http_content
          puts  @http[:cookie]
          puts  @http[:content_type]
          # you have all the http headers in this hash
          puts  @http.inspect

          # response = EM::DelegatedHttpResponse.new(self)
          # response.status = 200
          # response.content_type 'text/html'
          # response.content = 'It works'
          # response.send_response
      end

      def http_request_errback e
          # printing the whole exception
          puts e.inspect
      end

  end
end

# EM::run do
#     EM::start_server("0.0.0.0", 8080, Server)
# end
    # the http request details are available via the following instance variables:


    #   @http_if_none_match
    #   @http_path_info
    #   @http_request_uri
    #   @http_post_content
    #   @http_headers
