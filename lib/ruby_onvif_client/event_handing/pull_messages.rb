require_relative '../action'

module ONVIF
    module EventAction
        class PullMessages < Action
            def run options, cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl'}
                message.body =  ->(xml) do
                    xml.wsdl(:PullMessages) do
                        xml.wsdl :Timeout, options[:time_out]
                        xml.wsdl :MessageLimit , options[:message_limit]
                    end
                end
                send_message message do |success, result|
                    if success
                        # xml_doc = Nokogiri::XML(result[:content])
                        # addresses = []
                        # xml_doc.xpath('//tev:SubscriptionReference').each do |node|
                        #     addresses << value(node, 'wsa5:Address')
                        # end
                        # res = {}
                        # puts addresses
                        # res[:addresses] = addresses
                        # current_time = xml_doc.xpath('//wsnt:CurrentTime').first.content
                        # termination_time = xml_doc.xpath('//wsnt:TerminationTime').first.content
                        # puts current_time, termination_time
                        # res[:current_time] = current_time
                        # res[:termination_time] = termination_time
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

