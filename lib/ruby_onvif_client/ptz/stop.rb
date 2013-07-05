require_relative '../action'

module ONVIF
    module PtzAction
        class Stop < Action
            # options 的结构
            # {
            #     profile_token: 'xxxxx', //[ReferenceToken]
            #     pantilt: 'xxxxx', // [string] A requested preset name.
            #     zoom: 'xxxxx', // [ReferenceToken]A requested preset token.
            # }
            def run options ,cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:Stop) do
                        xml.wsdl :ProfileToken, options[:profile_token]
                        xml.wsdl :PanTilt, options[:pantilt]
                        xml.wsdl :Zoom, options[:zoom]
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        preset_token = value(xml_doc, '//tptz:PresetToken')
                        callback cb, success, preset_token
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
