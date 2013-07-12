require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
    device.get_users ->(success, result) {
    	puts '--------------', result, '============'
    }
end