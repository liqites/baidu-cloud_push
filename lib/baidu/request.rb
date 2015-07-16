require 'net/http'
require 'digest'
require 'sysinfo'

module Baidu
	# 百度云推送API封装类
	#
	# @attr_reader apisecret [String] 应用的secret
	# @attr_reader options [Hash] 配置参数
	class Request
		attr_reader :apisecret,:options

		#@private
		API_URL = '://api.tuisong.baidu.com/rest/3.0'

		#@private
		REQUEST_GET = {
			report: ['statistic_device','statistic_topic','query_msg_status','query_timer_records','query_topic_records'],
			app: ['query_tags'],
			tag: ['device_num'],
			timer: ['query_list'],
			topic: ['query_list']
		}

		def initialize(apisecret,options = {})
			@apisecret = apisecret
			@options = {use_ssl: false}.merge(options)
			@sysinfo = SysInfo.new
		end

		def start(resource,method,params={})
			uri = get_uri(resource,method)
			type = get_type(resource,method)
			send_request(uri,type,params)
		end

		private
		def send_request(uri,type,params)
			params = params.merge({sign:gen_sign(@apisecret,type,uri.to_s,params)})
			req = nil
			case type
			when 'GET'
				uri.query = URI.encode_www_form(params)
				req = Net::HTTP::Get.new(uri)
			when 'POST'
				req = Net::HTTP::Post.new(uri)
				req.set_form_data(params)
			end
			req['Content-Type'] = "application/x-www-form-urlencoded;charset=utf-8"
			req['User-Agent'] = "BCCS_SDK/3.0 (#{@sysinfo.os},#{@sysinfo.arch},#{@sysinfo.impl}) Ruby/#{RUBY_VERSION} (Baidu Push Server SDK V3.0.0)"
			response = Net::HTTP.start(uri.host,uri.port,use_ssl: @options[:use_ssl]){|http| http.request(req)}
			http_response_to_baidu_response(response)
		end

		def get_uri(resource,method)
			URI(get_url(resource,method))
		end

		def get_type(resource,method)
			if REQUEST_GET.has_key?(resource.to_sym) && REQUEST_GET[resource.to_sym].include?(method)
				'GET'
			else
				'POST'
			end
		end

		def get_url(resource,method)
			http = @options[:use_ssl] ? 'https' : 'http'
			"#{http+API_URL}/#{resource}/#{method}"
		end

		def http_response_to_baidu_response(response)
			Baidu::Response.new(response)
		end

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

require 'baidu/response'
