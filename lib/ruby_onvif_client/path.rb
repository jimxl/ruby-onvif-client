def require_relative_dir dir
    Dir[File.join(dir, '*.rb')].each do |file|
        require_relative file
    end
end
