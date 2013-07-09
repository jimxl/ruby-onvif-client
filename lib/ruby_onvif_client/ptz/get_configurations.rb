require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetConfigurations < Action
            include PtzCommon  #get_configuration_optional_value , get_speed, get_pan_tilt_limits, get_zoom_limits
            def run cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetConfigurations)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        configurations = []
                        xml_doc.xpath("//tptz:PTZConfiguration").each do |root_node|
                            pan_tilt_limits_range = root_node.at_xpath("tt:PanTiltLimits/tt:Range")
                            zoom_limits_range = root_node.at_xpath("tt:ZoomLimits/tt:Range")
                            configuration = {
                                name: value(root_node, 'tt:Name'),
                                use_count: value(root_node, 'tt:UseCount'),
                                token: attribute(root_node, 'token'),
                                node_token: value(root_node, 'tt:NodeToken')
                            }
                            configuration = get_configuration_optional_value root_node, configuration
                            configuration = get_speed root_node, "DefaultPTZSpeed", configuration
                            configuration[:default_ptz_timeout] = value(root_node, "tt:DefaultPTZTimeout")
                            configuration[:pan_tilt_limits] = {
                                range: get_pan_tilt_limits(pan_tilt_limits_range)
                            }
                            configuration[:zoom_limits] = {
                                range: get_zoom_limits(zoom_limits_range)
                            }
                            configuration[:extension] = ""
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
