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
                        #info = {
                            #mf: value(xml_doc, 'Body Manufacturer'),
                            #model: value(xml_doc, 'Body Model'),
                            #firmware_version: value(xml_doc, 'Body FirmwareVersion'),
                            #serial_number: value(xml_doc, 'Body SerialNumber'),
                            #hardware_id: value(xml_doc, 'Body HardwareId')
                        #}
                        callback cb, success, result
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

