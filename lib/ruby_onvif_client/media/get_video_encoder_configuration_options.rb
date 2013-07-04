require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoEncoderConfigurationOptions < Action
            # options 的结构
            # {
            #   c_token: "xxxxxxx",  //[ReferenceToken] Optional audio encoder configuration token that specifies an existing configuration that the options are intended for.
            #   p_token: "xxxxxxx"  //[ReferenceToken]  Optional ProfileToken that specifies an existing media profile that the options shall be compatible with.
            # }
            def run options, cb
                message = create_media_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoEncoderConfigurationOptions) do
                        xml.wsdl :ConfigurationToken, options["c_token"]
                        xml.wsdl :ProfileToken, options["p_token"]
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        options = {
                            quality_range: _get_min_max(_get_node(xml_doc, "//tt:QualityRange")),
                            jpeg: {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:JPEG"), "//tt:ResolutionsAvailable"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:JPEG"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:JPEG"), "//tt:FrameRateRange")
                            },
                            extension: ""
                        }
                        unless xml_doc.at_xpath('//tt:MPEG4').nil?
                            options["mpeg4"] = {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:MPEG4"), "//tt:ResolutionsAvailable"),
                                gov_length_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:GovLengthRange"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:EncodingIntervalRange"),
                                mpeg4_profiles_supported: _get_profiles_supported(_get_node(xml_doc, "//tt:MPEG4"), "//tt:Mpeg4ProfilesSupported")
                            }
                        end
                        unless xml_doc.at_xpath('//tt:H264').nil?
                            options["h264"] = {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:H264"), "//tt:ResolutionsAvailable"),
                                gov_length_range: _get_min_max(_get_node(xml_doc, "//tt:H264"), "//tt:GovLengthRange"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:H264"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:H264"), "//tt:EncodingIntervalRange"),
                                h264_profiles_supported: _get_profiles_supported(_get_node(xml_doc, "//tt:H264"), "//tt:H264ProfilesSupported")
                            }
                        end
                        callback cb, success, options
                    else
                        callback cb, success, result
                    end
                end
            end
            def _get_profiles_supported xml_doc, parent_name
                this_node = xml_doc.at_xpath(parent_name)
                result_val = []
                this_node.each do |node|
                    result_val << node.content
                end
                return result_val
            end
            def _get_node parent_node, node_name
                parent_node.at_xpath(node_name)
            end

            def _get_each_val xml_doc, parent_name
                result_val = []
                xml_doc.each do |node|
                    result_val << _get_width_height(node, parent_name)
                end
                return result_val
            end

            def _get_min_max xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    min: value(this_node, "tt:Min"),
                    max: value(this_node, "tt:Max")
                }
            end

            def _get_width_height xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    width: value(this_node, "tt:Width"),
                    height: value(this_node, "tt:Height")
                }
            end
        end
    end
end
