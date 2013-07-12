require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
    content = 
            {
              type: 'Manual',# //  'Manual', 'NTP'
              ds: false, #// DaylightSavings [booblean]
              time_zone_tz: 'beijing',#// string TimeZone -> TZ  [token]
              year: 2013, 
              month: 6,   
              day: 26, 
              hour: 5,  
              minute: 31, 
              second: 44 
            }    
    device.set_system_date_and_time content, ->(success, result) {
      puts '--------------', result, '============'
    }
end           
