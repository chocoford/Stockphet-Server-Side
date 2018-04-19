#Stockphet Server Side API
*<>代表参数类型，[]表示可选参数，*

##入库API

daily_stock

~~~ swift
http://localhost:8088/insert_ds
~~~

daily_index

~~~ swift
http://localhost:8088/insert_di
~~~

daily_block

~~~ swift
http://localhost:8088/insert_db
~~~
***前提：必须在与服务器主机一致的host才能生效***


*其中date精确到日期即可，注意需要用post的方式将要入库的数据以json形式上传到后端制定路由*


##Query API


###daily stock
~~~swift
http://118.89.59.190:8088/query/dailyStocks?[code=<string>&][name=<string>&]date=<string>
~~~
*注：日期为必填参数*

* 若指定了特定股票和特定日期，返回json形式为`Dictionary<String: String>`
* 若没指定特定股票，返回的是指定日期的所有股票涨跌信息，返回json形式为`Array<Dictionary<String: String>>`
* 若只指定特定股票代码，则返回这支股票的所有日涨跌信息，返回的json形式为`Array<Dictionary<String: String>>`

###daily recommendation
~~~swift
http://118.89.59.190:8088/query/dailyRecommendation[?][rank=<string>&][date=<string>][count=<int>]
~~~


* 若不指定日期和排名，则返回所有推荐，用于分析和统计推荐过的股票相关信息，或者所预测出来的股票收益率等等
	* 返回的json形式为`Array<Dictionary<String: String>>`
* 若指定排名，不指定日期，默认返回当天推荐股票，与指定date为当日效果一致
	* 返回的json形式为`Array<Dictionary<String: String>>`

* 若指定排名和日期，则返回某一日特定排名的股票；当date=all时，返回从开始推荐时期至今特定排名的股票集合。
	* date=all, 返回的json形式为`Array<Dictionary<String: String>>`
	* date≠all, 返回的json形式为`Dictionary<String: String>`

* 相应的，若只指定日期，则返回特定日期的全部推荐。
   * 返回的json形式为`Array<Dictionary<String: String>>`

* **count: 指定返回推荐股票的个数，默认值为50**

###daily recommendation code
~~~swift
http://118.89.59.190:8088/query/dailyRecommendationCode
~~~

返回的json形式为`Array<String>`

解释：这是获得每日推荐股票代码的一个api，目的是避免在排名table list页面上接收过多冗余信息而造成的流量浪费和时间浪费。

>事实上，在现实每日推荐的table list页面上，并不需要详细的分析结果，在服务器上这是指向一个json文件，该文件只会存入当天推荐的股票代码并按排名排序，并且在每日产生新的推荐股票代码时都会覆盖之。


###daily blocks
`http://118.89.59.190:8088/query/dailyBlocks[?][date=<string>][&blockID=<string>]`



## Resource API

###stock info
内容详情参见Stockphet数据库表中**股票基本信息表**

~~~swift
http://118.89.59.190:8088/resource/stockInfo
~~~

###stock code
返回存在的股票代码

~~~swift
http://118.89.59.190:8088/resource/stockCode
~~~



