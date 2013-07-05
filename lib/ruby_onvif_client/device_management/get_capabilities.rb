require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetCapabilities < Action
            # options 的结构   <!--0 or more-->
            # [{
            #   Category: "All", //nil, 'All', 'Analytics', 'Device', 'Events', 'Imaging', 'Media', 'PTZ'  
            #              <!--0 or more-->
            # }]
            def run options, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetCapabilities) do
                        unless options.nil?
                            options.each do |option|
                                xml.wsdl :Category, option[:Category]
                            end
                        end
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        xml_analytics = xml_doc.at_xpath('//tt:Analytics')
                        xml_device = xml_doc.at_xpath('//tt:Device')
                        xml_events = xml_doc.at_xpath('//tt:Events')
                        xml_imaging = xml_doc.at_xpath('//tt:Imaging')
                        xml_media = xml_doc.xpath('//tt:Media')
                        xml_ptz = xml_doc.xpath('//tt:PTZ')
                        success_result = {}
                        success_result[:analytics] = _get_analytics(xml_analytics) unless xml_analytics.nil?
                        success_result[:device] = _get_device(xml_device) unless xml_device.nil?
                        success_result[:events] = _get_events(xml_events) unless xml_events.nil?
                        success_result[:imaging] = _get_imaging(xml_imaging) unless xml_imaging.nil?
                        success_result[:media] = _get_media(xml_media) unless xml_media.nil?
                        success_result[:ptz] = _get_ptz(xml_ptz) unless xml_ptz.nil?
                        callback cb, success, success_result
                    else
                        callback cb, success, result
                    end
                end
            end

            def _get_analytics xml_analytics
                {
                    x_addr: value(xml_analytics, '//tt:XAddr'),
                    rule_support: value(xml_analytics, '//tt:RuleSupport'),
                    ams: value(xml_analytics, '//tt:AnalyticsModuleSupport')
                }
            end

            def _get_device xml_device
                network_keys = [:IPFilter", "ZeroConfiguration", "IPVersion6", "DynDNS", "Dot11Configuration", 
                    "Dot1XConfigurations", "HostnameFromDHCP", "NTP", "DHCPv6]
                system_keys = [:DiscoveryResolve", "DiscoveryBye", "RemoteDiscovery", "SystemBackup", "SystemLogging",
                    "FirmwareUpgrade", "HttpFirmwareUpgrade", "HttpSystemBackup", "HttpSystemLogging", "HttpSupportInformation]
                security_keys = [:TLS1.0", "TLS1.1", "TLS1.2", "OnboardKeyGeneration", "AccessPolicyConfig", 
                    "DefaultAccessPolicy", "Dot1X", "RemoteUserHandling", "X.509Token", "SAMLToken", "KerberosToken", 
                    "UsernameToken", "HttpDigest", "RELToken", "SupportedEAPMethods]
                network = {}; system = {}; security = {}
                network_keys.each do |key|
                    network[key.underscore] = value(xml_device, '//tt:' + key) unless value(xml_device, '//tt:' + key) == ''
                end
                system_keys.each do |key|
                    system[key.underscore] = value(xml_device, '//tt:' + key) unless value(xml_device, '//tt:' + key) == ''
                end
                security_keys.each do |key|
                    security[key.underscore] = value(xml_device, '//tt:' + key) unless value(xml_device, '//tt:' + key) == ''
                end
                return {
                    x_addr: value(xml_device, '//tt:XAddr'),
                    network: network,
                    system: system,
                    io: {
                        input_connectors: value(xml_device, '//tt:InputConnectors'),
                        relay_outputs: value(xml_device, '//tt:RelayOutputs'),
                        extension: ""
                    },
                    security: security
                }
            end

            def _get_events xml_events
                {
                    x_addr: value(xml_events, '//tt:XAddr'),
                    wssubscription_policy_support: value(xml_events, '//tt:WSSubscriptionPolicySupport'),
                    wspull_point_support: value(xml_events, '//tt:WSPullPointSupport'),
                    wspsmis: value(xml_events, '//tt:WSPausableSubscriptionManagerInterfaceSupport')
                }
            end

            def _get_imaging xml_imaging
                {
                    x_addr: value(xml_imaging, '//tt:XAddr')
                }
            end

            def _get_media xml_media
                {
                    x_addr: value(xml_media, '//tt:XAddr'),
                    streaming_capabilities: {
                        rtp_multicast: value(xml_media, '//tt:RTPMulticast'),
                        rtp_tcp: value(xml_media, '//tt:RTPMulticast'),
                        rtp_rtsp_tcp: value(xml_media, '//tt:RTP_RTSP_TCP'),
                        extension: ""
                    },
                    extension: ""
                }
            end

            def _get_ptz xml_ptz
                {x_addr: value(xml_ptz, '//tt:XAddr')}
            end
        end
    end
end

