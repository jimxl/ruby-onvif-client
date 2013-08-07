require_relative "../lib/ruby_onvif_client"

EM.run do
    media = ONVIF::Media.new("http://192.168.2.133/onvif/Media", 'admin', '12345')
    media.GetProfiles ->(success, result) {
        puts result
    }
end

