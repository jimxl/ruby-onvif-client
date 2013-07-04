require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoSourceConfigurations < Action
            def run cb
                message = create_media_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoSourceConfigurations)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        configurations = []
                        xml_doc.xpath('//trt:Configurations').each do |node|
                            bounds = node.at_xpath('tt:Bounds')
                            configuration = {
                                name: value(node, 'tt:Name'),
                                use_count: value(node, 'tt:UseCount'),
                                token: attribute(node, 'token'),
                                source_token: value(node, 'tt:SourceToken'),
                                bounds: {
                                    x: attribute(bounds, "x"),
                                    y: attribute(bounds, "y"),
                                    width: attribute(bounds, "width"),
                                    height: attribute(bounds, "height")
                                },
                                extension: ""
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
