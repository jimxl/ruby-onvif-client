require "em-http"
require "nokogiri"

module ONVIF
    class Client
        def initialize options
            @options = {
                connect_timeout: 5,
            }.merge(options)
        end

        def send data
            puts "send data to #{@options} ", data 
            http_options = {
                connect_timeout: @options[:connect_timeout]
            }
            request_options = {
                body: data,
            }
            http = EventMachine::HttpRequest.new(
                @options[:address], 
                http_options
            ).post(request_options)
            puts http.inspect
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

