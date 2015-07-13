Gem::Specification.new do |s|
	s.name         = 'baidu-cloud_push'
	s.version      = '0.1.2'
	s.date         = '2015-06-25'
	s.summary      = 'Baidu Cloud Push Rest SDK 3.0'
	s.description  = 'This is the Ruby SDK for Baidu Cloud Push RestAPI version 3.0'
	s.authors      = ["Tesla Lee"]
	s.email        = 'leechee89@hotmail.com'
	s.files        = ["lib/baidu.rb","lib/baidu/cloud_push.rb","lib/baidu/request.rb","lib/baidu/response.rb"]
	s.homepage     =
		'https://github.com/liqites/baidu-cloud_push'
	s.license      = 'MIT'
	s.add_runtime_dependency 'sysinfo'
	s.required_ruby_version = '>= 1.9.3'
end
