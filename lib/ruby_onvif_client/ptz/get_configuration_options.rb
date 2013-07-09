require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetConfigurationOptions < Action
            include PtzCommon  #get_configuration_optional_value , get_speed, get_pan_tilt_limits, get_zoom_limits
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
                        configuration = _get_space_muster root_doc
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

            def _get_space_muster root_doc
                configuration = {}
                configuration[:spaces] = {}
                spaces = root_doc.xpath("tt:Spaces")
                unless spaces.at_xpath("tt:AbsolutePanTiltPositionSpace").nil?
                    configuration[:spaces][:aptps] = _get_spaces spaces, "AbsolutePanTiltPositionSpace"    
                end
                unless spaces.at_xpath("tt:AbsoluteZoomPositionSpace").nil?
                    configuration[:spaces][:azps] = _get_spaces spaces, "AbsoluteZoomPositionSpace"
                end
                unless spaces.at_xpath("tt:RelativePanTiltTranslationSpace").nil?
                    configuration[:spaces][:rptts] = _get_spaces spaces, "RelativePanTiltTranslationSpace"
                end
                unless spaces.at_xpath("tt:RelativeZoomTranslationSpace").nil?
                    configuration[:spaces][:rzts] = _get_spaces spaces, "RelativeZoomTranslationSpace"
                end
                unless spaces.at_xpath("tt:ContinuousPanTiltVelocitySpace").nil?
                    configuration[:spaces][:cptvs] = _get_spaces spaces, "ContinuousPanTiltVelocitySpace"
                end
                unless spaces.at_xpath("tt:ContinuousZoomVelocitySpace").nil?
                    configuration[:spaces][:czvs] = _get_spaces spaces, "ContinuousZoomVelocitySpace"
                end
                unless spaces.at_xpath("tt:PanTiltSpeedSpace").nil?
                    configuration[:spaces][:ptss] = _get_spaces spaces, "PanTiltSpeedSpace"
                end
                unless spaces.at_xpath("tt:ZoomSpeedSpace").nil?
                    configuration[:spaces][:zss] = _get_spaces spaces, "ZoomSpeedSpace"
                end
                configuration[:spaces][:extension] = ""
                return configuration
            end

            def _get_spaces xml_doc, node_name
                results = []
                unless xml_doc.at_xpath("tt:" + node_name).nil?
                    xml_doc.xpath("tt:" + node_name).each do |space|
                        if space.at_xpath("tt:YRange").nil?
                            results << get_zoom_limits(space)
                        else
                            results << get_pan_tilt_limits(space)
                        end
                    end
                end
                return results
            end
        end
    end
end
