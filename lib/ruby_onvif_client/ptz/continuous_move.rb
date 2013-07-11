require_relative '../action'

module ONVIF
    module PtzAction
        class ContinuousMove < Action
            # options 的结构  
            # {
            #     profile_token: "xxxxxxx",//[ReferenceToken] A reference to the MediaProfile where the operation should take place.
            #     velocity: {  //optional
            #         pan_tilt: { //optional
            #             x: 1, //[float]
            #             y: 2, //[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace", //[anyURI]
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/TranslationGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/VelocityGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/GenericSpeedSpace
            #         },
            #         zoom: { //optional
            #             x: 1,//[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace",//[anyURI]
            #         }
            #     },
            #     timeout: '' //optional [duration]
            # }
            def run options, cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:ContinuousMove) do
                        xml.wsdl :ProfileToken, options[:profile_token]
                        unless options[:velocity].nil?
                            xml.wsdl(:Velocity) do
                                unless options[:velocity][:pan_tilt].nil?
                                    xml.wsdl :PanTilt, {
                                        "x" => options[:velocity][:pan_tilt][:x],
                                        "y" => options[:velocity][:pan_tilt][:y],
                                        "space" => options[:velocity][:pan_tilt][:space]
                                    }
                                end
                                unless options[:velocity][:zoom].nil?
                                    xml.wsdl :Zoom, {
                                        "x" => options[:velocity][:zoom][:x],
                                        "space" => options[:velocity][:zoom][:space]
                                    }
                                end
                            end
                        end
                        xml.wsdl :Timeout, options[:timeout] unless options[:timeout].nil?
                    end
                end
                send_message message do |success, result|
                    callback cb, success, result
                end
            end
        end
    end
end