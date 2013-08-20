require_relative "../../lib/ruby_onvif_client"

EM.run do 
    get_event_service_address "192.168.16.106", ->(address) {
        puts "address=",address
        event = ONVIF::Event.new(address)
        event.create_pull_point_subscription 'PT10S', ->(success, result) {
            if success
                puts "ooooooooooooook", result
                content = {}
                content[:time_out] = 'PT20S'
                content[:message_limit] = '2'
                event.pull_messages content, ->(success, result) {
                	if success
                		puts "pulllllllllllllll"
                	end
                } 
            end
        }      
    }    
   
end