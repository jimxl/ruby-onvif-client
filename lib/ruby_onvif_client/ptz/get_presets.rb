require_relative '../action'

module ONVIF
    module MediaAction
        class GetPresets < Action
            # p_token 的结构  
            # p_token = "xxxxx" //[ReferenceToken] A reference to the MediaProfile where the operation should take place.
            def run p_token, cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetPresets) do
                        xml.wsdl :ProfileToken, p_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        presets = []
                        xml_doc.xpath('//tptz:Preset').each do |node|
                            ptz_position = node.at_xpath("tt:PTZPosition")
                            pan_tilt = ptz_position.at_xpath("tt:PanTilt") unless ptz_position.nil?
                            zoom = ptz_position.at_xpath("tt:Zoom") unless ptz_position.nil?
                            preset = {
                                name: value(node, 'tt:Name'),
                                token: attribute(node, "token")
                            }
                            unless ptz_position.nil?
                                preset[:ptz_position] ={
                                    pan_tilt: {
                                        x: attribute(pan_tilt, "x"),
                                        y: attribute(pan_tilt, "y"),
                                        space: attribute(pan_tilt, "space")
                                    },
                                    zoom: {
                                        x: attribute(zoom, "x"),
                                        space: attribute(zoom, "space")
                                    }
                                }
                            end
                            presets << preset
                        end
                        callback cb, success, presets
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end