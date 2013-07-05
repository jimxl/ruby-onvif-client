require_relative 'client'
require "active_support/all"

module ONVIF
    class Service
        def initialize address, username = 'admin', password = 'admin'
            @client = ONVIF::Client.new(
                address: address
            )
            @username = username
            @password = password
        end

        def method_missing(m, *args, &blcok)
            action_class = ONVIF.const_get(%Q{#{self.class.name}Action}).const_get(m.to_s.camelize) rescue nil
            unless action_class.nil?
                self.class.class_exec do
                    define_method m do |*r|
                        action_class.new(@client, @username, @password).run(*r)
                    end
                end
                self.send m, *args
            else
                super
            end
        end

        def respond_to?(m, include_private = false)
            action_class = ONVIF.const_get(%Q{#{self.class.name}Action}).const_get(m.to_s.camelize) rescue nil
            unless action_class.nil?
                true
            else
                super
            end
        end

    end
end

