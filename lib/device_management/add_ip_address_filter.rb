require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class AddIpAddressFilter < Action
            # options 的结构
            # {
            #   type: 'Allow', // 'Allow' or 'Deny'
            #   ipv4: [{
            #       address: '192.168.2.1'
            #       submask: 24
            #   }],
            #   ipv6: [{
            #       address: 'xxxxxx',
            #       submask: 24
            #   }]
            # }

            def run options, cb
                message = Message.new namespaces: {:'xmlns:sch' => 'http://www.onvif.org/ver10/schema'}
                message.body =  ->(xml) do
                    xml.wsdl(:AddIPAddressFilter) do
                        xml.wsdl(:IPAddressFilter) do
                            xml.sch :Type
                            xml.sch 'IPv4Address' do
                                xml.sch 'Address', 'xxx'
                                xml.sch 'PrefixLength', 'xxx'
                            end
                            xml.sch 'IPv6Address' do
                                xml.sch 'Address', 'xxx'
                                xml.sch 'PrefixLength', 'xxx'
                            end
                            xml.sch 'Extension' do
                            end
                        end
                    end
                end
                send_message message do |success, result|
                    if success
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

