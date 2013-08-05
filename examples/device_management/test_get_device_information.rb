require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://125.215.53.100:8082/onvif/device_service")
    device.get_device_information ->(success, result) {
    	puts '--------------', result, '============'
    }
end
