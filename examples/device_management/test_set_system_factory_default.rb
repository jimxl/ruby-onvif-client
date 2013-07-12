require_relative "../../lib/ruby_onvif_client"

EM.run do
    device = ONVIF::DeviceManagement.new("http://192.168.2.145/onvif/device_service")
    type = 'Hard' #'Hard', 'Soft'   FactoryDefault 
    device.set_system_factory_default type, ->(success, result) {
    	puts '--------------', result, '============'
    }
end
#{:token=>"NetworkInterfaces_1", :enabled=>"true", :info=>{:name=>"NetworkInterfaces_Info_1", :hw_address=>"0000510203A1", :mtu=>"1500"}, :ipv4=>{:enabled=>"true", :config=>{:manual=>[{:address=>"192.168.2.145", :prefix_length=>"24"}], :link_local=>{:address=>"192.168.2.145", :prefix_length=>"24"}, :form_dhcp=>{:address=>"192.168.2.145", :prefix_length=>"24"}, :dhcp=>"true"}}}
