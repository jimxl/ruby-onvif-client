require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoEncoderConfiguration < Action
            # c_token 的结构  // [ReferenceToken]  Token of the requested video encoder configuration.
            def run c_token, cb
                message = create_media_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoEncoderConfiguration) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        cfr = xml_doc.at_xpath("//trt:Configuration")
                        rcl = xml_doc.at_xpath("//tt:RateControl")
                        configuration = {
                            name: value(xml_doc, "//tt:Name"),
                            use_count: value(xml_doc, "//tt:UseCount"),
                            token: attribute(cfr,"token"),
                            encoding: value(xml_doc, "//tt:Encoding"),
                            resolution: {
                                width: value(_get_node(xml_doc, "//tt:Resolution"), "//tt:Width"),
                                height: value(_get_node(xml_doc, "//tt:Resolution"), "//tt:Height")
                            },
                            quality: value(xml_doc, "//tt:Quality"),
                            rateControl: {
                                frame_rate_limit: value(rcl, "tt:FrameRateLimit"),
                                encoding_interval: value(rcl, "tt:EncodingInterval"),
                                bitrate_limit: value(rcl, "tt:BitrateLimit")
                            },
                            multicast: {
                                address: {
                                    type: value(_get_node(xml_doc, "//tt:Multicast//tt:Address"), '//tt:Type'),
                                    ipv4_address: value(_get_node(xml_doc, "//tt:Multicast//tt:Address"), '//tt:IPv4Address'),
                                    ipv6_address: value(_get_node(xml_doc, "//tt:Multicast//tt:Address"), '//tt:IPv6Address')
                                },
                                port: value(_get_node(xml_doc, "//tt:Multicast"), "tt:Port"),
                                ttl: value(_get_node(xml_doc, "//tt:Multicast"), "tt:TTL"),
                                auto_start: value(_get_node(xml_doc, "//tt:Multicast"), "tt:AutoStart")
                            },
                            session_timeout: value(xml_doc, "//tt:SessionTimeout")
                        }
                        unless xml_doc.at_xpath('//tt:MPEG4').nil?
                            configuration[:mpeg4] = {
                                gov_length: value(_get_node(xml_doc, "//tt:MPEG4"), "//tt:GovLength"),
                                mpeg4_profile: value(_get_node(xml_doc, "//tt:MPEG4"), "//tt:Mpeg4Profile")
                            }
                        end
                        unless xml_doc.at_xpath('//tt:H264').nil?
                            configuration[:h264] = {
                                gov_length: value(_get_node(xml_doc, "//tt:H264"), "//tt:GovLength"),
                                h264_profile: value(_get_node(xml_doc, "//tt:H264"), "//tt:H264Profile")
                            }
                        end
                        callback cb, success, configuration
                    else
                        callback cb, success, result
                    end
                end
            end
            
            def _get_node parent_node, node_name
                parent_node.at_xpath(node_name)
            end
        end
    end
end
