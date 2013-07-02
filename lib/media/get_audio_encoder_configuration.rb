require_relative '../action'

module ONVIF
    module MediaAction
        class GetAudioEncoderConfiguration < Action
            # c_token 的结构  
            #   c_token //[ReferenceToken]   Token of the requested audio encoder configuration.
            # 
            def run c_token, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetAudioEncoderConfiguration) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        success_result = {
                            configuration: {
                                name: value(xml_doc, '//tt:name'),
                                use_count: value(xml_doc, '//tt:UseCount'),
                                token: attribute(xml_doc, 'token'),
                                encoding: value(xml_doc, '//tt:Encoding'),
                                bitrate: value(xml_doc, '//tt:Bitrate'),
                                sample_rate: value(xml_doc, '//tt:SampleRate'),
                                multicast: {
                                    address: {
                                        type: value(xml_doc, '//tt:Type'),
                                        ipv4_address: value(xml_doc, '//tt:IPv4Address'),
                                        ipv6_address: value(xml_doc, '//tt:IPv6Address')
                                    },
                                    port: value(xml_doc, "//tt:Port"),
                                    ttl: value(xml_doc, "//tt:TTL"),
                                    auto_start: value(xml_doc, "//tt:AutoStart")
                                },
                                session_timeout: value(xml_doc, '//tt:SessionTimeout')
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
