require_relative '../action'

module ONVIF
    module MediaAction
        class GetAudioSourceConfigurations < Action
            def run cb
                message = create_media_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetAudioSourceConfigurations)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        configurations = []
                        xml_doc.xpath('//trt:Configurations').each do |node|
                            configuration = {
                                name: value(node, 'tt:Name'),
                                use_count: value(node, 'tt:UseCount'),
                                token: attribute(node, 'token'),
                                source_token: value(xml_doc, '//tt:SourceToken')
                            }
                            configurations << configuration
                        end
                        callback cb, success, configurations
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
