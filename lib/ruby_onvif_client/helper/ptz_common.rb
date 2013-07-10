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

        def get_space_muster root_doc, parent_node_name, configuration 
            configuration = {} if configuration.nil?
            configuration[parent_node_name.underscore] = {}
            spaces = root_doc.xpath("tt:" + parent_node_name)
            unless spaces.at_xpath("tt:AbsolutePanTiltPositionSpace").nil?
                configuration[parent_node_name.underscore][:aptps] = get_spaces spaces, "AbsolutePanTiltPositionSpace"    
            end
            unless spaces.at_xpath("tt:AbsoluteZoomPositionSpace").nil?
                configuration[parent_node_name.underscore][:azps] = get_spaces spaces, "AbsoluteZoomPositionSpace"
            end
            unless spaces.at_xpath("tt:RelativePanTiltTranslationSpace").nil?
                configuration[parent_node_name.underscore][:rptts] = get_spaces spaces, "RelativePanTiltTranslationSpace"
            end
            unless spaces.at_xpath("tt:RelativeZoomTranslationSpace").nil?
                configuration[parent_node_name.underscore][:rzts] = get_spaces spaces, "RelativeZoomTranslationSpace"
            end
            unless spaces.at_xpath("tt:ContinuousPanTiltVelocitySpace").nil?
                configuration[parent_node_name.underscore][:cptvs] = get_spaces spaces, "ContinuousPanTiltVelocitySpace"
            end
            unless spaces.at_xpath("tt:ContinuousZoomVelocitySpace").nil?
                configuration[parent_node_name.underscore][:czvs] = get_spaces spaces, "ContinuousZoomVelocitySpace"
            end
            unless spaces.at_xpath("tt:PanTiltSpeedSpace").nil?
                configuration[parent_node_name.underscore][:ptss] = get_spaces spaces, "PanTiltSpeedSpace"
            end
            unless spaces.at_xpath("tt:ZoomSpeedSpace").nil?
                configuration[parent_node_name.underscore][:zss] = get_spaces spaces, "ZoomSpeedSpace"
            end
            configuration[parent_node_name.underscore][:extension] = ""
            return configuration
        end

        def get_spaces xml_doc, node_name
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
