require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
    eth_configs = 
      {
        interface_token: 'NetworkInterfaces_1',
        nwif:{  #NetworkInterface 
            enabled: true,   
            link: {
                auto_negotiation: true,  
                speed: 3,        
                duplex: 'Full'    
            },
            mtu: 2,   
            ipv4: {
                enabled: true, 
                manual: [{
                    address: "192.168.2.145", 
                    prefix_length: 24 
                }],
                dhcp: true 
            },
            ipv6: {
                enabled: true, 
                ara: false,
                manual: [{
                    address: "192.168.2.145", 
                    prefix_length: 24 
                }],
                dhcp: true 
            }
        }
      }    
    device.set_network_interfaces eth_configs, ->(success, result) {
      puts '--------------', result, '============'
    }
end
#{:header=>{"SERVER"=>"gSOAP/2.8", "CONTENT_TYPE"=>"application/soap+xml; charset=utf-8", "CONTENT_LENGTH"=>"3311", "CONNECTION"=>"close"}}
#{:token=>"NetworkInterfaces_1", :enabled=>"true", :info=>{:name=>"NetworkInterfaces_Info_1", :hw_address=>"0000510203A1", :mtu=>"1500"}, :ipv4=>{:enabled=>"true", :config=>{:manual=>[{:address=>"192.168.2.145", :prefix_length=>"24"}], :link_local=>{:address=>"192.168.2.145", :prefix_length=>"24"}, :form_dhcp=>{:address=>"192.168.2.145", :prefix_length=>"24"}, :dhcp=>"true"}}}
            
            # network_interface 的结构
            # {
            #   interface_token: 'xxxxxx',  // name [string]
            #   nwif:{ // #NetworkInterface 
            #       enabled: true,   //true, false  [boolean]
            #       link: {
            #           auto_negotiation: true,  //true, false [boolean]
            #           speed: 3,        // [int]
            #           duplex: 'Full'   //'Full', 'Half' 
            #       }
            #       mtu: 2,   // [int]
            #       ipv4: {
            #           enabled: true, //true, false [boolean]
            #           manual: [{
            #               address: "xxx.xxx.xxx.xxx", // [IPv4Address]
            #               prefix_length: 22 // [int]
            #           }],
            #           dhcp: true //true, false [boolean]
            #       },
            #       ipv6: {
            #           enabled: true, //true, false [boolean]
            #           ara: false//true, false  #AcceptRouterAdvert    [boolean]
            #           manual: [{
            #               address: "xxx.xxx.xxx.xxx", // [IPv4Address]
            #               prefix_length: 22 // [int]
            #           }],
            #           dhcp: true //true, false [boolean]
            #       }
            #   }
            # }