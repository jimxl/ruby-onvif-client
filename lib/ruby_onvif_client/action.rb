require_relative 'message'

module ONVIF
    class Action
        def initialize client, username, password
            @client = client
            @username = username
            @password = password
        end
        
        def send_message message
            message.username = @username
            message.password = @password
            @client.send message.to_s do |success, result|
                yield success, result
            end
        end

        def callback cb, *args
            return if cb.class != Proc
            cb.call *args
        end

        def value xml_doc, xpath
            node = xml_doc.at_xpath(xpath)
            return node.content unless node.nil?
            ''
        end
        def attribute xml_doc, xpath
            node = xml_doc[xpath]
            return node unless node.nil?
            ''
        end

        def create_media_onvif_message options = {}
            namespaces = {
                :'xmlns:wsdl' => "http://www.onvif.org/ver10/media/wsdl"
            }.merge(options[:namespaces] || {})
            options[:namespaces] = namespaces
            Message.new options
        end

        def create_ptz_onvif_message options = {}
            namespaces = {
                :'xmlns:wsdl' => "http://www.onvif.org/ver20/ptz/wsdl"
            }.merge(options[:namespaces] || {})
            options[:namespaces] = namespaces
            Message.new options
        end

        def create_event_onvif_message options = {}
            namespaces = {
                :'xmlns:wsdl' => "http://www.onvif.org/ver10/events/wsdl"
            }.merge(options[:namespaces] || {})
            options[:namespaces] = namespaces
            Message.new options
        end
    end
end
