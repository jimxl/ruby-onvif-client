require_relative "../lib/ruby_onvif_client"

message = ONVIF::Message.new
message.body =  ->(xml) do
    xml.wsdl(:GetDeviecInformation)
end
puts "onvif message test \n" + message.to_s
