module ONVIF
    module PtzCommon
        def get_configuration_optional_value xml_doc, configuration
            configuration = {} if configuration.nil?
            unless xml_doc.at_xpath("tt:DefaultAbsolutePantTiltPositionSpace").nil?
                configuration[:daptps] = value(xml_doc, "tt:DefaultAbsolutePantTiltPositionSpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultAbsoluteZoomPositionSpace").nil?
                configuration[:dazps] = value(xml_doc, "tt:DefaultAbsoluteZoomPositionSpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultRelativePanTiltTranslationSpace").nil?
                configuration[:drptts] = value(xml_doc, "tt:DefaultRelativePanTiltTranslationSpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultRelativeZoomTranslationSpace").nil?
                configuration[:drzts] = value(xml_doc, "tt:DefaultRelativeZoomTranslationSpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultContinuousPanTiltVelocitySpace").nil?
                configuration[:dcptvs] = value(xml_doc, "tt:DefaultContinuousPanTiltVelocitySpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultContinuousZoomVelocitySpace").nil?
                configuration[:dczvs] = value(xml_doc, "tt:DefaultContinuousZoomVelocitySpace")    
            end
            unless xml_doc.at_xpath("tt:DefaultPTZTimeout").nil?
                configuration[:d_ptz_timeout] = value(xml_doc, "tt:DefaultPTZTimeout")    
            end
            return configuration
        end

        def get_speed xml_doc, speed_name, configuration
            configuration = {} if configuration.nil?
            speed_doc = xml_doc.at_xpath("tt:" + speed_name)
            unless speed_doc.nil?
                pan_tilt = speed_doc.at_xpath("tt:PanTilt")
                zoom = speed_doc.at_xpath("tt:Zoom")
                configuration[speed_name.underscore] = {}
                unless pan_tilt.nil?
                    configuration[speed_name.underscore][:pan_tilt] = {
                        x: attribute(pan_tilt, "x"),
                        y: attribute(pan_tilt, "y"),
                        space: attribute(pan_tilt, "space")
                    }
                end
                unless zoom.nil?
                    configuration[speed_name.underscore][:pan_tilt] = {
                        x: attribute(zoom, "x"),
                        space: attribute(zoom, "space")
                    }
                end
            end
            return configuration
        end

        def get_pan_tilt_limits xml_doc
            configuration = {}
            configuration = get_zoom_limits xml_doc
            configuration[:y_range] = get_min_max(xml_doc, "tt:YRange")
            return configuration
        end

        def get_zoom_limits xml_doc
            return {
                uri: value(xml_doc, "tt:URI"),
                x_range: get_min_max(xml_doc, "tt:XRange")
            }
        end

        def get_min_max xml_doc, parent_name
            this_node = xml_doc
            unless parent_name.nil?
                this_node = xml_doc.at_xpath(parent_name)
            end
            return {
                min: value(this_node, "tt:Min"),
                max: value(this_node, "tt:Max")
            }
        end
    end
end
