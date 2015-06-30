require 'json'

module Baidu
	class Response
		attr_reader :request_id,:response_params,:error_code,:error_msg,:result

		def initialize(http_response)
			body = JSON.parse(http_response.body)
			if http_response.code.to_i == 200
				# success
				@result = true
				@request_id = body["request_id"]
				@response_params = body["response_params"]
			else
				# failed
				@result = false
				@request_id = body["request_id"]
				@error_code = body["error_code"]
				@error_msg = body["error_msg"]
			end
		end

		# to_json
		#
		# @return [Hash] 返回一个Hash
		def to_json
			if @result
				{
					result: @result,
					request_id: @request_id,
					response_params: @response_params
				}
			else
				{
					result: @result,
					request_id: @request_id,
					error_code: @error_code,
					error_msg: @error_msg
				}
			end
		end
	end
end
