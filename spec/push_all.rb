RSpec.describe Baidu::CloudPush do
	apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
  client.device_type = 3
  msg = {title:"测试推送",description:"#{Time.now}"}


  describe "push_2_times" do
    it "push_to_andriod" do
      response = client.push_all(msg)
      response = client.push_all(msg)
      response = client.push_all(msg)
      expect(1).to eq(1)
    end
  end
end
