RSpec.describe Baidu::Configuration do
  apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["baidu"]["channel_id"]
	msg = {title:"测试推送",description:"#{Time.now}"}


  describe "when config is :limited" do
    it "send single device should be successfully" do
      client.device_type = 3
      expect(client.push_single_device(channel_id,msg).result).to eq(true)
    end

    it "send push_all should be failure" do
      client.device_type = 3
      expect(client.push_all(msg).result).to eq(false)
    end
  end

  describe "when config is :super" do
    it "send single device should be successfully" do
      client.device_type = 3
      expect(client.push_single_device(channel_id,msg).result).to eq(true)
    end

    it "send push_all should be successfully" do
      client.device_type = 3
      expect(client.push_all(msg).result).to eq(false)
    end
  end
end
