require_relative "../../lib/ruby_onvif_client"
require_relative "../../lib/ruby_onvif_client/server.rb"
EM.run do
	EM::start_server("0.0.0.0", 8080, ONVIF::Server)
    event = ONVIF::Event.new("http://192.168.16.106/onvif/event_service")
    event.get_event_service_address ->(address) {
        puts "address=",address
        content = {}
        content[:address] = 'http://192.168.16.251:8080/onvif_notify_server'
        content[:initial_termination_time] = 'PT10S'
        event.subscribe content, ->(success, result) {
            if success
                puts "ooooooooooooook", result
            end
        }      
    }    
   
end