Gem::Specification.new do |s|
    s.name        = 'ruby-onvif-client'
    s.version     = '0.0.1'
    s.date        = '2013-07-02'
    s.summary     = "Ruby实现的onvif客户端"
    s.description = "使用ruby实现的简单的onvif客户端"
    s.authors     = ["jimxl"]
    s.email       = 'tianxiaxl@gmail.com'
    s.require_paths = ['lib']
    s.homepage    = 'http://dreamcoder.info'

    s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
    s.add_dependency 'em_ws_discovery'
    s.add_dependency 'em-http-request'
    s.add_dependency 'active_support'
    s.add_dependency 'i18n'
    s.add_dependency 'akami'
end

