require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class AddScopes < Action
            def run scopes, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:AddScopes) do
                        scopes.each do |scope|
                            xml.wsdl :ScopeItem, scope
                        end
                    end
                end
                send_message message do |success, result|
                    if success
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

