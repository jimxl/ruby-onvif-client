require_relative '../lib/path'
require_relative '../lib/device_management'

EM.run do
    device_management = ONVIF::DeviceManagement.new
    device_management.get_device_information ->(success, result) {
        puts success
        puts result
    }
end

