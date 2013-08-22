require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoSourceConfiguration < Action
            # c_token 的结构  
            #   c_token //[ReferenceToken]   Token of the requested audio encoder configuration.
            # 
            def run c_token, cb
                message = create_media_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoSourceConfiguration) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        parent_node = xml_doc.at_xpath('//trt:Configuration')
                        bounds = parent_node.at_xpath('tt:Bounds')
                        configuration = {
                            name: value(parent_node, 'tt:Name'),
                            use_count: value(parent_node, 'tt:UseCount'),
                            token: attribute(parent_node, 'token'),
                            source_token: value(parent_node, 'tt:SourceToken'),
                            bounds: {
                                x: attribute(bounds, "x"),
                                y: attribute(bounds, "y"),
                                width: attribute(bounds, "width"),
                                height: attribute(bounds, "height")
                            },
                            extension: ""
                        }
                        callback cb, success, configuration
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
