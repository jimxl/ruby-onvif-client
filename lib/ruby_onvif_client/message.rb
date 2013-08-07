require 'nokogiri'
require "builder"
require "akami"

module ONVIF
    class Message
        attr_writer :body
        attr_accessor :username, :password

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
            self.username = @options[:username]
            self.password = @options[:password]
        end

        def header
            wsse = Akami.wsse
            wsse.credentials(username, password)
            wsse.created_at = Time.now
            wsse.to_xml
            %Q{<wsse:Security soap:mustUnderstand="true" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-31"><wsse:Username>#{username}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">#{password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">vwqgTTRK/D2IeOTP76JHBw==</wsse:Nonce><wsu:Created>2013-08-06T10:22:17.028Z</wsu:Created></wsse:UsernameToken></wsse:Security>}
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

