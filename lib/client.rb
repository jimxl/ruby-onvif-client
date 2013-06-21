require "em-http"
require "nokogiri"

module ONVIF
    class Client
        def initialize options
            @options = {
                connect_timeout: 5,
                username: 'admin',
                password: 'admin'
            }.merge(options)
        end

        def send data
            puts "send data to #{@options[:address]} ", data 
            http_options = {
                connect_timeout: @options[:connect_timeout]
            }
            request_options = {
                body: data,
                head: {
                    authorization: [@options[:username], @options[:password]]
                }
            }
            http = EventMachine::HttpRequest.new(
                @options[:address], 
                http_options
            ).post(request_options)
            http.errback { yield false, {} }
            http.callback do
                if http.response_header.status != 400
                    yield false, {header: http.response_header}
                else
                    yield true, {
                        header: http.response_header,
                        content: Nokogiri::XML(http.response)
                    }
                end
            end
        end
    end
end

