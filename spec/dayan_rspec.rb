RSpec.describe Baidu::CloudPush do
	apikey = SETTINGS["dayan"]["apikey"]
	apisecret = SETTINGS["dayan"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["dayan"]["channel_id"]
	message = {aps: {alert: "专题推送","content-available" => 1},push_type: 0, push_content: "lanyu"}

  describe "when " do
    it "should send to ios" do
			client.device_type = 4
      response = client.push_single_device(channel_id,message,{deploy_status: 2})
			puts response.to_json
			expect(1).to eq(1)
    end
  end
end
