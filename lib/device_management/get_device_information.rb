require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetDeviceInformation < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetDeviceInformation)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = result[:content]
                        puts xml_doc.at('SOAP-ENV|Body')
                        info = {
                            mf: xml_doc.at('Body Manufacturer').content,
                            model: xml_doc.at('Body Model').content,
                            firmware_version: xml_doc.at('Body FirmwareVersion').content,
                            serial_number: xml_doc.at('Body SerialNumber').content,
                            hardware_id: xml_doc.at('Body HardwareId').content,
                        }
                        callback cb, success, info
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

