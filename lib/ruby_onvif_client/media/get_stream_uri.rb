require_relative '../action'

module ONVIF
    module MediaAction
        class GetStreamUri < Action
            # options 的结构
            # {
            #    stream_setup: {
            #       stream: 'RTP-Unicast', //'RTP-Unicast', 'RTP-Multicast'
            #       transport: {
            #           protocol: 'UDP', //'UDP', 'TCP', 'RTSP', 'HTTP'
            #           tunnel:{
            #               protocol: 'TCP', //'UDP', 'TCP', 'RTSP', 'HTTP'
            #           }
            #       }
            #    }
            #    profile_token: "xxxxxxx" // [ReferenceToken]
            # }
            def run options, cb
                message = create_media_onvif_message namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:GetStreamUri) do
                        xml.wsdl(:StreamSetup) do
                            xml.sch :StreamType, options[:stream_setup][:stream_type]
                            xml.sch :Transport do
                                xml.sch :Protocol, options[:stream_setup][:transport][:protocol]
                                xml.sch :Tunnel do
                                    tunnel = options[:stream_setup][:transport][:tunnel]
                                    unless tunnel.nil? || tunnel.empty?
                                        xml.sch :Protocol,options[:stream_setup][:transport][:tunnel][:protocol]
                                        xml.sch :Tunnel,options[:stream_setup][:transport][:tunnel][:tunnel]
                                    end
                                end
                            end
                        end
                        xml.wsdl :ProfileToken, options[:profile_token]
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        media_uri = {
                            media_uri: {
                                uri: value(xml_doc, '//tt:Uri'),
                                invalid_after_connect: value(xml_doc, '//tt:InvalidAfterConnect'),
                                invalid_after_reboot: value(xml_doc, '//tt:InvalidAfterReboot'),
                                timeout: value(xml_doc, '//tt:Timeout')
                            }
                        }
                        callback cb, success, media_uri
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
