require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetConfiguration < Action
            include PtzCommon  #get_configuration_optional_value , get_speed, get_pan_tilt_limits, get_zoom_limits
            # p_c_token 的结构 
            # p_c_token = "xxxxx" //[ReferenceToken] Token of the requested PTZConfiguration.
            def run p_c_token, cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetConfiguration) do
                        xml.wsdl :PTZConfigurationToken, p_c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        root_doc = xml_doc.at_xpath("//tptz:PTZConfiguration")
                        pan_tilt_limits_range = root_doc.at_xpath("tt:PanTiltLimits/tt:Range")
                        zoom_limits_range = root_doc.at_xpath("tt:ZoomLimits/tt:Range")
                        configuration = {
                            name: value(root_doc, 'tt:Name'),
                            use_count: value(root_doc, 'tt:UseCount'),
                            token: attribute(root_doc, 'token'),
                            node_token: value(root_doc, 'tt:NodeToken')
                        }
                        configuration = get_configuration_optional_value root_doc, configuration
                        configuration = get_speed root_doc, "DefaultPTZSpeed", configuration
                        configuration[:default_ptz_timeout] = value(root_doc, "tt:DefaultPTZTimeout")
                        configuration[:pan_tilt_limits] = {
                            range: get_pan_tilt_limits(pan_tilt_limits_range)
                        }
                        configuration[:zoom_limits] = {
                            range: get_zoom_limits(zoom_limits_range)
                        }
                        configuration[:extension] = ""
                        callback cb, success, configuration
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
