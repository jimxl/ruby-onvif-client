require_relative 'message'

module ONVIF
    class Action
        def initialize client
            @client = client
        end
        
        def send_message message
            @client.send message.to_s do |success, result|
                yield success, result
            end
        end
    end
end
