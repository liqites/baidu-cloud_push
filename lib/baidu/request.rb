require 'net/http'
require 'digest'
require 'sysinfo'

module Baidu
	class Request
		attr_reader :apisecret,:options
		##
		# Base api url
		API_URL = '://api.tuisong.baidu.com/rest/3.0'

		##
		# All resource,methods include in
		# this hash should use the Get request
		# type
		REQUEST_GET = {
			report: ['statistic_device']
		}

		def initialize(apisecret,options = {})
			@apisecret = apisecret
			@options = {use_ssl: false}.merge(options)
			@sysinfo = SysInfo.new
		end

		##
		# Start request to Baidu Push Server
		# Example:
		#  >> start("push","single_device",{k:v,k:v})
		#  => response(Baidu::Response)
		# Arguments:
		#  resource: (String)
		#  method:   (String)
		#  params:   (Hash)
		# Return: (Baidu::Response)
		def start(resource,method,params={})
			send_request(resource,method,params)
		end

		private
		##
		# Send request to Baidu Push Server
		# Example:
		#  >> send_request("push","single_device",{k:v,k:v})
		#  => response(Baidu::Response)
		# Arguments:
		#  resource: (String)
		#  method:   (String)
		#  params:   (Hash)
		# Return: (Baidu::Response)
		def send_request(resource,method,params)
			uri = get_uri(resource,method)
			type = get_type(resource,method)
			params = params.merge({sign:gen_sign(@apisecret,type,get_url(resource,method),params)})
			req = nil
			case type
			when 'GET'
				uri.query = URI.encode_www_form(params)
				req = Net::HTTP::Get.new(uri)
			when 'POST'
				req = Net::HTTP::Post.new(uri)
				puts URI.encode_www_form(params)
				req.set_form_data(params)
			end
			puts req.body
			puts req.uri
			# Headers
			req['Content-Type'] = "application/x-www-form-urlencoded;charset=utf-8"
			req['User-Agent'] = "BCCS_SDK/3.0 (#{@sysinfo.os},#{@sysinfo.arch},#{@sysinfo.impl}) Ruby/#{RUBY_VERSION} (Baidu Push Server SDK V3.0.0)"
			#response = Net::HTTP.start(uri.host,uri.port,use_ssl: @options[:use_ssl]){|http| http.request(req)}
			#http_response_to_baidu_response(response)
			
			#puts response.code
			#puts response.msg
			#puts response.message
		end

		##
		# Get URI by resource and method
		# Example:
		#  >> get_uri("push","single_device")
		#  => #<URI::HTTP:0x007fc0639744a8 URL:http(s)://www.baidu.com>
		# Arguments:
		#  resource: (String)
		#  method:   (String)
		# Return: (URI)
		def get_uri(resource,method)
			URI(get_url(resource,method))
		end

		##
		# Get request method type by resource and method
		# Example:
		#  >> get_type("push","single_device")
		#  => "GET"
		# Arguments:
		#  resource: (String)
		#  method:   (String)
		# Return: (String)
		def get_type(resource,method)
			if REQUEST_GET.has_key?(resource.to_sym) && REQUEST_GET[resource.to_sym].include?(method)
				'GET'
			else
				'POST'
			end
		end

		##
		# Get url by resource and method
		# Example:
		#  >> get_url("push","method")
		#  => "http(s)://api.tuisong.baidu.com/rest/3.0/push/single_device"
		# Arguments:
		#  resource: (String)
		#  method:   (String)
		# Return: (String)
		def get_url(resource,method)
			http = @options[:use_ssl] ? 'https' : 'http'
			"#{http+API_URL}/#{resource}/#{method}"
		end

		##
		# Convert Net::HTTPResponse to Baidu::Response
		def http_response_to_baidu_response(response)

		end

		##
		# Generate sign
		# Example:
		#  >> sign("87772555E1C16715EBA5C85341684C58","POST","http://api.tuisong.baidu.com/rest/3.0/test/echo",{apikey:"asdasd",expires:123123123,timestamp:123123123})
		#  => "sign"
		# Arguments:
		#  apisecret:      (String)
		#  request_methos: (String)
		#  url:            (String)
		#  params:         (Hash)
		# Return: (String)
		def gen_sign(apisecret,requet_method,url,params)
			parameter = requet_method+url
			params.sort.each{|p|
				parameter = parameter + "#{p[0]}=#{p[1]}"
			}
			parameter = parameter + apisecret
			Digest::MD5.hexdigest(URI.encode_www_form_component(parameter))
		end
	end
end