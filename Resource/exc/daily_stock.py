import requests
import re
from scrapy.selector import Selector
import json
import time
from requests import RequestException
from selenium.common.exceptions import TimeoutException


def extract_date(s):
    '''匹配字符串s中的日期，返回xxxx-xx-xx格式的日期'''
    m = re.search(r'(\d{4})[-/年](\d{1,2})[-/月](\d{1,2})日?', s)
    return None if m is None else '-'.join(m.groups())


start_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
today = time.strftime("%Y-%m-%d", time.localtime())

global a
global b
global isAvailable
stock_array = []
stock_error = []
stock_not_exist = []
stock_id_array = []
headers = {
    "Content-Type": "application/json"
}
stock_headers = {
    'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                  '537.36(KHTML, likeGecko)Chrome/'
                  '65.0.3325.146Safari/537.36 ',
}


def get_stock(stock_id):
    try:
        html = requests.get('https://gupiao.baidu.com/stock/' + stock_id + '.html', headers=stock_headers, timeout=20)
    except (RequestException, TimeoutException) as e:
        return 'error'
    else:
        html.encoding = html.apparent_encoding
        r = Selector(text=html.text)
        isAvailable = True
        stock = {}
        # 404
        if len(r.xpath('/html/body/div[2]/div/h2/text()').extract()) != 0:
            return 'error'
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/h1/span/text()').extract()[0]
        except IndexError:
            return 'error'
        else:
            a = str(content).strip()
        b = str(a[:3])
        if b == "已退市":
            print("已退市")
            if stock_id in stock_error:
                stock_error.remove(stock_id)
            return 'error_404'
        elif b == "未上市":
            print("未上市")
            if stock_id in stock_error:
                stock_error.remove(stock_id)
            return 'error_404'
        # 股票日期
        a = extract_date(a)
        if a == today:
            stock['ds_date'] = a
        else:
            print("已休市或停牌")
            return 'error_404'
        # 股票名称
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/h1/a/text()').extract_first()
        except IndexError:
            return 'error'
        if content is None:
            return 'error'
        a = str(content).strip()
        l = len(a)
        a = a[0:(l - 2)]
        stock['ds_name'] = a
        # 股票代码
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/h1/a/span/text()').extract()[0]
        except IndexError:
            return 'error'
        a = str(content).strip()
        stock['ds_code'] = a
        # 今收
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/strong/text()').extract()[0]
        except IndexError:
            return 'error'
        a = str(content).strip()
        if a == 'None':
            isAvailable = False
            return 'error'
        stock['ds_cprice'] = a
        # 涨跌额
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/span[1]/text()').extract()[0]
        except IndexError:
            return 'error'
        a = str(content).strip()
        stock['ds_change_amount'] = a
        # 涨跌幅
        try:
            content = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[1]/span[2]/text()').extract()[0]
        except IndexError:
            return 'error'
        a = str(content).strip()
        l = len(a)
        stock['ds_change'] = a[:l - 1]
        for i in range(1, 3):
            for j in range(1, 12):
                try:
                    content = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[' +
                                      str(i) + ']/dl[' + str(j) + ']/dt/text()').extract()[0]
                except IndexError:
                    return 'error'
                a = str(content).strip()
                try:
                    content = r.xpath('//*[@id="app-wrap"]/div[2]/div/div[2]/div[' +
                                      str(i) + ']/dl[' + str(j) + ']/dd/text()').extract()[0]
                except IndexError:
                    return 'error'
                b = str(content).strip()
                b = re.sub('\n', '', b)
                b = re.sub(' ', '', b)
                if a == '今开':
                    stock['ds_oprice'] = b
                elif a == '最高':
                    stock['ds_hprice'] = b
                elif a == '最低':
                    stock['ds_lprice'] = b
                elif a == '昨收':
                    stock['ds_fprice'] = b
                elif a == '委比':
                    stock['ds_committee'] = b
                elif a == '量比':
                    stock['ds_quantity_ratio'] = b
                elif a == '换手率':
                    stock['ds_turnover_rate'] = b
                elif a == '成交量':
                    stock['ds_turnover_vol'] = b
                elif a == '成交额':
                    stock['ds_transaction_vol'] = b
                elif a == '每股净资产':
                    stock['ds_net_assets_per_share'] = b
                elif a == '市盈率':
                    stock['ds_pe_rate'] = b
                elif a == '市净率':
                    stock['ds_pb_rate'] = b
                elif a == '每股收益':
                    stock['ds_eps'] = b
                elif a == '总市值':
                    stock['ds_total_value'] = b
                elif a == '流通市值':
                    stock['ds_currency_value'] = b
        count = 0
        for key in stock.keys():
            count += 1
        if isAvailable:
            if count > 5:
                stock_array.append(stock)
                response = requests.post('http://localhost:8088/insert_ds', headers=headers,
                                         data=json.dumps(stock))
                print(stock)
                return 'true'


if __name__ == '__main__':
    file = open('../stock_code.json', 'r', encoding='utf-16')
    stock = json.load(file)
    print(len(stock))
    i = 0
    while i < len(stock):
        if_success = get_stock(stock[i])
        if if_success == 'error':
            if stock[i] not in stock_error:
                stock_error.append(stock[i])
        elif if_success == 'error_404':
            stock_not_exist.append(stock[i])
            i += 1
        elif if_success == 'true':
            if stock[i] in stock_error:
                stock_error.remove(stock[i])
            stock_id_array.append(stock[i])
            i += 1
    i = 0
    while i < len(stock_error):
        if_success = get_stock(stock_error[i])
        if if_success == 'error':
            continue
        elif if_success == 'error_404':
            stock_not_exist.append(stock_error[i])
            i += 1
        elif if_success == 'true':
            stock_id_array.append(stock_error[i])
            i += 1
    print(len(stock_not_exist) + len(stock_id_array))
    print(start_time)
    print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
