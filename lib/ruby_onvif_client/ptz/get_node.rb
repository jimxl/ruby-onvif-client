require_relative '../action'

module ONVIF
    module PtzAction
        class GetNode < Action
            # node_token 的结构 //[ReferenceToken] Token of the requested PTZNode.
            def run node_token ,cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetNode) do
                        xml.wsdl :NodeToken, node_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        preset_token = value(xml_doc, '//tptz:PTZNode')
                        callback cb, success, preset_token
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
