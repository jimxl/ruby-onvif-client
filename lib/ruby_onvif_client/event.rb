require_relative 'service'
Dir.chdir __dir__ do
    require_relative_dir 'event_handing'
end

module ONVIF
    class Event < Service
      # def initialize(args)
        
      # end

        def get_event_service_address cb
            @res = {}
            device_management = ONVIF::DeviceManagement.new("http://192.168.16.106/onvif/device_service")
            content = [{:Category => 'Events'}]
            device_management.get_capabilities content, ->(success, result) {
                if success
                    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%success%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
                    #puts result
                    @res[:address] = result[:events][:x_addr]
                    @res[:subscription_policy_support] = result[:events][:wssubscription_policy_support]
                    @res[:pull_point_support] = result[:events][:wspull_point_support]
                    @res[:pausable_subscription_manager_interface_support] = result[:events][:wspsmis]
                    #puts @res
                    cb.call  @res[:address]
                end
            }
        end   
    end
end

# <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:wsdl="http://www.onvif.org/ver10/device/wsdl">
#    <soap:Header/>
#    <soap:Body>
#       <wsdl:GetCapabilities>
#          <!--Zero or more repetitions:-->
#          <wsdl:Category>Events</wsdl:Category>
#       </wsdl:GetCapabilities>
#    </soap:Body>
# </soap:Envelope>