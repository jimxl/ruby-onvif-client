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

        def callback cb, *args
            return if cb.class != Proc
            cb.call *args
        end
    end
end
