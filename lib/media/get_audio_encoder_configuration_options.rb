require_relative '../action'

module ONVIF
    module MediaAction
        class GetAudioEncoderConfigurationOptions < Action
            # options 的结构
            # {
            #   c_token: "xxxxxxx",  //[ReferenceToken] Optional audio encoder configuration token that specifies an existing configuration that the options are intended for.
            #   p_token: "xxxxxxx"  //[ReferenceToken]  Optional ProfileToken that specifies an existing media profile that the options shall be compatible with.
            # }
            def run options, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetAudioEncoderConfigurationOptions) do
                        xml.wsdl :ConfigurationToken, options["c_token"]
                        xml.wsdl :ProfileToken, options["p_token"]
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        node_options = []
                        xml_doc.xpath('//trt:Options//tt:Options').each do |node|
                            this_options = {encoding: value(node, 'tt:Encoding')}
                            bitrate = node.at_xpath("tt:BitrateList")
                            unless bitrate.nil?
                                bitrate_list = []
                                node.xpath('tt:BitrateList//tt:Items').each do |item|
                                    bitrate_list << {
                                        items: item.content
                                    }
                                end
                                this_options["bitrate_list"] = bitrate_list
                            end
                            sample_rate = node.at_xpath("tt:SampleRateList")
                            unless sample_rate.nil?
                                sample_rate_list = []
                                node.xpath('tt:SampleRateList//tt:Items').each do |item|
                                    sample_rate_list << {
                                        items: item.content
                                    }
                                end
                                this_options["sample_rate_list"] = sample_rate_list
                            end


                            node_options << this_options
                        end
                        callback cb, success, node_options
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
