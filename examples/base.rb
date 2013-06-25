require_relative '../lib/path'
require_relative '../lib/device_management'

EM.run do
    device_management = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
    device_management.get_users ->(success, result) {
        puts result
    }
end

