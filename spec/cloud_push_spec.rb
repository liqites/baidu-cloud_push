RSpec.describe Baidu::CloudPush
	client = Baidu::CloudPush.new("test","test")
	channel_id = "4611053353162104488"
	message = {title:"title",description:"测试消息"}

	context "private methods" do
		it ".get_resource_and_method should get ['push','single_device']" do
			expect(client.instance_eval{ get_resource_and_method("push_single_device") }).to eq(["push","single_device"])
		end

		it ".push_default_params should return hash with keys [:msg_type,:msg_expires,:deploy_status] " do
			expect(client.instance_eval{ push_default_params }.keys).to eq([:msg_type,:msg_expires,:deploy_status])
		end

		it ".merge_params should return hash inlcude keys [:expires,:device_type,:timestamp,:apikey]" do
			expect(client.instance_eval{ merge_params(push_default_params,{q:"a"}) }.keys).to include(:timestamp,:apikey)
		end
	end

	describe "#push_single_device" do
		it "should send success" do
			expect(client.report_statistic_device).to eq(0)
		end
	end
end