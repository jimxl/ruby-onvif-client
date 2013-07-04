Gem::Specification.new do |s|
    s.name        = 'ruby_onvif_client'
    s.version     = '0.0.4'
    s.date        = '2013-07-04'
    s.summary     = "Ruby实现的onvif客户端"
    s.description = "使用ruby实现的简单的onvif客户端"
    s.authors     = ["jimxl"]
    s.email       = 'tianxiaxl@gmail.com'
    s.require_paths = ['lib']
    s.files = Dir.glob("lib/**/*") + %w{Gemfile ruby-onvif-client.gemspec}
    s.homepage    = 'http://dreamcoder.info'

    s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
    s.add_dependency 'em_ws_discovery'
    s.add_dependency 'em-http-request'
    s.add_dependency 'activesupport'
    s.add_dependency 'akami'
end

