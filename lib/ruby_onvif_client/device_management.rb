require_relative 'service'
Dir.chdir __dir__ do
    require_dir 'device_management'
end

module ONVIF
    class DeviceManagement < Service
    end
end

