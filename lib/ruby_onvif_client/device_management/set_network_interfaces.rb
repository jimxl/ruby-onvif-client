require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class SetNetworkInterfaces < Action
            # network_interface 的结构
            # {
            #   interface_token: 'xxxxxx',  // optional name [string]
            #   nwif:{ // #NetworkInterface 
            #       enabled: true,   //optional  true, false  [boolean]
            #       link: {//optional
            #           auto_negotiation: true,  //true, false [boolean]
            #           speed: 3,        // [int]
            #           duplex: 'Full'   //'Full', 'Half' 
            #       }
            #       mtu: 2,   //optional  [int]
            #       ipv4: { //optional
            #           enabled: true, //optional true, false [boolean]
            #           manual: [{ //optional
            #               address: "xxx.xxx.xxx.xxx", // [IPv4Address]
            #               prefix_length: 22 // [int]
            #           }],
            #           dhcp: true //optional true, false [boolean]
            #       },
            #       ipv6: {//optional
            #           enabled: true, //optional  true, false [boolean]
            #           ara: false//optional  true, false  #AcceptRouterAdvert    [boolean]
            #           manual: [{//optional
            #               address: "xxx.xxx.xxx.xxx", // [IPv4Address]
            #               prefix_length: 22 // [int]
            #           }],
            #           dhcp: true //optional  true, false [boolean]
            #       }
            #   }
            # }
            def run network_interface, cb
                message = Message.new namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:SetNetworkInterfaces) do
                        xml.wsdl :InterfaceToken, network_interface[:interface_token]
                        xml.wsdl :NetworkInterface do
                            unless options[:nwif][:enabled].nil?
                                xml.sch :Enabled, network_interface[:nwif][:enabled]
                            end
                            unless options[:nwif][:link].nil?
                                xml.sch :Link do
                                    xml.sch :AutoNegotiation, network_interface[:nwif][:link][:auto_negotiation]
                                    xml.sch :Speed, network_interface[:nwif][:link][:speed]
                                    xml.sch :Duplex, network_interface[:nwif][:link][:duplex]
                                end
                            end
                            unless options[:nwif][:mtu].nil?
                                xml.sch :MTU, network_interface[:nwif][:mtu]
                            end
                            unless options[:nwif][:ipv4].nil?
                                xml.sch :IPv4 do
                                    unless options[:nwif][:ipv4][:enabled].nil?
                                        xml.sch :Enabled, network_interface[:nwif][:ipv4][:enabled]
                                    end
                                    unless options[:nwif][:ipv4][:manual].nil?
                                        network_interface[:nwif][:ipv4][:manual].each do |manual|
                                            xml.sch :Manual do
                                                xml.sch :Address, manual[:address]
                                                xml.sch :PrefixLength, manual[:prefix_length]
                                            end
                                        end
                                    end
                                    unless options[:nwif][:ipv4][:dhcp].nil?
                                        xml.sch :DHCP, network_interface[:nwif][:ipv4][:dhcp]
                                    end
                                end
                            end
                            unless options[:nwif][:ipv6].nil?
                                xml.sch :IPv6 do
                                    unless options[:nwif][:ipv6][:enabled].nil?
                                        xml.sch :Enabled, network_interface[:nwif][:ipv6][:enabled]
                                    end
                                    unless options[:nwif][:ipv6][:ara].nil?
                                        xml.sch :AcceptRouterAdvert, network_interface[:nwif][:ipv6][:ara]
                                    end
                                    unless options[:nwif][:ipv6][:manual].nil?
                                        network_interface[:nwif][:ipv6][:manual].each do |manual|
                                            xml.sch :Manual do
                                                xml.sch :Address, manual[:address]
                                                xml.sch :PrefixLength, manual[:prefix_length]
                                            end
                                        end
                                    end
                                    unless options[:nwif][:ipv6][:dhcp].nil?
                                        xml.sch :DHCP, network_interface[:nwif][:ipv6][:dhcp]
                                    end
                                end
                            end
                        end
                        xml.wsdl :Extension do
                        end
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        info = {
                            reboot_needed: value(xml_doc, '//tds:RebootNeeded')
                        }

                        callback cb, success, info
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end
