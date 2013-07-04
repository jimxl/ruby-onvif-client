require_relative 'service'
Dir.chdir __dir__ do
    require_dir 'media'
end

module ONVIF
    class Media < Service
    end
end

