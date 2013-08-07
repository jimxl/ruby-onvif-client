require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://192.168.2.133/onvif/device_service","admin","12345")
    content = [{:Category => 'All'}]
    device.get_capabilities content, ->(success, result) {
    	puts '--------------', result, '============'
    }
end