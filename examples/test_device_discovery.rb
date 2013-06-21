require_relative "../lib/device_discovery"

EM.run do
    ONVIF::DeviceDiscovery.start do |device|
        puts device.inspect
        puts "=================="
    end
end

