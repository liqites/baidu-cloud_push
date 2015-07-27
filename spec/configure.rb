Rspec.describe Baidu::Configuration do
  apikey = SETTINGS["baidu"]["apikey"]
	apisecret = SETTINGS["baidu"]["apisecret"]
	client = Baidu::CloudPush.new(apikey,apisecret)
	channel_id = SETTINGS["baidu"]["channel_id"]
	msg = {title:"测试推送",description:"#{Time.now}"}

  describe "when config is :limited" do
  end
end
