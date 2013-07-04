require_relative "../lib/ruby_onvif_client"

EM.run do
    media = ONVIF::Media.new("http://192.168.2.145/onvif/media_service")
    media.GetVideoSourceConfigurations ->(success, result) {
        puts result
    }
end

