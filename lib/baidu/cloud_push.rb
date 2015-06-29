require 'json'

module Baidu
	# The main Baidu::CloudPush driver
	class CloudPush
		attr_reader :request,:apikey
		attr_reader :resource_name,:method_name,:params
		attr_accessor :devise_type,:expires

		def initialize(apikey,apisecret,options={})
			@apikey = apikey
			@request = Baidu::Request.new(apisecret,options)
		end

		def push_single_device(channel_id,msg,opt={})
			set_resource_and_method(__method__.to_s)
			@params = {channel_id:channel_id,msg:msg.to_json}.merge(opt)
			send_request
		end

		def push_all(msg,opt={})
			set_resource_and_method(__method__.to_s)
			@params = {msg:msg.to_json}.merge(opt)
			send_request
		end

		def push_tags(msg,tag,opt={})

		end

		private
		##
		# Merge default and args hash parameters
		# with default public parameter => [timestamp,device_type,expires,apikey]
		# Example:
		#  >> merge_params({msg_type:0,msg_expires:36000},{q:"search keyword"})
		#  => {
		#  			timestamp: 1313293563,
		#  			expires: 1313293565,
		#  			apikey: fdafadAfdsafadsDrfeareV,
		#  			device_type: 3,
		#  			msg_type: 0,
		#  			msg_expires: 36000,
		#  			deploy_status: 0,
		#  			q: "search keyword"
		#  		}
		# Arguments:
		#  default: (Hash)
		#  args: (Hash)
		# Return: (Hash)
		def merge_params(args={})
			# Public params
			params = {}
			params[:expires] = Time.now.to_i + 60*@expires unless @expires.nil?
			params[:device_type] = @device_type unless @device_type.nil?
			params[:timestamp] = Time.now.to_i
			params[:apikey] = @apikey

			params = params.merge(args)
			new_params = {}
			params.sort.each{|p| new_params[p[0]] = p[1]}
			new_params
		end

		##
		# Get resource and method name
		# Example:
		#  >> get_resource_and_method(push_single_device)
		#  => "push","single_device"
		# Arguments:
		#  method_name: (String), should look like "resource_method"
		# Return: (String,String)
		def get_resource_and_method(method_name)
			splited =method_name.sub("_"," ").split(" ")
			return splited[0],splited[1]
		end

		def set_resource_and_method(method_name)
			splited =method_name.sub("_"," ").split(" ")
			@resource_name = splited[0]
			@method_name = splited[1]
		end

		def send_request
			@request.start(@resource_name,@method_name,merge_params(@params))
		end
	end
end
