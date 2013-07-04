require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoEncoderConfiguration < Action
            # c_token 的结构  // [ReferenceToken]  Token of the requested video encoder configuration.
            def run c_token, cb
                message = Message.new
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
                            mpeg4: {
                                gov_length: value(_get_node(xml_doc, "//tt:MPEG4"), "//tt:GovLength"),
                                mpeg4_profile: value(_get_node(xml_doc, "//tt:MPEG4"), "//tt:Mpeg4Profile")
                            },
                            h264: {
                                gov_length: value(_get_node(xml_doc, "//tt:H264"), "//tt:GovLength"),
                                h264_profile: value(_get_node(xml_doc, "//tt:H264"), "//tt:H264Profile")
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
                        
                        callback cb, success, configuration
                    else
                        callback cb, success, result
                    end
                end
            end
            def _get_profiles_supported xml_doc, parent_name
                this_node = xml_doc.at_xpath(parent_name)
                result_val = []
                this_node.each do |node|
                    result_val << node.content
                end
                return result_val
            end
            def _get_node parent_node, node_name
                parent_node.at_xpath(node_name)
            end

            def _get_each_val xml_doc, parent_name
                result_val = []
                xml_doc.each do |node|
                    result_val << _get_width_height(node, parent_name)
                end
                return result_val
            end

            def _get_min_max xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    min: value(this_node, "tt:Min"),
                    max: value(this_node, "tt:Max")
                }
            end

            def _get_width_height xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    width: value(this_node, "tt:Width"),
                    height: value(this_node, "tt:Height")
                }
            end
        end
    end
end
