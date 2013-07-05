require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoEncoderConfigurations < Action
            def run cb
                message = Message.new
                message.body = ->(xml) do
                    xml.wsdl(:GetVideoEncoderConfigurations)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        configuration = []
                        xml_doc.xpath('//trt:Configurations').each do |root_node|
                            success_result = {
                                name: value(root_node, "tt:Name"),
                                token: attribute(root_node, "token"),
                                use_count: value(root_node, "tt:UseCount"),
                                encoding: value(root_node, "tt:Encoding"),
                                resolution: {
                                    width: value(_get_node(root_node, "tt:Resolution"), "tt:Width"),
                                    height: value(_get_node(root_node, "tt:Resolution"), "tt:Height")
                                },
                                quality: value(root_node, "tt:Quality"),
                                rate_control: {
                                    frame_rate_limit: value(_get_node(root_node, "tt:RateControl"), "tt:FrameRateLimit"),
                                    encoding_interval: value(_get_node(root_node, "tt:RateControl"), "tt:EncodingInterval"),
                                    bitrate_limit: value(_get_node(root_node, "tt:RateControl"), "tt:BitrateLimit")
                                },
                                multicast: _get_multicast(root_node),
                                session_timeout: value(root_node, "tt:SessionTimeout")
                            }
                            unless root_node.at_xpath('//tt:MPEG4').nil?
                                success_result[:MPEG4] = {
                                    gov_length:  value(_get_node(root_node, "tt:MPEG4"), "tt:GovLength"),
                                    mpeg4_profile:  value(_get_node(root_node, "tt:MPEG4"), "tt:Mpeg4Profile")
                                }
                            end
                            unless root_node.at_xpath('//tt:H264').nil?
                                success_result[:H264] = {
                                    gov_length:  value(_get_node(root_node, "tt:H264"), "tt:GovLength"),
                                    h264_profile:  value(_get_node(root_node, "tt:H264"), "tt:H264Profile")
                                }
                            end
                            configuration << success_result
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
            def _get_multicast parent_node
                {
                    address: {
                        type: value(_get_node(parent_node, "//tt:Multicast//tt:Address"), '//tt:Type'),
                        ipv4_address: value(_get_node(parent_node, "//tt:Multicast//tt:Address"), '//tt:IPv4Address'),
                        ipv6_address: value(_get_node(parent_node, "//tt:Multicast//tt:Address"), '//tt:IPv6Address')
                    },
                    port: value(_get_node(parent_node, "//tt:Multicast"), "tt:Port"),
                    ttl: value(_get_node(parent_node, "//tt:Multicast"), "tt:TTL"),
                    auto_start: value(_get_node(parent_node, "//tt:Multicast"), "tt:AutoStart")
                }
            end
        end
    end
end
