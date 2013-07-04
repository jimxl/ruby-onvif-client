require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetNetworkProtocols < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetNetworkProtocols)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        network = []
                        xml_doc.xpath('//tds:NetworkProtocols').each do |node|
                            network << {
                                name: value(node, 'tt:Name'),
                                enabled: value(node, 'tt:Enabled'),
                                port: value(node, 'tt:Port'),
                                extension: value(node, 'tt:Extension')
                            }
                        end

                        callback cb, success, network
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
