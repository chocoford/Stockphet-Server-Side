import requests
import re
import json
import time
from scrapy.selector import Selector
from requests import RequestException
from selenium.common.exceptions import TimeoutException

def extract_date(s):
    '''匹配字符串s中的日期，返回xxxx-xx-xx格式的日期'''
    m = re.search(r'(\d{4})[-/年](\d{1,2})[-/月](\d{1,2})日?', s)
    return None if m is None else '-'.join(m.groups())

headers = {
    "Content-Type": "application/json"
}
stock_headers = {
            'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                          '537.36(KHTML, likeGecko)Chrome/'
                          '65.0.3325.146Safari/537.36 ',
}
today = time.strftime("%Y-%m-%d", time.localtime())
di_code = ['sh000001', 'sz399001']
i = 0
while i < len(di_code):
    di_info = {}
    di_info['di_id'] = di_code[i][:2]
    try:
        html = requests.get('https://gupiao.baidu.com/stock/'+di_code[i]+'.html', headers=stock_headers, timeout=20)
        html.encoding = html.apparent_encoding
        r = Selector(text=html.text)
    except (RequestException, TimeoutException) as e:
        continue
    else:
        try:
            d = r.xpath('//*[@id="app-wrap"]/div[2]/div/h1/span/text()').extract()[0]
            di_info['di_date'] = extract_date(d)
            di_info['di_cprice'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/strong/text()').extract()[0]
            di_info['di_hprice'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[1]/dd/text()').extract()[0]
            di_info['di_lprice'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[2]/dd/text()').extract()[0]
            di_info['di_oprice'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[3]/dd/text()').extract()[0]
            di_info['di_transaction_vol'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[5]/dd/text()').extract()[0]
            di_info['di_turnover_vol'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[6]/dd/text()').extract()[0]
            di_info['di_rise_num'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[7]/dd/text()').extract()[0]
            di_info['di_fall_num'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[8]/dd/text()').extract()[0]
            di_info['di_parity_num'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[9]/dd/text()').extract()[0]
        except IndexError:
            continue
        else:
#            if di_info['di_date'] == today:
            response = requests.post('http://localhost:8088/insert_di', headers=headers, data=json.dumps(di_info))
            print(di_info)
#            else:
#                print("已休市")
            i += 1
