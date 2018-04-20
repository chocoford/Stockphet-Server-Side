<h1 id="toc_0">Stockphet Server Side API</h1>

<p><em>&lt;&gt;代表参数类型，[]表示可选参数，</em></p>

<h2 id="toc_1">入库API</h2>

<p>daily_stock</p>

<div><pre><code class="language-swift">http://localhost:8088/insert_ds</code></pre></div>

<p>daily_index</p>

<div><pre><code class="language-swift">http://localhost:8088/insert_di</code></pre></div>

<p>daily_block</p>

<div><pre><code class="language-swift">http://localhost:8088/insert_db</code></pre></div>

<p><strong><em>前提：必须在与服务器主机一致的host才能生效</em></strong></p>

<p><em>其中date精确到日期即可，注意需要用post的方式将要入库的数据以json形式上传到后端制定路由</em></p>

<h2 id="toc_2">Query API</h2>

<h3 id="toc_3">daily stock</h3>

<div><pre><code class="language-swift">http://118.89.59.190:8088/query/dailyStocks?[code=&lt;string&gt;&amp;][name=&lt;string&gt;&amp;]date=&lt;string&gt;</code></pre></div>

<p><em>注：日期为必填参数</em></p>

<ul>
<li>若指定了特定股票和特定日期，返回json形式为<code>Dictionary&lt;String: String&gt;</code></li>
<li>若没指定特定股票，返回的是指定日期的所有股票涨跌信息，返回json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
<li>若只指定特定股票代码，则返回这支股票的所有日涨跌信息，返回的json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
</ul>

<h3 id="toc_4">daily recommendation</h3>

<div><pre><code class="language-swift">http://118.89.59.190:8088/query/dailyRecommendation[?][rank=&lt;string&gt;&amp;][date=&lt;string&gt;][count=&lt;int&gt;]</code></pre></div>

<ul>
<li>若不指定日期和排名，则返回所有推荐，用于分析和统计推荐过的股票相关信息，或者所预测出来的股票收益率等等

<ul>
<li>返回的json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
</ul></li>
<li><p>若指定排名，不指定日期，默认返回当天推荐股票，与指定date为当日效果一致</p>

<ul>
<li>返回的json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
</ul></li>
<li><p>若指定排名和日期，则返回某一日特定排名的股票；当date=all时，返回从开始推荐时期至今特定排名的股票集合。</p>

<ul>
<li>date=all, 返回的json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
<li>date≠all, 返回的json形式为<code>Dictionary&lt;String: String&gt;</code></li>
</ul></li>
<li><p>相应的，若只指定日期，则返回特定日期的全部推荐。</p>

<ul>
<li>返回的json形式为<code>Array&lt;Dictionary&lt;String: String&gt;&gt;</code></li>
</ul></li>
<li><p><strong>count: 指定返回推荐股票的个数，默认值为50</strong></p></li>
</ul>

<h3 id="toc_5">daily recommendation code</h3>

<div><pre><code class="language-swift">http://118.89.59.190:8088/query/dailyRecommendationCode</code></pre></div>

<p>返回的json形式为<code>Array&lt;String&gt;</code></p>

<p>解释：这是获得每日推荐股票代码的一个api，目的是避免在排名table list页面上接收过多冗余信息而造成的流量浪费和时间浪费。</p>

<blockquote>
<p>事实上，在现实每日推荐的table list页面上，并不需要详细的分析结果，在服务器上这是指向一个json文件，该文件只会存入当天推荐的股票代码并按排名排序，并且在每日产生新的推荐股票代码时都会覆盖之。</p>
</blockquote>

<h3 id="toc_6">daily blocks</h3>

<p><code>http://118.89.59.190:8088/query/dailyBlocks[?][date=&lt;string&gt;][&amp;blockID=&lt;string&gt;]</code></p>

<h3 id="toc_7">current indexes</h3>

<p><code>http://118.89.59.190:8088/api/currentIndexes[/all][/latest][/sh][/sz]</code></p>

<p>其中， all和latest必填一项；sh和sz必填一项</p>

<p>若访问latest则返回一个<code>Doctionary&lt;String: Any&gt;</code> ，返回最新的沪深指数动态。<br>
若访问all则返回<code>Array&lt;Dictionary&lt;String: Any&gt;&gt;</code>，且返回的数据是所有的爬下来的</p>

<h2 id="toc_8">Resource API</h2>

<h3 id="toc_9">stock info</h3>

<p>内容详情参见Stockphet数据库表中<strong>股票基本信息表</strong></p>

<div><pre><code class="language-swift">http://118.89.59.190:8088/resource/stockInfo</code></pre></div>

<h3 id="toc_10">stock code</h3>

<p>返回存在的股票代码</p>

<div><pre><code class="language-swift">http://118.89.59.190:8088/resource/stockCode</code></pre></div>
