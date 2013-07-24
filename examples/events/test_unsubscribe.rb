require_relative "../../lib/ruby_onvif_client"

EM.run do 
    event = ONVIF::Event.new("http://192.168.16.106/onvif/event_service")
    event.get_event_service_address ->(address) {
        puts "address=",address
        content = {}
        content[:address] = 'http://192.168.16.197/onvif_notify_server'
        content[:initial_termination_time] = 'PT10S'
        event.subscribe content, ->(success, result) {
            if success
                puts "ooooooooooooook", result
                event.unsubscribe ->(success, result) {
                    if success
                        puts "unnnnnnnnnnnnnnnnn"
                    end
                end
            end
        }      
    }    
   
end