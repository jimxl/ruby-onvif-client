require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class SetSystemFactoryDefault < Action
            # default_type = 'Hard' // 'Hard', 'Soft'   FactoryDefault 
            def run default_type, cb
                message = Message.new namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetSystemFactoryDefault) do
                        xml.wsdl :FactoryDefault, default_type
                    end
                end
                send_message message do |success, result|
                    #????
                    callback cb, success, result
                end
            end
        end
    end
end
