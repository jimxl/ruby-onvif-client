require_relative "../../lib/ruby_onvif_client"

EM.run do
    media = ONVIF::Media.new("http://192.168.2.113/onvif/media_service", "admin", "nvrnvr888")
    media.get_profile "profile_D1", ->(success, result) {
    	puts '--------------', result, '============'
    }
end