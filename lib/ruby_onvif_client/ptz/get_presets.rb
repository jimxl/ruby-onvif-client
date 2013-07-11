require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetPresets < Action
            include PtzCommon  #get_speed()
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
                            preset = {
                                name: value(node, 'tt:Name'),
                                token: attribute(node, "token")
                            }
                            preset = get_speed node, "PTZPosition", preset
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