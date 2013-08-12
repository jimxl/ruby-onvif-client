require_relative "../../lib/ruby_onvif_client"

EM.run do
    media = ONVIF::Media.new("http://192.168.2.133/onvif/Media", "admin", "12345")
    content = {
    	# :c_token => "" Optional
    	:p_token => "Profile_1" #Optional
    }#c_token, p_token
    media.get_video_encoder_configuration_options content, ->(success, result) {
    	puts '--------------', result, '============'
    }
end