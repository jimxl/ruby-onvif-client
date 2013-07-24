require_relative '../action'

module ONVIF
    module EventAction
        class Subscribe < Action
            def run options, cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl', :'xmlns:a' => "http://www.w3.org/2005/08/addressing", 'xmlns' => "http://docs.oasis-open.org/wsn/b-2"}
                message.body =  ->(xml) do
                    xml.Subscribe do
                        xml.wsdl(:ConsumerReference) do
                            xml.a :Address, options[:address]
                        end
                        xml.wsdl :InitialTerminationTime , options[:initial_termination_time]
                    end
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

 # <Subscribe xmlns="http://docs.oasis-open.org/wsn/b-2">
 #      <ConsumerReference>
 #        <a:Address>http://192.168.16.197/onvif_notify_server</a:Address>
 #      </ConsumerReference>
 #      <InitialTerminationTime>PT10S</InitialTerminationTime>
 #    </Subscribe>