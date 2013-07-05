require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class SetNetworkInterfaces < Action
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
            def run network_interface, cb
                message = Message.new namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetNetworkInterfaces) do
                        xml.wsdl :InterfaceToken, network_interface[:interface_token]
                        xml.wsdl :NetworkInterface do
                            xml.sch :Enabled, network_interface[:nwif][:enabled]
                            xml.sch :Link do
                                xml.sch :AutoNegotiation, network_interface[:nwif][:link][:auto_negotiation]
                                xml.sch :Speed, network_interface[:nwif][:link][:speed]
                                xml.sch :Duplex, network_interface[:nwif][:link][:duplex]
                            end
                            xml.sch :MTU, network_interface[:nwif][:mtu]
                            xml.sch :IPv4 do
                                xml.sch :Enabled, network_interface[:nwif][:ipv4][:enabled]
                                network_interface[:nwif][:ipv4][:manual].each do |manual|
                                    xml.sch :Manual do
                                        xml.sch :Address, manual[:address]
                                        xml.sch :PrefixLength, manual[:prefix_length]
                                    end
                                end
                                xml.sch :DHCP, network_interface[:nwif][:ipv4][:dhcp]
                            end
                            xml.sch :IPv6 do
                                xml.sch :Enabled, network_interface[:nwif][:ipv6][:enabled]
                                xml.sch :AcceptRouterAdvert, network_interface[:nwif][:ipv6][:ara]
                                network_interface[:nwif][:ipv6][:manual].each do |manual|
                                    xml.sch :Manual do
                                        xml.sch :Address, manual[:address]
                                        xml.sch :PrefixLength, manual[:prefix_length]
                                    end
                                end
                                xml.sch :DHCP, network_interface[:nwif][:ipv6][:dhcp]
                            end

                        end
                        xml.wsdl :Extension do
                        end
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
