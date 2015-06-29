# Description of method
#
# @return [Type] description of returned object
RSpec.describe Baidu::CloudPush do
	apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["baidu"]["channel_id"]
	msg = {title:"测试推送",description:"测试内容,#{Time.now}"}

	context "private methods" do
	end

	context "public methods" do
		describe ".push_single_device" do
			it "should get result true with msg_type = default(0)" do
				msg = {title: "push single device, msg_type = 0",description:"描述"}
				expect(client.push_single_device(channel_id,msg).result).to eq(true)
			end

			it "should get result true with msg_type = 1 notification " do
				msg = {title: "push single device, msg_type = 1", description:"描述"}
				expect(client.push_single_device(channel_id,msg,{msg_type:1}).result).to eq(true)
			end
		end

		describe ".push_all" do
			it "should get result true with msg_type = default(0)" do
				msg = {title: "push all, msg_type = 0",description:"描述"}
				expect(client.push_all(msg).result).to eq(true)
			end

			it "should get result true with msg_type = 1 notification " do
				msg = {title: "push all, msg_type = 1", description:"描述"}
				expect(client.push_all(msg,{msg_type:1}).result).to eq(true)
			end
		end
	end
end
