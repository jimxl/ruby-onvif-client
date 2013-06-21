require_relative 'service'
Dir.chdir __dir__ do
    require_dir 'device_management'
end

module ONVIF
    class DeviceManagement < Service
        def onvif_service_address
            "http://192.168.2.145/onvif/device_service"
        end
    end
end

