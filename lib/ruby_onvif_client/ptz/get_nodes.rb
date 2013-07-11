require_relative '../action'
require_relative '../helper/ptz_common'

module ONVIF
    module PtzAction
        class GetNodes < Action
            include PtzCommon
            def run cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetNodes)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        ptz_nodes = []
                        xml_doc.xpath('//tptz:PTZNode').each do |preset_token|
                            ptz_node = {
                                name: value(preset_token, "tt:Name"),
                                token: attribute(preset_token, "token")
                            }
                            ptz_node = get_space_muster(preset_token, "SupportedPTZSpaces", ptz_node)
                            ptz_node[:maximum_number_of_presets] = value(preset_token, "tt:MaximumNumberOfPresets")
                            ptz_node[:home_supported] = value(preset_token, "tt:HomeSupported")
                            unless preset_token.at_xpath("tt:AuxiliaryCommands").nil?
                                ptz_node[:auxiliary_commands] = []
                                preset_token.xpath("tt:AuxiliaryCommands").each do |command|
                                    ptz_node[:auxiliary_commands] << command.content
                                end
                            end
                            ptz_nodes << ptz_node
                        end
                        callback cb, success, ptz_nodes
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
