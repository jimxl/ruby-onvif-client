require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetSystemDateAndTime < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetSystemDateAndTime)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        xml_utc = xml_doc.xpath('//tt:UTCDateTime')
                        xml_local = xml_doc.xpath('//tt:LocalDateTime')
                        utc_data_time = {
                            time: {
                                hour: value(xml_utc, '//tt:Hour'),
                                minute: value(xml_utc, '//tt:Minute'),
                                second: value(xml_utc, '//tt:Second')
                            },
                            date: {
                                year: value(xml_utc, '//tt:Year'),
                                month: value(xml_utc, '//tt:Month'),
                                day: value(xml_utc, '//tt:Day')
                            }
                        }
                        local_date_time = {
                            time: {
                                hour: value(xml_local, '//tt:Hour'),
                                minute: value(xml_local, '//tt:Minute'),
                                second: value(xml_local, '//tt:Second')
                            },
                            date: {
                                year: value(xml_local, '//tt:Year'),
                                month: value(xml_local, '//tt:Month'),
                                day: value(xml_local, '//tt:Day')
                            }
                        }
                        date_time = {
                            date_time_type: value(xml_doc, '//tt:DateTimeType'),
                            daylight_savings: value(xml_doc, '//tt:DaylightSavings'),
                            time_zone: {
                                tz: value(xml_doc, '//tt:TZ'),
                            },
                            extension: value(xml_doc, '//tt:Extension')
                        }
                        xml_utc_time = xml_doc.at_xpath('//tt:UTCDateTime')
                        xml_local_time = xml_doc.at_xpath('//tt:LocalDateTime')
                        date_time["utc_date_time"] = utc_data_time unless xml_utc_time.nil?
                        date_time["local_date_time"] = local_date_time unl unless xml_local_time.nil?
                        callback cb, success, date_time
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
