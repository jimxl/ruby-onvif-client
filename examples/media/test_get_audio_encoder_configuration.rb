require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::Media.new("http://192.168.2.145/onvif/device_service")
    content = [{:Category => 'Events'}]
    device.get_audio_encoder_configuration content, ->(success, result) {
    	puts '--------------', result, '============'
    }
end