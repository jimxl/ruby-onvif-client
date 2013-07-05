require_relative '../action'

module ONVIF
    module MediaAction
        class SetVideoEncoderConfiguration < Action
            # configuration 的结构
            # {
            #     configuration: {
            #         token: 'xxxxx', //[ReferenceToken] Token that uniquely refernces this configuration. Length up to 64 characters.
            #         name: 'xxxxxx', //User readable name. Length up to 64 characters.
            #         use_count: 1, // [int]
            #         encoding: 'H264', // 'JPEG', 'MPEG4', 'H264'
            #         resolution: {
            #             width: 1280, //Number of the columns of the Video image.
            #             height: 720, //Number of the columns of the Video image.
            #         },
            #         quality: 100,// [float]
            #         rate_control: {
            #             frame_rate_limit: 25,//[int]
            #             encoding_interval: 25,//[int]
            #             bitrate_limit: 4096 //[int]
            #         },
            #         mpeg4: {// 可有可无
            #             gov_length: 30, // [int]
            #             mpeg4_profile: 'SP' //'SP', 'ASP'
            #         },
            #         h264: { //可有可无
            #             gov_length: 30, //[int]
            #             h264_profile: 'Main' // 'Baseline', 'Main', 'Extended', 'High'
            #         },
            #         multicast: {
            #             address: {
            #                 type: 'IPv4', //'IPv4', 'IPv6'
            #                 ipv4_address: '239.255.0.0', //[IPv4Address]
            #                 ipv6_address: '0000:0000:0000:0000:0000:0000:0000:0000' //[IPv6Address]
            #             },
            #             port: 1024,//[int]
            #             ttl: 1,//[int]
            #             auto_start: false //[boolean]
            #         },
            #         session_timeout: 'PT0H1M26.400S', //[duration]  The rtsp session timeout for the related video stream
            #     },
            #     force_persistence: false // [boolean] The ForcePersistence element is obsolete and should always be assumed to be true.
            # }
            def run configuration, cb
                message = create_media_onvif_message  namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetVideoEncoderConfiguration) do
                        xml.wsdl :Configuration, {"token" => configuration[:configuration][:token]}
                        xml.wsdl(:Configuration) do 
                            xml.sch :Name, configuration[:configuration][:name]
                            xml.sch :UseCount, configuration[:configuration][:use_count]
                            xml.sch :Encoding, configuration[:configuration][:encoding]
                            xml.sch(:Resolution) do
                                xml.sch :Width, configuration[:configuration][:resolution][:width]
                                xml.sch :Height, configuration[:configuration][:resolution][:height]
                            end
                            xml.sch :Quality,configuration[:configuration][:quality]
                            xml.sch(:RateControl) do
                                xml.sch :FrameRateLimit, configuration[:configuration][:rate_control][:frame_rate_limit]
                                xml.sch :EncodingInterval, configuration[:configuration][:rate_control][:encoding_interval]
                                xml.sch :BitrateLimit, configuration[:configuration][:rate_control][:bitrate_limit]
                            end
                            unless configuration[:configuration][:mpeg4].nil?
                                xml.sch(:MPEG4) do
                                    xml.sch :GovLength, configuration[:configuration][:mpeg4][:gov_length]
                                    xml.sch :Mpeg4Profile, configuration[:configuration][:mpeg4][:mpeg4_profile]
                                end
                            end
                            unless configuration[:configuration][:h264].nil?
                                xml.sch(:H264) do
                                    xml.sch :GovLength, configuration[:configuration][:h264][:gov_length]
                                    xml.sch :H264Profile, configuration[:configuration][:h264][:h264_profile]
                                end
                            end
                            xml.sch(:Multicast) do
                                xml.sch(:Address) do
                                    xml.sch :Type, configuration[:configuration][:multicast][:address][:type]
                                    xml.sch :IPv4Address, configuration[:configuration][:multicast][:address][:ipv4_address]
                                    xml.sch :IPv6Address, configuration[:configuration][:multicast][:address][:ipv6_address]
                                end
                                xml.sch :Port, configuration[:configuration][:multicast][:port]
                                xml.sch :TTL, configuration[:configuration][:multicast][:ttl]
                                xml.sch :AutoStart, configuration[:configuration][:multicast][:auto_start]
                            end
                            xml.sch :SessionTimeout, configuration[:configuration][:session_timeout]
                        end
                        xml.wsdl :ForcePersistence, configuration[:force_persistence]
                    end
                end
                send_message message do |success, result|
                    #????
                    callback cb, success, result
                end
            end
        end
    end
end
