require_relative 'service'
Dir.chdir __dir__ do
    require_relative_dir 'media'
end

module ONVIF
    class Media < Service
    end
end

