require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetNetworkInterfaces < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetNetworkInterfaces)
                end
                send_message message do |success, result|
                    if success
                        xml_doc_main = Nokogiri::XML(result[:content])
                        interfaces = []
                        xml_doc_main.xpath('//tds:NetworkInterfaces').each do |xml_doc|
                            xml_info = xml_doc.at_xpath('tt:Info')
                            xml_link = xml_doc.at_xpath('tt:Link')
                            xml_ipv4 = xml_doc.at_xpath('tt:IPv4')
                            xml_ipv6 = xml_doc.at_xpath('tt:IPv6')
                            success_result = {
                                token: attribute(xml_doc, "token"),
                                enabled: value(xml_doc, "tt:Enabled")
                            }
                            success_result[:info] = _get_info(xml_info) unless xml_info.nil?
                            success_result[:link] = _get_link(xml_link) unless xml_link.nil?
                            success_result[:ipv4] = _get_ipv_four(xml_ipv4) unless xml_ipv4.nil?
                            success_result[:ipv6] = _get_ipv_six(xml_ipv6) unless xml_ipv6.nil?
                            interfaces << success_result
                        end
                        callback cb, success, interfaces
                    else
                        callback cb, success, result
                    end
                end
            end

            def _get_info xml_info
                {
                    name: value(xml_info, 'tt:Name'),
                    hw_address: value(xml_info, 'tt:HwAddress'),
                    mtu: value(xml_info, 'tt:MTU')
                }
            end

            def _get_link xml_link
                admin_xml_doc = xml_link.at_xpath('tt:AdminSettings')
                oper_xml_doc = xml_link.at_xpath('tt:OperSettings')
                link = {}
                unless xml_doc.nil?
                    link[:admin_settings] = {
                        auto_negotiation: value(admin_xml_doc, "tt:AutoNegotiation"),
                        speed: value(admin_xml_doc, "tt:Speed"),
                        duplex: value(admin_xml_doc, "tt:Duplex")
                    }
                end
                unless oper_xml_doc.nil?
                    link[:oper_settings] = {
                        auto_negotiation: value(oper_xml_doc, "tt:AutoNegotiation"),
                        speed: value(oper_xml_doc, "tt:Speed"),
                        duplex: value(oper_xml_doc, "tt:Duplex")
                    }
                end
                link[:interface_type] = value(xml_link, "tt:InterfaceType") unless xml_link.at_xpath('tt:InterfaceType')
                return link
            end

            def _get_ipv_four xml_ipv_four
                puts xml_ipv_four
                ipv_four = {enabled: value(xml_ipv_four, 'tt:Enabled')}
                manual = []; config = {}
                link_local = xml_ipv_four.xpath('tt:Config/tt:LinkLocal')
                form_dhcp = xml_ipv_four.xpath('tt:Config/tt:FromDHCP')
                xml_ipv_four.xpath('tt:Config//tt:Manual').each do |node|
                    manual << {
                        address: value(node, "tt:Address"),
                        prefix_length: value(node, "tt:PrefixLength")
                    }
                end
                config[:manual] = manual
                config[:link_local] = {
                    address: value(link_local, "tt:Address"),
                    prefix_length: value(link_local, "tt:PrefixLength")
                }
                config[:form_dhcp] = {
                    address: value(form_dhcp, "tt:Address"),
                    prefix_length: value(form_dhcp, "tt:PrefixLength")
                }
                config[:dhcp] = value(xml_ipv_four, "tt:Config//tt:DHCP")
                ipv_four[:config] = config
                return ipv_four
            end

            def _get_ipv_six xml_ipv_six
                ipv_six = {enabled: value(xml_ipv_six, 'tt:Enabled')}
                config = {}; manual = []; link_local = []; form_dhcp = []; form_ra = []
                xml_ipv_six.xpath('tt:Config/tt:Manual').each do |node|
                    manual << {
                        address: value(node, "tt:Address"),
                        prefix_length: value(node, "tt:PrefixLength")
                    }
                end
                xml_ipv_six.xpath('tt:Config/tt:LinkLocal').each do |node|
                    link_local << {
                        address: value(node, "tt:Address"),
                        prefix_length: value(node, "tt:PrefixLength")
                    }
                end
                xml_ipv_six.xpath('tt:Config/tt:FromDHCP').each do |node|
                    form_dhcp << {
                        address: value(node, "tt:Address"),
                        prefix_length: value(node, "tt:PrefixLength")
                    }
                end
                xml_ipv_six.xpath('tt:Config/tt:FromRA').each do |node|
                    form_ra << {
                        address: value(node, "tt:Address"),
                        prefix_length: value(node, "tt:PrefixLength")
                    }
                end
                config[:manual] = manual
                config[:link_local] = link_local
                config[:form_dhcp] = form_dhcp
                config[:form_ra] = form_ra
                config[:ara] = value(xml_ipv_six, "tt:AcceptRouterAdvert")
                config[:dhcp] = value(xml_ipv_six, "tt:DHCP")
                ipv_six[:config] = config
                return ipv_six
            end
        end
    end
end
