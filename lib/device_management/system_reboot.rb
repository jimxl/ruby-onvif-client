require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class SystemReboot < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:SystemReboot)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        message = {
                            msg: value(xml_doc, '//tds:Message')
                        }
                        callback cb, success, message
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
