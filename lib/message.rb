require 'nokogiri'
require "builder"

module ONVIF
    class Message
        attr_writer :body

        def initialize namespaces = {}
            @namespaces = {
                :'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope",
                :'xmlns:wsdl' => "http://www.onvif.org/ver10/device/wsdl"
            }.merge(namespaces)
        end
        
        def to_s
            Builder::XmlMarkup.new(indent: 4).soap(:Envelope, @namespaces) do |xml|
                xml.soap(:Header) do
                end
                xml.soap(:Body) do
                    @body.call(xml) if @body.class == Proc
                end
            end
        end
    end
end

