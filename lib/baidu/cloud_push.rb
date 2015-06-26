module Baidu
	# The main Baidu::CloudPush driver
	class CloudPush
		attr_reader :options,:request,:apikey,:public_params
		attr_accessor :devise_type,:expires

		def initialize(apikey,apisecret,options={})
			@apikey = apikey
			@request = Baidu::Request.new(apisecret,options)
		end

		##
		# Push to single device
		# Example:
		#  >> Baidu::CloudPush.new(apikey,apisecret).push_single_device(29380323,"this is a message")
		#  => response(Baidu::Response)
		# Arguments:
		#  channel_id: (String)
		#  msg: (String)
		# Optinal:
		#  msg_type: (Integer) default: 0
		#  msg_expires: (Integer) default: 18000
		#  deploy_status: (Integer) default: 2
		# Return: (Baidu::Response)
		def push_single_device(channel_id,msg,*args)
			resource,method = get_resource_and_method(__method__.to_s)
			params = merge_params(push_default_params,args)
			@request.start(resource,method,params)
		end

		def report_statistic_device
			resource,method = get_resource_and_method(__method__.to_s)
			params = merge_params(push_default_params,{})
			@request.start(resource,method,params)
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
		def merge_params(default,args)
			# Public params
			params = {}
			params[:expires] = Time.now.to_i + 60*@expires unless @expires.nil?
			params[:device_type] = @device_type unless @device_type.nil?
			params[:timestamp] = Time.now.to_i
			params[:apikey] = @apikey

			default_vals = default.values
			default_vals.map.with_index{|v,i|
				default_vals[i] = args[i].nil? ? default_vals[i] : args[i]
			}

			h = {}
			default.keys.each_with_index{|k,i|
				h[k] = default_vals[i]
			}
			params.merge(h)
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

		##
		# Get push resource default params
		# Example:
		#  >> push_default_params
		#  => {
		#		msg_type: 0,
		#		msg_expires: 18000,
		#		deploy_status: 2
		#	 }
		def push_default_params
			{
				msg_type: 0,
				msg_expires: 18000,
				deploy_status: 2
			}
		end
	end
end