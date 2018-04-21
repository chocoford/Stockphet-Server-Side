# 股票信息爬取

import requests
from bs4 import BeautifulSoup
import re
import json


headers = {
            'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                          '537.36(KHTML, likeGecko)Chrome/'
                          '65.0.3325.146Safari/537.36 '
        }

def getHTMLText(url):
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()
        print(r.status_code)
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return ""


def getStockList(lis, stockURL):
    l_html = getHTMLText(stockURL)
    soup = BeautifulSoup(l_html, "html.parser")
    a = soup.find_all("a")
    for i in a:
        try:
            href = i.attrs['href']
            lis.append(re.findall(r"[s][hz][0|6]\d{5}", href)[0])
        except:
            continue

def getStockCode(stock):
    try:
        html = requests.get('http://stockpage.10jqka.com.cn/' + stock[2:] + '/', headers=headers)
        html.raise_for_status()
        # print(html.status_code)
        html.encoding = html.apparent_encoding
        soup = BeautifulSoup(html.text, "html.parser")
        if_over = soup.find_all('strong')
        k = 0
        for i in if_over:
            k += 1
        print(k)
        if k > 2:
            stock_true.append(stock)
            return True
        else:
            return True
    except:
        return False

if __name__ == '__main__':
    list_url = "http://quote.eastmoney.com/stocklist.html"
    path = "../gupiaodata.txt"
    slist = []
    getStockList(slist, list_url)
    print(slist)
    print(len(slist))
    stock_true = []
    i = 0
    while i < len(slist):
        if_success = getStockCode(slist[i])
        print(if_success)
        if if_success is True:
            i += 1
    file = open('stock_code.json', 'w', encoding='utf-16')
    json.dump(slist, file, ensure_ascii=False, indent=4)
