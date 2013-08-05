require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://125.215.53.100:8082/onvif/device_service")
    device.get_network_interfaces ->(success, result) {
    	puts '--------------', result, '============'
    }
end

# {:name=>"RTSP", :enabled=>"true", :port=>"554", :extension=>""}
# {:name=>"HTTP", :enabled=>"true", :port=>"80", :extension=>""}
