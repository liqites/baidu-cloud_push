# Baidu Could Push SDK 3.0
=========================

## 1. Install
[![Gem Version](https://badge.fury.io/rb/baidu-cloud_push.svg)](http://badge.fury.io/rb/baidu-cloud_push)

`gem install 'baidu-cloud_push'` `gem 'baidu-cloud_push'`

you can find the doc from rubygems.org

## 2. Usage

```ruby
client = Baidu::CloudPush(‘you_api_key’,’your_api_secret’)
client.push_single_device(channel_id,{title:”test”,description:”desc”}
```

## 3. All supported API
1. `push_single_device(channel_id,msg,opt={})`
2. `push_all(msg,opt={})`
3. `push_batch_device(channel_ids,msg,opt={})`
4. `push_tags(tag,msg,opt={})`
5. `app_create_tag(tag)`
6. `app_del_tag(tag)`
7. `app_query_tag(tag)`
8. `report_query_msg_status(msg_ids)`
9. `report_query_timer_records(timer_id,opt={})`
10. `report_query_topic_records(topic_id,opt={})`
11. `report_statistic_device`
12. `report_statistic_topic(topic_id)`
13. `tag_add_devices(tag,channel_ids)`
14. `tag_del_devices(tag,channel_ids)`
15. `tag_device_num(tag)`
16. `timer_cancel(timer_id)`
17. `timer_query_list(opt={})`
18. `topic_query_list(opt={})`

## 4.Contribution
Contributions are very welcome.Whether it's an issue or even a pull request.

## 5.License
MIT
