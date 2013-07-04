require_relative 'path.rb'
require "uri"
require "ws_discovery"

module ONVIF
    class DeviceDiscovery
        def self.start options = {}
            DeviceDiscovery.new.start(options) do |devices|
                yield devices
            end
        end

        def start options
            @options = {
            }.merge(options)
            searcher = WSDiscovery.search(
                env_namespaces: { 
                    "xmlns:dn" => "http://www.onvif.org/ver10/network/wsdl"
                }, 
                types: "dn:NetworkVideoTransmitter"
            )
            searcher.discovery_responses.subscribe do |notification|
                device = {
                    ep_address: notification[:probe_matches][:probe_match][:endpoint_reference][:address],
                    types: notification[:probe_matches][:probe_match][:types],
                    device_ip: URI(notification[:probe_matches][:probe_match][:x_addrs]).host,
                    device_service_address: notification[:probe_matches][:probe_match][:x_addrs],
                    scopes: notification[:probe_matches][:probe_match][:scopes].split(' '),
                    metadata_version: notification[:probe_matches][:probe_match][:metadata_version]
                }
                yield device
            end
        end
    end
end

