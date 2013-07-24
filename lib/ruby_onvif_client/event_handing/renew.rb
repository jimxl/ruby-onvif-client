require_relative '../action'

module ONVIF
    module EventAction
        class Renew < Action
            def run time, cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl', 'xmlns' => "http://docs.oasis-open.org/wsn/b-2"}
                message.body =  ->(xml) do
                    xml.Renew do
                        xml.TerminationTime time
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        res = {}
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

