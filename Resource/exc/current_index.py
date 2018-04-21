# 在开盘期间每隔5秒爬取一次上证和深证指数


import requests
from scrapy.selector import Selector
from requests import RequestException
from selenium.common.exceptions import TimeoutException
import json
import time
import threading

headers = {
    "Content-Type": "application/json"
}
stock_headers = {
    'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                  '537.36(KHTML, likeGecko)Chrome/'
                  '65.0.3325.146Safari/537.36 ',
}

di_code = ['sh000001', 'sz399001']


def get_di_stock(h, m, s):
    i = 0
    while i < len(di_code):
        di_info = {}
#        di_info['identifier'] = di_code[i][:2]
        try:
            html = requests.get('https://gupiao.baidu.com/stock/' + di_code[i] + '.html', headers=stock_headers,
                                timeout=20)
            html.encoding = html.apparent_encoding
            r = Selector(text=html.text)
        except (RequestException, TimeoutException) as e:
            continue
        else:
            try:
                # 涨跌额
                di_info['change_amount'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/span[1]/text()').extract()[0]
                # 涨跌幅
                di_change = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/span[2]/text()').extract()[0]
                di_info['change'] = di_change[:-1]
                di_info['price'] = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/strong/text()').extract()[0]
                di_info['transaction_vol'] = \
                    r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[5]/dd/text()').extract()[0]
                di_info['turnover_vol'] = \
                    r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[6]/dd/text()').extract()[0]
                di_info['rise_num'] = \
                    int(r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[7]/dd/text()').extract()[0])
                di_info['fall_num'] = \
                    int(r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[8]/dd/text()').extract()[0])
                di_info['parity_num'] = \
                    int(r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[1]/dl[9]/dd/text()').extract()[0])
            except IndexError:
                continue
            else:
                di_info['time'] = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
                if di_code[i][:2] == 'sh':
                    response = requests.post('http://localhost:8088/create_ci/sh', headers=headers,
                                              data=json.dumps(di_info))
                    print(di_info)
                else:
                    response = requests.post('http://localhost:8088/create_ci/sz', headers=headers,
                                              data=json.dumps(di_info))
                    print(di_info)
                i += 1
    print("现在是" + h + "时" + m + "分" + s + "秒")


if __name__ == '__main__':
    while (True):
        hour = time.strftime("%H", time.localtime())
        minute = time.strftime("%M", time.localtime())
        second = time.strftime("%S", time.localtime())
        if int(hour) >= 15 or int(hour) < 9 or int(hour) == 12:
            print("现在是" + hour + "时" + minute + "分" + second + "秒，睡眠半小时")
            time.sleep(1800)
        elif int(hour) == 9 and int(minute) < 30 or int(hour) == 11 and int(minute) >= 30:
            print("现在是" + hour + "时" + minute + "分" + second + "秒，睡眠" + str(60 - int(second)) + "秒")
            time.sleep(60 - int(second))
        else:
            s = int(second) / 5
            T = s.is_integer()
            if T:
                thread = threading.Thread(target=get_di_stock, args=(hour, minute, second))
                thread.start()
                time.sleep(1)
                continue
            else:
                print("现在是" + hour + "时" + minute + "分" + second + "秒，睡眠" + str(5 - int(second) % 5) + "秒")
                time.sleep(5 - int(second) % 5)
                continue
