require_relative '../action'

module ONVIF
    module EventAction
        class SetSynchronizationPoint < Action
            def run cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetSynchronizationPoint)
                end
                send_message message do |success, result|
                    if success
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

