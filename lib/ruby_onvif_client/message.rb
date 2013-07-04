require 'nokogiri'
require "builder"
require "akami"

module ONVIF
    class Message
        attr_writer :body

        def initialize options = {}
            @options = {
                username: 'admin',
                password: 'admin',
                namespaces: {}
            }.merge(options)

            @namespaces = {
                :'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope",
                :'xmlns:wsdl' => "http://www.onvif.org/ver10/device/wsdl"
            }.merge(@options[:namespaces])
        end

        def header
            wsse = Akami.wsse
            wsse.credentials(@options[:username], @options[:password])
            wsse.created_at = Time.now
            wsse.to_xml
        end
        
        def to_s
            Builder::XmlMarkup.new(indent: 4).soap(:Envelope, @namespaces) do |xml|
                xml.soap(:Header) do
                    xml << header
                end
                xml.soap(:Body) do
                    @body.call(xml) if @body.class == Proc
                end
            end
        end
    end
end

