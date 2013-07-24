require_relative 'service'
Dir.chdir __dir__ do
    require_dir 'event_handing'
end

module ONVIF
    class Event < Service
      # def initialize(args)
        
      # end      
    end
end




                # message = Message.new
                # message.body =  ->(xml) do
                #     xml.wsdl(:GetCapabilities) do
                #         unless options.nil?
                #             options.each do |option|
                #                 xml.wsdl :Category, option[:Category]
                #             end
                #         end
                #     end
                # end
                # send_message message do |success, result|
                #     if success



# EM.run do
#     device_management = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
#     device_management.get_network_protocols ->(success, result) {
#         puts result
#     }
# end

# <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:wsdl="http://www.onvif.org/ver10/device/wsdl">
#    <soap:Header/>
#    <soap:Body>
#       <wsdl:GetCapabilities>
#          <!--Zero or more repetitions:-->
#          <wsdl:Category>Events</wsdl:Category>
#       </wsdl:GetCapabilities>
#    </soap:Body>
# </soap:Envelope>