

#HDP Druid POC

Druid cluster info:
-------------------
overlord/indexing
http://<indexing_node>:8090/console.html

coordinator
http://<coordinator-console>:8081/#/

Input data:
-----------
Use mock_data.py to create random clickstreams event.

[root@c298-node2 druid-pageviews]# cat events.json | head -10
{"eventId":"e2255275", "timestamp":"2012-08-04T15:00:00Z", "userId":"u7", "url":"http://site.com/1"}
{"eventId":"e2255276", "timestamp":"2012-08-04T15:00:00Z", "userId":"u4", "url":"http://site.com/3"}
{"eventId":"e2255277", "timestamp":"2012-08-04T15:00:00Z", "userId":"u9", "url":"http://site.com/1"}
{"eventId":"e2255278", "timestamp":"2012-08-04T15:00:00Z", "userId":"u6", "url":"http://site.com/4"}
{"eventId":"e2255279", "timestamp":"2012-08-04T15:00:00Z", "userId":"u8", "url":"http://site.com/4"}
{"eventId":"e2255280", "timestamp":"2012-08-04T15:00:00Z", "userId":"u7", "url":"http://site.com/1"}
{"eventId":"e2255281", "timestamp":"2012-08-04T15:00:00Z", "userId":"u9", "url":"http://site.com/4"}
{"eventId":"e2255282", "timestamp":"2012-08-04T15:00:00Z", "userId":"u7", "url":"http://site.com/1"}
{"eventId":"e2255283", "timestamp":"2012-08-04T15:00:00Z", "userId":"u3", "url":"http://site.com/3"}
{"eventId":"e2255284", "timestamp":"2012-08-04T15:00:00Z", "userId":"u4", "url":"http://site.com/4"}


Create index using task1:
-------------------------
[root@c298-node2 druid-pageviews]# curl -X POST -H "Content-Type: application/json" -d @task1.json "http://10.42.17.7:8090/druid/indexer/v1/task"
{"task":"index_pageviews_2019-10-23T07:00:14.846Z"}

Index for task1
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/task1_index.png)](#features)

select query output:
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/query_select.png)](#features)

timeseries query with pretty output:
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/query_timeseries.png)](#features)


Create index for another dimension 'url' for same data using task2:
-------------------------------------------------------------------
[root@c298-node2 druid-pageviews]# curl -X POST -H "Content-Type: application/json" -d @task2.json "http://10.42.17.7:8090/druid/indexer/v1/task"
{"task":"index_pageviews_2019-10-23T09:36:33.372Z"}

Index for task2
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/task2_index.png)](#features)

timeseries query with pretty output for 'url' dimension:
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/query_timeseries_url.png)](#features)


Indexed data gives instant result even for 1M records:
------------------------------------------------------
timeseries query with pretty output for 'url' dimension:
[![solarized dualmode](https://github.com/chitrartha/Data_Engineering/blob/master/Druid_poc/druid_poc_images/mock_data_task_index.png)](#features)
