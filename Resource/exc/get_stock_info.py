import requests
import json
from scrapy.selector import Selector
from requests import RequestException
from selenium.common.exceptions import TimeoutException
import re

stock_headers = {
    'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                  '537.36(KHTML, likeGecko)Chrome/'
                  '65.0.3325.146Safari/537.36 ',
}

stock_array = []
stock_error = []
stock_not_exist = []
stock_id_array = []


def get_stock(stock_id):
    try:
        html = requests.get('http://quote.eastmoney.com/' + stock_id + '.html', headers=stock_headers, timeout=20)
    except (RequestException, TimeoutException) as e:
        return 'error'
    else:
        html.encoding = html.apparent_encoding
        r = Selector(text=html.text)
        stock_info = {}
        stock_info['s_code'] = stock_id[2:]
        block = r.xpath('//span[@class="sin"]/a/text()').extract()
        if len(block) == 0:
            block = r.xpath('//td[@class="tit"]/a/text()').extract()
        b = ''
        for j in block:
            b = b + j
        stock_info['s_block'] = b
        try:
            html = requests.get('http://finance.sina.com.cn/realstock/company/'
                                + stock_id + '/nc.shtml', headers=stock_headers, timeout=20)
        except (RequestException, TimeoutException) as e:
            print(1)
            return 'error'
        else:
            html.encoding = html.apparent_encoding
            r = Selector(text=html.text)
            try:
                stock_info['s_name'] = r.xpath('//h1[@id="stockName"]/text()').extract()[0]
                stock_info['s_com'] = r.xpath('//div[@class="com_overview blue_d"]/p[2]/text()').extract()[0]
                intr = r.xpath('//div[@class="com_overview blue_d"]/p[4]/@title').extract()
                if len(intr) == 0:
                    intro = r.xpath('//div[@class="com_overview blue_d"]/p[4]/text()').extract()[0]
                else:
                    intro = intr[0]
                stock_info['s_main_business'] = re.sub(' ', '', intro)
                stock_info['s_establish_date'] = r.xpath('//div[@class="com_overview blue_d"]/p[7]/text()').extract()[0]
                stock_info['s_listed_date'] = r.xpath('//div[@class="com_overview blue_d"]/p[8]/text()').extract()[0]
                stock_info['s_registered_capital'] = \
                    r.xpath('//div[@class="com_overview blue_d"]/p[11]/text()').extract()[0]
                stock_info['s_eps_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[1]/td[1]/text()').extract()[0]
                stock_info['s_eps_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[1]/td[2]/text()').extract()[0]
                stock_info['s_eps_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[1]/td[3]/text()').extract()[0]
                stock_info['s_eps_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[1]/td[4]/text()').extract()[0]
                stock_info['s_eps_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[1]/td[5]/text()').extract()[0]
                stock_info['s_navps_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[2]/td[1]/text()').extract()[0]
                stock_info['s_navps_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[2]/td[2]/text()').extract()[0]
                stock_info['s_navps_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[2]/td[3]/text()').extract()[0]
                stock_info['s_navps_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[2]/td[4]/text()').extract()[0]
                stock_info['s_navps_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[2]/td[5]/text()').extract()[0]
                stock_info['s_ncfps_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[3]/td[1]/text()').extract()[0]
                stock_info['s_ncfps_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[3]/td[2]/text()').extract()[0]
                stock_info['s_ncfps_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[3]/td[3]/text()').extract()[0]
                stock_info['s_ncfps_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[3]/td[4]/text()').extract()[0]
                stock_info['s_ncfps_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[3]/td[5]/text()').extract()[0]
                stock_info['s_roe_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[4]/td[1]/text()').extract()[0]
                stock_info['s_roe_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[4]/td[2]/text()').extract()[0]
                stock_info['s_roe_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[4]/td[3]/text()').extract()[0]
                stock_info['s_roe_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[4]/td[4]/text()').extract()[0]
                stock_info['s_roe_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[4]/td[5]/text()').extract()[0]
                stock_info['s_upps_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[5]/td[1]/text()').extract()[0]
                stock_info['s_upps_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[5]/td[2]/text()').extract()[0]
                stock_info['s_upps_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[5]/td[3]/text()').extract()[0]
                stock_info['s_upps_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[5]/td[4]/text()').extract()[0]
                stock_info['s_upps_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[5]/td[5]/text()').extract()[0]
                stock_info['s_crps_0'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[6]/td[1]/text()').extract()[0]
                stock_info['s_crps_1'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[6]/td[2]/text()').extract()[0]
                stock_info['s_crps_2'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[6]/td[3]/text()').extract()[0]
                stock_info['s_crps_3'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[6]/td[4]/text()').extract()[0]
                stock_info['s_crps_4'] = \
                    r.xpath('//*[@id="finance_overview"]/div/div[2]/table/tbody/tr[6]/td[5]/text()').extract()[0]
            except IndexError:
                print(2)
                return 'error_404'
            else:
                print(stock_info)
                stock_array.append(stock_info)
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
    file_stock = open('../stock_info.json', 'w', encoding='utf-8')
    json.dump(stock_array, file_stock, ensure_ascii=False, indent=4)
