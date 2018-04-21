# 每天爬取一次每只股票的分时图

from selenium import webdriver
import time
import json
import requests
from scrapy.selector import Selector
from requests import RequestException
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support import expected_conditions as EC
import re
from PIL import Image
import threading


def extract_date(s):
    '''匹配字符串s中的日期，返回xxxx-xx-xx格式的日期'''
    m = re.search(r'(\d{4})[-/年](\d{1,2})[-/月](\d{1,2})日?', s)
    return None if m is None else '-'.join(m.groups())


stock_error = []
stock_not_exist = []
stock_id_array = []
driver = webdriver.PhantomJS(executable_path='C:\python\phantomjs-2.1.1-windows\phantomjs.exe',
                             service_args=['--ignore-ssl-errors=true', '--ssl-protocol=TLSv1'])
stock_headers = {
    'User-Agent': 'Mozilla/5.0(Windows NT 6.2; WOW64) AppleWebKit/'
                  '537.36(KHTML, likeGecko)Chrome/'
                  '65.0.3325.146Safari/537.36 ',
}
driver.set_page_load_timeout(10)
driver.set_script_timeout(10)
if_black = Image.open('if_black.png')
if_white_blue1 = Image.open('if_white_blue1.png')
if_white_blue2 = Image.open('if_white_blue2.png')
file = open('stock_code.json', 'r', encoding='utf-16')
stock = json.load(file)


def if_stop(stock_id, a):
    while (1):
        try:
            html = requests.get('https://gupiao.baidu.com/stock/' + stock_id + '.html', headers=stock_headers,
                                timeout=20)
            html.encoding = html.apparent_encoding
            r = Selector(text=html.text)
        except (RequestException, TimeoutException) as e:
            continue
        else:
            try:
                situation = r.xpath('//*[@id="app-wrap"]/div[2]/div/h1/span/text()').extract()[0]
            except IndexError:
                continue
            else:
                if a == 2:
                    stop = situation[:2]
                    break
                elif a == 3:
                    stop = situation[:3]
                    break
    return stop


def get_stock_image(stock_id):
    try:
        driver.get('https://gupiao.baidu.com/stock/' + stock_id + '.html')
    except:
        print(stock_id + 'timeout')
        return 'error'
    else:
        driver.execute_script("""
        (function () {
        var y = 0;
        var step = 100;
        window.scroll(0, 0);
        function f() {
        if (y < document.body.scrollHeight) {
        y += step;
        window.scroll(0, y);
        setTimeout(f, 50);
        } else {
        window.scroll(0, 0);
        document.title += "scroll-done";
        }
        }setTimeout(f, 1000);
        })();
        """)
        for i in range(30):
            if "scroll-done" in driver.title:
                break
        time.sleep(2)
        try:
            element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.ID, "d-chart")))
        except:
            return 'error'
        try:
            situation = driver.find_element_by_xpath('//*[@id="app-wrap"]/div[2]/div/h1/span').text
        except:
            try:
                driver.find_element_by_xpath('/html/body/div[2]/div/h2')
            except NoSuchElementException:
                return 'error'
            else:
                print(stock_id + '404')
                return 'error_404'
        else:
            if situation[:3] == '已退市' or situation[:3] == '未上市':
                if situation[:3] == if_stop(stock_id, 3):
                    print(stock_id + situation[:3])
                    if stock_id in stock_error:
                        stock_error.remove(stock_id)
                    return 'error_404'
                else:
                    return 'error'
            if situation[:2] != if_stop(stock_id, 2):
                return 'error'
            print(stock_id + situation[:2])
            date = extract_date(situation)
            driver.save_screenshot('../../Public/daily_stock_img/' + stock_id[2:] + '_' + date + '.png')
            try:
                p = driver.find_element_by_id('d-chart')
                left = p.location['x']
                top = p.location['y']
                elementWidth = p.location['x'] + p.size['width']
                elementHeight = p.location['y'] + p.size['height']
                picture = Image.open('../../Public/daily_stock_img/' + stock_id[2:] + '_' + date + '.png')
                picture = picture.crop((left, top, elementWidth, elementHeight))
                picture = picture.crop((88, 5, 520, 230))
                picture.save('../../Public/daily_stock_img/' + stock_id[2:] + '_' + date + '.png')
                image = Image.open('../../Public/daily_stock_img/' + stock_id[2:] + '_' + date + '.png')
            except:
                return 'error'
            else:
                for i in range(3):
                    if if_black == image:
                        print(stock_id + 'black_same')
                        stop = 'error'
                        break
                    elif if_white_blue1 == image and situation[:2] != '停牌':
                        print(stock_id + 'white_blue_same')
                        stop = 'error'
                        break
                    elif if_white_blue2 == image and situation[:2] != '停牌':
                        print(stock_id + 'white_blue_same')
                        stop = 'error'
                        break
                    else:
                        if image == if_white_blue1 and situation[:2] != '停牌':
                            print(stock_id + 'white_blue_same')
                            stop = 'error'
                            break
                        else:
                            image.save('../../Public/daily_stock_img/' + stock_id[2:] + '_' + date + '.png')
                            print(stock_id + 'success')
                            time.sleep(1)
                            stop = 'true'
                return stop


def get_true_image(stock, a, b):
    print('start_thread:' + str(a))
    i = a
    while i < b:
        if_success = get_stock_image(stock[i])
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
        if_success = get_stock_image(stock_error[i])
        if if_success == 'error':
            continue
        elif if_success == 'error_404':
            stock_not_exist.append(stock_error[i])
            i += 1
        elif if_success == 'true':
            stock_id_array.append(stock_error[i])
            i += 1
    print(len(stock_not_exist) + len(stock_id_array))


threads = []
t1 = threading.Thread(target=get_true_image, args=(stock, 0, 400))
threads.append(t1)
t2 = threading.Thread(target=get_true_image, args=(stock, 400, 800))
threads.append(t2)
t3 = threading.Thread(target=get_true_image, args=(stock, 800, 1200))
threads.append(t3)
t4 = threading.Thread(target=get_true_image, args=(stock, 1200, 1600))
threads.append(t4)
t5 = threading.Thread(target=get_true_image, args=(stock, 1600, 2000))
threads.append(t5)
t6 = threading.Thread(target=get_true_image, args=(stock, 2000, 2400))
threads.append(t6)
t7 = threading.Thread(target=get_true_image, args=(stock, 2400, len(stock)))
threads.append(t7)

if __name__ == '__main__':
    print(len(stock))
    start_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    print(start_time)
    print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
    driver.quit()
