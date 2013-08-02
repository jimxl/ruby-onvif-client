require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class SetSystemDateAndTime < Action
            # system_date_time 的结构
            # {
            #   type: 'Manual', //  'Manual', 'NTP'
            #   ds: false // DaylightSavings [booblean]
            #   time_zone: {//optional
            #       tz: 'xxxxx'// string TimeZone -> TZ  [token]
            #   }
            #   date_time: {//optional
            #       year: 2013 // int
            #       month: 6   // int 1 to 12
            #       day: 26 // int 1 to 31
            #       hour: 5  // int 0 to 23
            #       minute: 31 //int 0 to 59
            #       second: 44 //int 0 to 61 (typically 59)
            #   }
            # }
            def run system_date_time, cb
                message = Message.new namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetSystemDateAndTime) do
                        xml.wsdl :DateTimeType, system_date_time[:type]
                        xml.wsdl :DaylightSavings, system_date_time[:ds]
                        unless options[:time_zone].nil?
                            xml.wsdl(:TimeZone) do
                                xml.sch :TZ, system_date_time[:time_zone][:tz]
                            end
                        end
                        unless options[:date_time].nil?
                            xml.wsdl(:UTCDateTime) do
                                xml.sch :Time do
                                    xml.sch :Hour, system_date_time[:date_time][:hour]
                                    xml.sch :Minute, system_date_time[:date_time][:minute]
                                    xml.sch :Second, system_date_time[:date_time][:second]
                                end
                                xml.sch :Date do
                                    xml.sch :Year, system_date_time[:date_time][:year]
                                    xml.sch :Month, system_date_time[:date_time][:month]
                                    xml.sch :Day, system_date_time[:date_time][:day]
                                end
                            end
                        end
                    end
                end
                send_message message do |success, result|
                    callback cb, success, result
                end
            end
        end
    end
end
