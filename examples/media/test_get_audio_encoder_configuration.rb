require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::Media.new("http://192.168.2.133/onvif/Media","admin", "12345")
    device.get_audio_encoder_configuration "AudioEncoder_1", ->(success, result) {
    	puts '--------------', result, '============'
    }
end