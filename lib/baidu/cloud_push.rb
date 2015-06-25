module Baidu
	class CloudPush
		attr_reader :apikey,:apisecret,:options

		def initialize(apikey,apisecret,options={})
			@apikey = apikey
			@apisecret = @apisecret
		end

		def test
			puts "#{@apikey},#{@apisecret}"
		end
	end
end