require_relative '../action'

module ONVIF
    module PtzAction
        class GetNodes < Action
            def run cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetNodes)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        # ???
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
