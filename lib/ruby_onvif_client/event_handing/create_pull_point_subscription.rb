require_relative '../action'

module ONVIF
    module EventAction
        class CreatePullPointSubscription < Action
            def run time, cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl'}
                message.body =  ->(xml) do
                    xml.wsdl(:CreatePullPointSubscription) do
                        xml.wsdl :InitialTerminationTime, time
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        addresses = []
                        xml_doc.xpath('//tev:SubscriptionReference').each do |node|
                            addresses << value(node, 'wsa5:Address')
                        end
                        res = {}
                        puts addresses
                        res[:addresses] = addresses
                        current_time = xml_doc.xpath('//wsnt:CurrentTime').first.content
                        termination_time = xml_doc.xpath('//wsnt:TerminationTime').first.content
                        puts current_time, termination_time
                        res[:current_time] = current_time
                        res[:termination_time] = termination_time
                        callback cb, success, res
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

