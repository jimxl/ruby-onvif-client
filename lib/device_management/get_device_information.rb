require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetDeviceInformation < Action
            def run callback
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetDeviecInformation)
                end
                send_message message do |success, result|
                    callback.call(success, result) if callback.class == Proc
                end
            end
        end
    end
end

