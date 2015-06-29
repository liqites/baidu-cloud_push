require 'json'

module Baidu
	# The main Baidu::CloudPush driver
	class CloudPush
		attr_reader :request,:apikey
		attr_reader :resource_name,:method_name,:params
		attr_accessor :devise_type,:expires
		# 构造函数
		# 
		# == Parameters:
		# apikey::
		#   (String),应用的key
		# apisecret::
		#   (String),应用的secret
		# options::
		#   (Hash),额外参数，只接受{use_ssl:true}，默认为false，不使用https请求
		def initialize(apikey,apisecret,options={})
			@apikey = apikey
			@request = Baidu::Request.new(apisecret,options)
		end

		# 推送消息到单台设备
		# 
		# == Parameters:
		# channel_id::
		#   (String),对应设备的唯一的channel_id
		# msg::
		#   (Hash),消息内容
		# opt::
		#   (Hash),额外参数，非必须
		#   {msg_type: 消息类型(0:消息，1:通知。默认0),
		#   msg_expires: 消息过期时间(0~604800(86400*7)，默认为5小时(18000秒)),
		#   deploy_status: 设置iOS应用的部署状态，仅iOS应用推送时使用，(1:开发状态，2:部署状态，默认2)}
		# == Returns
		# response(Baidu::Response)
		def push_single_device(channel_id,msg,opt={})
			set_resource_and_method(__method__)
			@params = {channel_id:channel_id,msg:msg.to_json}.merge(opt)
			send_request
		end

		# 推送广播消息
		# 
		# == Parameters:
		# msg::
		#   (String),消息内容
		# opt::
		#   (Hash),额外参数，非必须
		def push_all(msg,opt={})
			set_resource_and_method(__method__)
			@params = {msg:msg.to_json}.merge(opt)
			send_request
		end

		def push_tags(tag,msg,opt={})
			set_resource_and_method(__method__)
			@params = {msg:msg.to_json,tag:tag,type:1}.merge(opt)
			send_request
		end

		def push_batch_device(channel_ids,msg,opt={})
			set_resource_and_method(__method__)
			@params = {channel_ids: channel_ids.to_json, msg: msg.to_json}.merge(opt)
			send_request
		end

		def report_query_msg_status(msg_ids)
			set_resource_and_method(__method__)
			@params = {msg_id: msg_ids.to_json}
			send_request
		end

		def report_query_timer_records(timer_id,opt={})
			set_resource_and_method(__method__)
			@params = {timer_id: timer_id}.merge(opt)
			send_request
		end

		def report_query_topic_records(topic_id,opt={})
			set_resource_and_method(__method__)
			@params = {topic_id:topic_id}.merge(opt)
			send_request
		end

		def app_query_tags(opt={})
		  set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		def app_create_tag(tag)
			set_resource_and_method(__method__)
			@params = {tag: tag}
			send_request
		end

		def app_del_tag(tag)
			set_resource_and_method(__method__)
			@params = {tag:tag}
			send_request
		end

		def tag_add_devices(tag,channel_ids)
			set_resource_and_method(__method__)
			@params = {tag:tag,channel_ids:channel_ids.to_json}
			send_request
		end

		def tag_del_devices(tag,channel_ids)
			set_resource_and_method(__method__)
			@params = {tag:tag,channel_ids:channel_ids.to_json}
			send_request
		end

		def tag_device_num(tag)
			set_resource_and_method(__method__)
			@params = {tag:tag}
			send_request
		end

		def timer_query_list(opt={})
			set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		def timer_cancel(timer_id)
			set_resource_and_method(__method__)
			@params = {timer_id:timer_id}
			send_request
		end

		def topic_query_list(opt={})
			set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		def report_statistic_device
			set_resource_and_method(__method__)
			@params = {}
			send_request
		end

		def report_statistic_topic(topic_id)
			set_resource_and_method(__method__)
			@params = {topic_id:topic_id}
			send_request
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

		def set_resource_and_method(method_name)
			splited =method_name.to_s.sub("_"," ").split(" ")
			@resource_name = splited[0]
			@method_name = splited[1]
		end

		def send_request
			@request.start(@resource_name,@method_name,merge_params(@params))
		end
	end
end
