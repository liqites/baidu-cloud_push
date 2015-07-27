# v0.1.6
1. 修复设置错误

# v0.1.5
1. 修复bug

# v0.1.4
1. 增加配置 mode，分别为`:limited`和`:super`，默认为,`:limited`模式
2. 在:limited模式下，只能使用`push_single_device` 和 `push_batch_device`两个接口

```ruby
Baidu::CloudPush.configure do |config|
  config.mode = :super
end
```

# v0.1.3
1. 修复require包错误出错的问题
2. 这个版本终于能使用了！

# v0.1.2
1. 修复Baidu::CloudPush中，devise_type的拼写错误导致的bug，应该是device_type
2. 修改其他拼写错误

# v0.1.1
1. 支持所有接口
