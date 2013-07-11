require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetConfigurationOptions < Action
            include PtzCommon #get_speed, get_pan_tilt_limits, get_zoom_limits, get_space_muster
            # c_token 的结构 
            # c_token = "xxxxx" //[ReferenceToken] Token of an existing configuration that the options are intended for.
            def run c_token, cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetConfigurationOptions) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        root_doc = xml_doc.xpath("//tptz:PTZConfigurationOptions")
                        pt_control_direction = root_doc.at_xpath("tptz:PTControlDirection")
                        configuration = {}
                        configuration = get_space_muster(root_doc, "Spaces", nil)
                        unless pt_control_direction.nil?
                            eflip_mode = []; reverse_mode = []
                            pt_control_direction.xpath("tt:EFlip/tt:Mode").each do |mode|
                                eflip_mode << mode.content
                            end
                            pt_control_direction.xpath("tt:Reverse/tt:Mode").each do |mode|
                                reverse_mode << mode.content
                            end
                            configuration[:PTControlDirection] = {
                                eflip: {
                                    mode: eflip_mode,
                                    extension: ""
                                },
                                reverse: {
                                    mode: reverse_mode,
                                    extension: ""
                                }
                            }
                        end
                        configuration[:ptz_timeout] = get_min_max(root_doc, "tt:PTZTimeout")
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
