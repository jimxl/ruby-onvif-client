require_relative "../../lib/ruby_onvif_client"

EM.run do 
    event = ONVIF::Event.new("http://192.168.16.106/onvif/event_service")
    event.get_event_service_address ->(address) {
        puts "address=",address
        event.create_pull_point_subscription 'PT10S', ->(success, result) {
            if success
                puts "ooooooooooooook", result
            end
        }      
    }    
   
end