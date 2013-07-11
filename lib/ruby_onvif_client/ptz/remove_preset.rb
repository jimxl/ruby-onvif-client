require_relative '../action'

module ONVIF
    module PtzAction
        class RemovePreset < Action
            # options 的结构
            # {
            #   profile_token: "xxxxxxx",  //[ReferenceToken] A reference to the MediaProfile where the operation should take place.
            #   preset_token: "xxxxxxx"  //[ReferenceToken] A requested preset token.
            # }
            def run options ,cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:RemovePreset) do
                        xml.wsdl :ProfileToken, options[:profile_token]
                        xml.wsdl :PresetToken, options[:preset_token]
                    end
                end
                send_message message do |success, result|
                    callback cb, success, result
                end
            end
        end
    end
end
