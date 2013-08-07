require_relative "../lib/ruby_onvif_client"

EM.run do
    device_management = ONVIF::DeviceManagement.new("http://192.168.2.133/onvif/device_service", 'admin', '12345')
    device_management.get_network_protocols ->(success, result) {
        puts result
    }
end

