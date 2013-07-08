require_relative '../action'

module ONVIF
    module PtzAction
        class SetPreset < Action
            # options 的结构
            # {
            #   profile_token: "xxxxxxx",  //[ReferenceToken] A reference to the MediaProfile where the operation should take place.
            #   preset_name: "xxxxx", //  optional; [string]  A requested preset name.
            #   preset_token: "xxxxxxx"  //optional; [ReferenceToken] A requested preset token.
            # }
            def run options ,cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:SetPreset) do
                        xml.wsdl :ProfileToken, options[:profile_token]
                        xml.wsdl :PresetName, options[:preset_name] unless options[:preset_name].nil?
                        xml.wsdl :PresetToken, options[:preset_token] unless options[:preset_token].nil?
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
