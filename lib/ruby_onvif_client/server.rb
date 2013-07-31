require 'eventmachine'
require 'em-http-server'

module ONVIF
  class Server < EM::HttpServer::Server
      # def post_init
      #     super
      # end
      def initialize call_back
          @call_back = call_back
          super
      end

      def process_http_request
          puts "############################ #{__LINE__}"
          puts  @http_request_method
          puts "############################ #{__LINE__}"
          puts  @http_request_uri
          puts "############################ #{__LINE__}"
          puts  @http_query_string
          puts "############################ #{__LINE__}"
          puts  @http_protocol
          puts "############################ #{__LINE__}"
          puts  @http_content
          puts "############################ #{__LINE__}"
          puts  @http[:cookie]
          puts "############################ #{__LINE__}"
          puts  @http[:content_type]
          puts "############################ #{__LINE__}"
          # you have all the http headers in this hash
          puts  @http.inspect
          puts "############################ #{__LINE__}"
          puts @http_if_none_match
          puts "############################ #{__LINE__}"
          puts @http_path_info
          puts "############################ #{__LINE__}"
          puts @http_if_none_match
          puts "############################ #{__LINE__}"
          puts @http_post_content
          puts "############################ #{__LINE__}"
          puts @http_headers
          puts "############################ #{__LINE__}"
          puts @http_bodys

          result = parse_data @http_content
          # response = EM::DelegatedHttpResponse.new(self)
          # response.status = 200
          # response.content_type 'text/html'
          # response.content = 'It works'
          # response.send_response
          @call_back.call result
      end

      def http_request_errback e
          # printing the whole exception
          puts e.inspect
      end

      def parse_data data
          xml_doc = Nokogiri::XML(data)
          res = {}
          res[:topic] = xml_doc.xpath('//wsnt:Topic').first.content
          res[:time] = xml_doc.xpath('//tt:Message').first.attribute('UtcTime').value
          event_type = {}
          xml_doc.xpath('//tt:Source').each do |node|
              event_type[:name] = node.xpath('tt:SimpleItem').attribute('Name').value
              event_type[:value] = node.xpath('tt:SimpleItem').attribute('Value').value
          end
          res[:source] = event_type
          event_data = {}
          xml_doc.xpath('//tt:Data').each do |node|
              event_data[:name] = node.xpath('tt:SimpleItem').attribute('Name').value
              event_data[:value] = node.xpath('tt:SimpleItem').attribute('Value').value
          end
          res[:data] = event_data
          puts res
          res
      end
  end
end

# EM::run do
#     EM::start_server("0.0.0.0", 8080, Server)
# end
    # the http request details are available via the following instance variables:


    #   @http_if_none_match
    #   @http_path_info
    #   @http_post_content
    #   @http_headers


  # <SOAP-ENV:Body>
  #   <wsnt:Notify>
  #     <wsnt:NotificationMessage>
  #       <wsnt:Topic Dialect="http://www.onvif.org/ver10/tev/topicExpression/ConcreteSet">tns1:VideoAnalytics/tnsn:MotionDetection</wsnt:Topic>
  #       <wsnt:Message>
  #         <tt:Message UtcTime="2013-07-25T16:44:01">
  #           <tt:Source>
  #             <tt:SimpleItem Name="VideoSourceConfigurationToken" Value="profile_VideoSource_1"/>
  #           </tt:Source>
  #           <tt:Data>
  #             <tt:SimpleItem Name="MotionActive" Value="true"/>
  #           </tt:Data>
  #         </tt:Message>
  #       </wsnt:Message>
  #     </wsnt:NotificationMessage>
  #   </wsnt:Notify>
  # </SOAP-ENV:Body>
