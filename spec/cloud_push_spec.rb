# Description of method
#
# @return [Type] description of returned object
RSpec.describe Baidu::CloudPush do
	apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["baidu"]["channel_id"]
	message = {title:"title",description:"测试消息"}

	context "private methods" do
	end

	context "public methods" do
		describe ".push_single_device" do
			it "should get retult true" do
				#expect(client.push_single_device(channel_id,message,{msg_type:1}).result).to eq(true)
			end
		end

		describe ".push_all" do
			it "should get result true" do
				expect(client.push_all(message,{msg_type:1}).result).to eq(true)
			end
		end
	end
end
