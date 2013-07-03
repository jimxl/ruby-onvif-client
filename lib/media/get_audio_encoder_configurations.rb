require_relative '../action'

module ONVIF
    module MediaAction
        class GetAudioEncoderConfigurations < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetAudioEncoderConfigurations)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        configurations = []
                        xml_doc.xpath('//trt:Configurations').each do |node|
                            bounds = node.xpath('tt:Bounds')
                            multicast = node.xpath('tt:Multicast')
                            address = multicast.xpath('tt:Address')
                            configuration = {
                                name: value(node, 'tt:Name'),
                                use_count: value(node, 'tt:UseCount'),
                                token: attribute(node, 'token'),
                                encoding: value(node, 'tt:Encoding'),
                                bitrate: value(node, 'tt:Bitrate'),
                                sample_rate: value(node, 'tt:SampleRate'),
                                
                                multicast: {
                                    address: {
                                        type: value(address, 'tt:Type'),
                                        ipv4_address: value(address, 'tt:IPv4Address'),
                                        ipv6_address: value(address, 'tt:IPv6Address')
                                    },
                                    port: value(multicast, "tt:Port"),
                                    ttl: value(multicast, "tt:TTL"),
                                    auto_start: value(multicast, "tt:AutoStart")
                                },
                                session_timeout: value(node, 'tt:SessionTimeout')
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
