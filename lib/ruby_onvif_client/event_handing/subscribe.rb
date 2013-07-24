require_relative '../action'

module ONVIF
    module EventHandingAction
        class Subscribe < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:Subscribe)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        users = []
                        xml_doc.xpath('//tds:User').each do |node|
                            users << {
                                name: value(node, 'tt:Username'),
                                password: value(node, 'tt:Password'),
                                user_level: value(node, 'tt:UserLevel')
                            }
                        end

                        callback cb, success, users
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

