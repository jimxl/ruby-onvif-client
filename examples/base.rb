require_relative "../lib/ruby_onvif_client"

EM.run do
    device_management = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service", 'test', 'test')
    device_management.get_users ->(success, result) {
        puts result
    }
end

