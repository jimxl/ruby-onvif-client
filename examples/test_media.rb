require_relative "../lib/ruby_onvif_client"

EM.run do
    media = ONVIF::Media.new("http://125.215.53.100:8082/onvif/device_service")
    media.GetProfile 'profile0_0', ->(success, result) {
        puts result
    }
end

