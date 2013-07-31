require_relative "../../lib/ruby_onvif_client"

EM.run do 
    event = ONVIF::Event.new("http://192.168.16.106/onvif/event_service")
    event.get_event_service_address ->(address) {
        puts "address=",address
        event.create_pull_point_subscription 'PT10S', ->(success, result) {
            if success
                puts "ooooooooooooook", result
                content = {}
                content[:time_out] = 'PT20S'
                content[:message_limit] = '2'
                event.pull_messages content, ->(success, result) {
                	if success
                		puts "pulllllllllllllll"
                        event.set_synchronization_point ->(success, result) {
                            puts "settttttttttttttttttt"
                        }
                	end
                } 
            end
        }      
    }    
   
end