require_relative "../../lib/ruby_onvif_client"
require_relative "../../lib/ruby_onvif_client/server.rb"
EM.run do
	cb = ->(res) {
		puts "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",res
	}
	EM::start_server("0.0.0.0", 8080, ONVIF::Server, cb) do |conn|
		conn.instance_eval do
			# conn.process_http_request -> {
			# 	puts "mmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
			# }
			puts "lllllllllllllllllll",@http_content,"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
		end
	end
    get_event_service_address "192.168.16.106", ->(address) {
        puts "address=",address
        content = {}
        content[:address] = 'http://192.168.16.251:8080/onvif_notify_server'
        content[:initial_termination_time] = 'PT10S'
        event = ONVIF::Event.new(address)
        event.subscribe content, ->(success, result) {
            if success
                puts "ooooooooooooook", result
                event.set_synchronization_point ->(success, result) {
                	if success
                		puts "set sync point ok", result
                	end
                }
            end
        }      
    }    
   
end

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
