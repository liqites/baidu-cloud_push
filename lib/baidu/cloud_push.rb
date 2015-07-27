require 'json'

module Baidu
	# 云推送的主类
	#
	# @attr_reader request [Baidu::Request] Baidu::Response 实例
	# @attr_reader apikey [String] 应用的key
	# @attr_reader resource_name [String] api的资源名称，如push
	# @attr_reader method_name [String] api的请求方式，如single_device
	# @attr_reader params [Hash] 请求参数
	# @attr devise_type [Fixnum] 设备类型，3安卓设备，4iOS设备
	# @attr expires [Fixnum]
	# 	用户指定本次请求签名的失效时间。格式为unix时间戳形式，
	# 	用于防止 replay 型攻击。为保证防止 replay攻击算法的正确有效，请保证客户端系统时间正确
	class CloudPush
		attr_reader :request,:apikey
		attr_reader :resource_name,:method_name,:params
		attr_accessor :device_type,:expires

		LIMITED_ALLOWED = ["push_single_device","push_batch_device"]

		# 构造函数
		#
		# @param apikey [String] 应用的key
		# @param apisecret [String] 应用的secret
		# @param options [Hash] 自定义参数
		# @option options [boolean] :use_ssl 默认:false，不使用https请求
		def initialize(apikey,apisecret,options={})
			@apikey = apikey
			@request = Baidu::Request.new(apisecret,options)
			@config = Baidu::Configuration.new({mode: :limited})
		end

		# 推送消息到单台设备
		#
		# @param channel_id [String] 设备唯一的channel_id
		# @param msg [Hash] 消息内容
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :msg_type 消息类型
		# @option opt [Fixnum] :msg_expires 消息过期时间,unix timestamp
		# @option opt [Fixnum] :deploy_status iOS应用部署状态
		# @return [Baidu::Response]
		def push_single_device(channel_id,msg,opt={})
			set_resource_and_method(__method__)
			@params = {channel_id:channel_id,msg:msg.to_json}.merge(opt)
			send_request
		end

		# 推送广播消息
		#
		# @param msg [Hash] 消息内容
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :msg_type 消息类型
		# @option opt [Fixnum] :msg_expires 消息过期时间,unix timestamp
		# @option opt [Fixnum] :deploy_status iOS应用部署状态
		# @option opt [Fixnum] :send_time 指定发送的实际时间
		# @return [Baidu::Response]
		def push_all(msg,opt={})
			set_resource_and_method(__method__)
			@params = {msg:msg.to_json}.merge(opt)
			send_request
		end

		# 推送组播消息
		#
		# @param tag [String] 标签类型
		# @param msg [Hash] 消息内容
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :msg_type 消息类型
		# @option opt [Fixnum] :msg_expires 消息过期时间,unix timestamp
		# @option opt [Fixnum] :deploy_status iOS应用部署状态
		# @option opt [Fixnum] :send_time 指定发送的实际时间
		# @return [Baidu::Response]
		def push_tags(tag,msg,opt={})
			set_resource_and_method(__method__)
			@params = {msg:msg.to_json,tag:tag,type:1}.merge(opt)
			send_request
		end

		# 推送到给定的一组设备
		#
		# @param channel_ids [Array<String>] 一组channel_ids
		# @param msg [Hash] 消息内容
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :msg_type 消息类型
		# @option opt [Fixnum] :msg_expires 消息过期时间,unix timestamp
		# @option opt [String] :topic_id 分类主题名称
		def push_batch_device(channel_ids,msg,opt={})
			set_resource_and_method(__method__)
			@params = {channel_ids: channel_ids.to_json, msg: msg.to_json}.merge(opt)
			send_request
		end

		# 查询消息的发送状态
		#
		# @param msg_ids [Array<String>] msg_id的数组
		# @return [Baidu::Response]
		def report_query_msg_status(msg_ids)
			set_resource_and_method(__method__)
			@params = {msg_id: msg_ids.to_json}
			send_request
		end

		# 查询定时消息的发送记录
		#
		# @param timer_id [String] 推送接口返回的timer_id
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :start 返回记录的索引起始位置
		# @option opt [Fixnum] :limit 返回的记录条数
		# @option opt [Fixnum] :range_start 查询的起始时间,unix timestamp
		# @option opt [Fixnum] :range_end 查询的戒指时间,unix timestamp
		# @return [Baidu::Response]
		def report_query_timer_records(timer_id,opt={})
			set_resource_and_method(__method__)
			@params = {timer_id: timer_id}.merge(opt)
			send_request
		end

		# 查询指定分类主题的发送记录
		#
		# @param topic_id [String] 分类主题的名称
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :start 返回记录的索引起始位置
		# @option opt [Fixnum] :limit 返回的记录条数
		# @option opt [Fixnum] :range_start 查询的起始时间,unix timestamp
		# @option opt [Fixnum] :range_end 查询的戒指时间,unix timestamp
		# @return [Baidu::Response]
		def report_query_topic_records(topic_id,opt={})
			set_resource_and_method(__method__)
			@params = {topic_id:topic_id}.merge(opt)
			send_request
		end

		# 查询标签组的列表
		#
		# @param opt [Hash] 自定义参数
		# @option opt [String] :tag 标签名称
		# @option opt [Fixnum] :start 返回记录的索引起始位置
		# @option opt [Fixnum] :limit 返回的记录条数
		# @return [Baidu::Response]
		def app_query_tags(opt={})
		  set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		# 创建标签组
		#
		# @param tag [String] 标签名称
		# @return [Baidu::Response]
		def app_create_tag(tag)
			set_resource_and_method(__method__)
			@params = {tag: tag}
			send_request
		end

		# 删除标签组
		#
		# @param tag [String] 标签名称
		# @return [Baidu::Response]
		def app_del_tag(tag)
			set_resource_and_method(__method__)
			@params = {tag:tag}
			send_request
		end


		# 添加设备到标签组
		#
		# @param tag [String] 标签名称
		# @param channel_ids [Array<String>] 一组channel_id
		# @return [Baidu::Response]
		def tag_add_devices(tag,channel_ids)
			set_resource_and_method(__method__)
			@params = {tag:tag,channel_ids:channel_ids.to_json}
			send_request
		end

		# 将设备从标签组中移除
		#
		# @param tag [String] 标签名称
		# @param channel_ids [Array<String>] 一组channel_id
		# @return [Baidu::Response]
		def tag_del_devices(tag,channel_ids)
			set_resource_and_method(__method__)
			@params = {tag:tag,channel_ids:channel_ids.to_json}
			send_request
		end

		# 查询标签组设备数量
		#
		# @param tag [String] 标签名称
		# @return [Baidu::Response]
		def tag_device_num(tag)
			set_resource_and_method(__method__)
			@params = {tag:tag}
			send_request
		end

		# 查询定时任务列表
		#
		# @param opt [Hash] 自定义参数
		# @option opt [String] :timer_id
		# @option opt [Fixnum] :start 返回记录的索引起始位置
		# @option opt [Fixnum] :limit 返回的记录条数
		# @return [Baidu::Response]
		def timer_query_list(opt={})
			set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		# 取消定时任务
		#
		# @param timer_id [String] 定时任务ID
		# @return [Baidu::Response]
		def timer_cancel(timer_id)
			set_resource_and_method(__method__)
			@params = {timer_id:timer_id}
			send_request
		end

		# 查询分类主题列表
		#
		# @param opt [Hash] 自定义参数
		# @option opt [Fixnum] :start 返回记录的索引起始位置
		# @option opt [Fixnum] :limit 返回的记录条数
		# @return [Baidu::Response]
		def topic_query_list(opt={})
			set_resource_and_method(__method__)
			@params = opt
			send_request
		end

		# 当前应用的设备统计
		#
		# @return [Baidu::Response]
		def report_statistic_device
			set_resource_and_method(__method__)
			@params = {}
			send_request
		end

		# 查看分类主题统计信息
		#
		# @param topic_id [String] 一个已使用过的分类主题
		# @return [Baidu::Response]
		def report_statistic_topic(topic_id)
			set_resource_and_method(__method__)
			@params = {topic_id:topic_id}
			send_request
		end

		# Configuration
		#
		# @param &block [Block]
		def configure(&block)
			block.call(@config)
		end

		private
		def merge_params(args={})
			now_time = Time.now.to_i
			params = {
				timestamp: now_time,
				apikey: @apikey
			}
			params[:expires] = now_time + 60*@expires unless @expires.nil?
			params[:device_type] = @device_type unless @device_type.nil?

			new_params = {}

			params.merge(args).sort.each{|p| new_params[p[0]] = p[1]}
			new_params
		end

		def set_resource_and_method(method_name)
			splited =method_name.to_s.sub("_"," ").split(" ")
			@resource_name = splited[0]
			@method_name = splited[1]
		end

		def send_request
			if @config.mode == :super || LIMITED_ALLOWED.include?(@method_name)
				@request.start(@resource_name,@method_name,merge_params(@params))
			else
				return Baidu::Response.new()
			end
		end
	end
end

require 'baidu/request'
require 'baidu/response'
require 'baidu/configuration'
