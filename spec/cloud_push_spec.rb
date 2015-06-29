RSpec.describe Baidu::CloudPush do
	apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["baidu"]["channel_id"]
	msg = {title:"测试推送",description:"#{Time.now}"}

	context "PUBLIC APIS" do
		describe ".push_single_device" do
			it "should sent successfully with msg_type = 0" do
				expect(client.push_single_device(channel_id,msg).result).to eq(true)
			end

			it "should sent successfully with msg_type = 1(notification) " do
				expect(client.push_single_device(channel_id,msg,{msg_type:1}).result).to eq(true)
			end
		end

		describe ".push_all" do
			it "should sent successfully with msg_type = 0" do
				expect(client.push_all(msg).result).to eq(true)
			end

			it "should sent successfully with msg_type = 1(notification) " do
				expect(client.push_all(msg,{msg_type:1}).result).to eq(true)
			end
		end

		describe ".push_tags" do
		  it "should sent successfully with msg_type = 0" do
				expect(client.push_tags("test",msg).result).to eq(true)
		  end

			it "should sent successfully with msg_type = 1(notification)" do
				expect(client.push_tags("test",msg,{msg_type:1}).result).to eq(true)
			end
		end

		describe ".push_batch_device" do
			msg = {title:"push batch device",message:"#{Time.now}"}

			it "should send successfully with msg_type = 0" do
			  expect(client.push_batch_device([channel_id],msg).result).to eq(true)
			end

			it "should send successfully with msg_type = 1" do
			  expect(client.push_batch_device([channel_id],msg,{msg_type:1}).result).to eq(true)
			end

			it "should send successfully with msg_type = 1 and topic_id " do
				expect(client.push_batch_device([channel_id],msg,{msg_type:1,topic_id:"topic"}).result).to eq(true)
			end
		end

		describe ".report_query_msg_status" do
		  it "should get message status successfully" do
		    response = client.push_single_device(channel_id,msg,{msg_type:1})
				msg_id = response.response_params["msg_id"]
				expect(client.report_query_msg_status([msg_id]).response_params["total_num"].to_i).to eq(1)
		  end
		end

		describe ".report_query_timer_records" do
		  it "should get timer info successfully" do
				response = client.push_all(msg,{send_time:Time.now.to_i+60,msg_type:1})
				timer_id = response.response_params["timer_id"]
				expect(client.report_query_timer_records(timer_id).result).to eq(true)
		  end
		end

		describe ".report_query_topic_records" do
			it "should get topic records" do
				topic_id = "topic"
			  expect(client.report_query_topic_records(topic_id).result).to eq(true)
			end
		end

		describe ".app_create_tag" do
			it "should create tag successfully" do
				expect(client.app_create_tag("atag").result).to eq(true)
			end
		end

		describe ".app_query_tags" do
		  it "should get tag list" do
		    expect(client.app_query_tags.result).to eq(true)
		  end
		end


		describe ".tag_add_devices" do
			it "should add devices successfully" do
				expect(client.tag_add_devices("atag",[channel_id]).result).to eq(true)
			end
		end

		describe ".tag_device_num" do
			it "should get 1 devices num" do
				expect(client.tag_device_num("atag").response_params["device_num"].to_i).to eq(1)
			end
		end

		describe ".tag_del_devices" do
			it "should delete devices successfully" do
				expect(client.tag_del_devices("atag",[channel_id]).result).to eq(true)
			end
		end

		describe ".app_del_tag" do
			it "should delete tag successfully" do
				expect(client.app_del_tag("atag").result).to eq(true)
			end
		end

		describe ".timer_query_list" do
			it "should get timer list successfully" do
			  expect(client.timer_query_list.result).to eq(true)
			end
		end

		describe ".timer_cancel" do
			it "should cancel timer successfully" do
				response = client.push_all(msg,{send_time:Time.now.to_i+600})
				timer_id = response.response_params["timer_id"]
				expect(client.timer_cancel(timer_id).result).to eq(true)
			end
		end

		describe ".topic_query_list" do
		  it "should get topic list" do
		    expect(client.topic_query_list.result).to eq(true)
		  end
		end

		describe ".report_statistic_device" do
			it "should get statistic devices info" do
			  expect(client.report_statistic_device.result).to eq(true)
			end
		end

		describe ".report_statistic_topic" do
		  it "should get statistic of topics" do
		    expect(client.report_statistic_topic("test").result).to eq(true)
		  end
		end
	end
end
