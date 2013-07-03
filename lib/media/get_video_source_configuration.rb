require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoSourceConfiguration < Action
            # c_token 的结构  
            #   c_token //[ReferenceToken]   Token of the requested audio encoder configuration.
            # 
            def run c_token, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoSourceConfiguration) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        bounds = xml_doc.at_xpath('//tt:Bounds')
                        success_result = {
                            configuration: {
                                name: value(xml_doc, '//tt:name'),
                                use_count: value(xml_doc, '//tt:UseCount'),
                                token: attribute(xml_doc, 'token'),
                                source_token: value(xml_doc, '//tt:SourceToken'),
                                bounds: {
                                    x: attribute(bounds, "x"),
                                    y: attribute(bounds, "y"),
                                    width: attribute(bounds, "width"),
                                    height: attribute(bounds, "height")
                                },
                                extension: ""
                            }
                        }
                        callback cb, success, success_result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
