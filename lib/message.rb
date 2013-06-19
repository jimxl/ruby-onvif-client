require 'nokogiri'

module ONVIF
    class Message
        attr_writer :body

        def initialize namespaces = {}
            @namespaces = {
                soap: "http://www.w3.org/2003/05/soap-envelope",
                wsdl: "http://www.onvif.org/ver10/device/wsdl"
            }.merge(namespaces)
        end
        
        def to_s
            Builder::XmlMarkup.new(indent: 4).s(:Envelope, @namespaces) do |xml|
                xml.s(:Header) do
                end
                xml.soap(:Body) do
                    @body.call(xml) if @body.class == Proc
                end
            end
        end
    end
end

