require_relative "../lib/ruby_onvif_client"

EM.run do
    ONVIF::DeviceDiscovery.start do |device|
        puts device.inspect
        puts "=================="
    end
end

