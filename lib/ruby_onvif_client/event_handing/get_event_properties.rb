require_relative '../action'

module ONVIF
    module EventAction
        class GetEventProperties < Action
            def run cb
                message = Message.new namespaces: {:'xmlns:wsdl' => 'http://www.onvif.org/ver10/events/wsdl'}
                message.body =  ->(xml) do
                    xml.wsdl(:GetEventProperties)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        # users = []
                        step1 = false
                        step2 = false
                        step3 = false
                        step4 = false
                        step5 = false
                        xml_doc.xpath('//wsnt:TopicExpressionDialect').each do |node|
                            if node.content == 'http://docs.oasis-open.org/wsn/t-1/TopicExpression/Concrete'
                                step1 = true
                            elsif node.content == 'http://www.onvif.org/ver10/tev/topicExpression/ConcreteSet'
                                step2 = true
                            end    
                        end
                        step3 = true if xml_doc.xpath('//tev:MessageContentFilterDialect').first.content == 'http://www.onvif.org/ver10/tev/messageContentFilter/ItemFilter'
                        topic_namespace = xml_doc.xpath('//tev:TopicNamespaceLocation').first.content
                        step4 = true if topic_namespace.include? "http://"
                        #puts xml_doc.xpath('//wstop:TopicSet').size
                        #step5 = true unless xml_doc.xpath('//wstop:TopicSet').size.empty?
                        puts step1, step2, step3, step4, step5
                        if step1 and step2 and step3 and step4# and step5
                            callback cb, success, result
                        else
                            callback cb, false, result
                        end
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

