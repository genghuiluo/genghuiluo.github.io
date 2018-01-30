---
layout: post
title: utilize python(bs4) to capture data of live sites
date: 2018-01-28 12:40:31 +0800
categories: python
---

> 这里以windows平台为例, 脚本依赖python3 & mysql 

### 1. 安装python3 & pip

> [Installing Python 3 on Windows 7](http://www.openbookproject.net/courses/webappdev/units/softwaredesign/resources/install_python_win7.html)

1. [下载安装包](https://www.python.org/downloads/windows/)
    ```
    Python 3.5.4 - 2017-08-08

    32位 Download Windows x86 executable installer
    64位 Download Windows x86-64 executable installer
    ```
2. 双击python-x.x.x.exe安装
    ![]({{ site.url }}/assets/install_python3_windwos.png)

### 2. 安装mysql

> [Installing MySQL on Microsoft Windows](https://dev.mysql.com/doc/refman/5.7/en/windows-installation.html)

1. [下载安装包](https://dev.mysql.com/downloads/installer/), `mysql-installer-community-5.7.19.0.msi`
2. 双击mysql-install-community-5.7.19.10.msi安装
    - 依赖.net framework 4, 如果缺失, 预先[下载安装](https://www.microsoft.com/en-US/Download/confirmation.aspx?id=17718)
    - [microsoft visual c++ 2013 runtime 64 bits is not installed]()

3. 设置root密码为1234
4. 开始 -> 打开MySQL 5.7 command line client, 创建数据库feed, 和三张数据表
    ``` sql
    CREATE DATABASE feed;

    USE feed;

    CREATE TABLE site_categories (
    id int not null,
    site enum('zhanqi','douyu','huya','panda','huomao') not null,
    category_name varchar(100) character set utf8 not null,
    url varchar(200) not null,
    capture_time datetime,
    primary key(id,site));

    CREATE TABLE live_status (
    seq int not null auto_increment,
    live_name varchar(200) character set utf8 not null,
    live_host varchar(200) character set utf8 not null,
    view_raw_cnt varchar(50) character set utf8 not null,
    viewer_cnt int,
    site_category_id int not null,
    site enum('zhanqi','douyu','huya','panda','huomao') not null,
    capture_time datetime,
    primary key(seq),
    foreign key(site_category_id,site) references site_categories(id,site)
    );

    CREATE TABLE live_status_hist (
    seq int not null auto_increment,
    live_name varchar(200) character set utf8 not null,
    live_host varchar(200) character set utf8 not null,
    view_raw_cnt varchar(50) character set utf8 not null,
    viewer_cnt int,
    site_category_id int not null,
    site enum('zhanqi','douyu','huya','panda','huomao') not null,
    capture_time datetime,
    primary key(seq)
    );
    ```

### 3. 测试脚本

1. 下面两个文件放置到用户目录下`e.g. C:\Users\xxx\`(cmd default path, while you can also put anywhere)
2. 打开cmd (win + R, input 'cmd', enter)
    ```
    > pip install -r requirements.txt
    
    > python3 live_stats.py douyu
    ```

requirements.txt
```
beautifulsoup4==4.4.1
PyMySQL==0.7.9
requests==2.13.0
lxml==3.7.3
```

live_stats.py
``` python
import requests
from bs4 import BeautifulSoup
import pymysql
import sys
import os
import json
import time

site_categories = {
                'douyu': 'https://www.douyu.com/directory',
                'panda': 'http://www.panda.tv/cate',
                'huya': 'http://www.huya.com/g',
                'huomao': 'https://www.huomao.com/game',
                'zhanqi': 'https://www.zhanqi.tv/games'
                }

def download_html(url):
    response = requests.get(url, headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36'
        })
    '''
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    '''
    response.encoding = 'utf-8'
    return response.text

def gen_category(site):
    html = download_html(site_categories[site])
    soup = BeautifulSoup(html,'lxml')
    sql = "DELETE FROM live_status WHERE site='%s';DELETE FROM site_categories WHERE site='%s';" % (site,site)
    # delete live_status first, foreign key reference
    query(sql)
    # sys.exit()
    cate_id = 1

    if site == 'zhanqi':
        '''
        <ul class="clearfix" id="game-list-panel">
            <li>
                <a href="/games/xindong">
                <div class="img-box">
                    <img src="https://img2.zhanqi.tv/uploads/2016/09/gamespic-2016092818163772754.jpeg" alt="百变娱乐">
                </div>
                <p class="name">百变娱乐</p>
                </a>
            </li>
        '''
        game_list = soup.find('ul',attrs={'id':'game-list-panel'}).find_all('li')
        for game in game_list:
            category_name = game.find('p',attrs={'class':'name'}).text
            url = 'https://www.zhanqi.tv' + game.find('a')['href']
            #print(category_name,url)
            sql="INSERT INTO site_categories(id,site,category_name,url,capture_time) \
                VALUES (%d, '%s', '%s', '%s', now());" % \
                (cate_id, site , category_name, url)
            query(sql)
            live_status(cate_id,url)
            cate_id+=1
    elif site == 'huya':
        '''
        <ul class="game-list clearfix" id="js-game-list">
            <li class="game-list-item">
                <a target="_blank" href="http://www.huya.com/g/lol" class="pic new-clickstat" report='{"eid":"click/postion","position":"gameList/gameCard/1","game_id":"1"}'>
                    <img class="pic-img" data-original="http://huyaimg.dwstatic.com/cdnimage/game/1-S.jpg?t=1491447600" src="http://assets.dwstatic.com/amkit/p/duya/common/img/default_game_pc.jpg" alt="英雄联盟" title="英雄联盟" onerror="this.onerror='';this.src='http://assets.dwstatic.com/amkit/p/duya/common/img/default_game_pc.jpg'">
                    <p class="title">英雄联盟</p>
                </a>
            </li>
        '''
        game_list = soup.find('ul',attrs={'id':'js-game-list'}).find_all('li')
        for game in game_list:
            category_name = game.find('p',attrs={'class':'title'}).text
            url = game.find('a')['href']
            #print(category_name,url)
            sql="INSERT INTO site_categories(id,site,category_name,url,capture_time) \
                VALUES (%d, '%s', '%s', '%s', now());" % \
                (cate_id, site , category_name, url)
            query(sql)
            live_status(cate_id,url)
            cate_id+=1
    elif site == 'douyu':
        game_list = soup.find('ul',attrs={'id':'live-list-contentbox'}).find_all('li')
        for game in game_list:
            category_name = game.find('p',attrs={'class':'title'}).text
            url = 'https://www.douyu.com' + game.find('a')['href']
            # print(category_name,url)
            sql="INSERT INTO site_categories(id,site,category_name,url,capture_time) \
                VALUES (%d, '%s', '%s', '%s', now());" % \
                (cate_id, site , category_name, url)
            query(sql)
            live_status(cate_id,url)
            cate_id+=1
    elif site == 'panda':
        game_list = soup.find('ul',attrs={'class':'video-list'}).find_all('li')
        for game in game_list:
            category_name = game.find('div',attrs={'class':'cate-title'}).get_text().strip()
            url = game.find('a')['href']
            if 'http' not in url: # jump one page(e.g. http://daweiwang.pgc.panda.tv/) category
                #print(category_name,url)
                url = 'http://www.panda.tv' + url
                sql="INSERT INTO site_categories(id,site,category_name,url,capture_time) \
                    VALUES (%d, '%s', '%s', '%s', now());" % \
                    (cate_id, site , category_name, url)
                query(sql)
                live_status(cate_id,url)
                cate_id+=1
    elif site == 'huomao':
        game_list = soup.find('div',attrs={'id':'gamelist'}).find_all('div',attrs={'class':'game-smallbox'})
        for game in game_list:
            category_name = game.find('p').get_text().strip()
            url = game.find('a')['href']
            #print(category_name,url)
            sql="INSERT INTO site_categories(id,site,category_name,url,capture_time) \
                VALUES (%d, '%s', '%s', '%s', now());" % \
                (cate_id, site , category_name, url)
            query(sql)
            live_status(cate_id,url)
            cate_id+=1

def live_status(cate_id,url):
    #time.sleep(1)
    if 'huomao' in url:
    # huomao use ajax load live list
    # https://www.huomao.com/channels/channel.json?page=1&page_size=120&game_url_rule=dota2&cache_time=1491544806
        game_url_rule = url.rsplit('/', 1)[-1]
        cache_time = timestamp = int(time.time())

        if 'collectionid' in game_url_rule:
            '''
            <div id="game_label" >
            <li><a href="javascript:void(0);" onclick="changeRoom('byte10a53_51_29');" id="byte10a53_51_29" class="all-room">全部</a></li>
            '''
            html = download_html(url)
            soup = BeautifulSoup(html,'lxml')
            game_url_rule = soup.find('div',attrs={'id':'game_label'}).find('a',attrs={'class':'all-room'})['id']

        #print(game_url_rule,cache_time)
        channel_json = download_html("https://www.huomao.com/channels/channel.json?page=1&page_size=120&game_url_rule=%s&cache_time=%s" % (game_url_rule, cache_time))
        channel_dict = json.loads(channel_json)
        for room in channel_dict['data']['channelList']:
            if room['is_live'] == '1':
                #print(room['username'],room['channel'],room['views'])
                live_name = room['channel']
                live_host = room['username']
                view_raw_cnt = room['views']
                ins_live_satus(live_name, live_host , view_raw_cnt, cate_id, 'huomao')

    else:
        html = download_html(url)
        soup = BeautifulSoup(html,'lxml')

        try:
            if 'zhanqi' in url:
                '''
                # live_room_list = soup.find('ul',attrs={'class':'js-room-list-ul'})
                zhanqi change the way to load game room list
                <div class="live-list-tabc tabc js-room-list-tabc active" data-type="all" data-size="30" data-url="/api/static/v2.1/game/live/10/${size}/${page}.json" data-cur-page="0">
                https://www.zhanqi.tv/api/static/v2.1/game/live/10/30/1.json
                '''
                live_room_div = soup.find('div',attrs={'class':'js-room-list-tabc'})
                #print('https://www.zhanqi.tv' + live_room_div['data-url'].rsplit('/',2)[0] + '/' + live_room_div['data-size'])
                if live_room_div is not None:
                    live_room_url = 'https://www.zhanqi.tv' + live_room_div['data-url'].rsplit('/',2)[0] + '/' + live_room_div['data-size'] + '/1.json' # only first page
                    live_room_json = download_html(live_room_url)
                    #print(live_room_json)
                    live_room_dict = json.loads(live_room_json)
                    for room in live_room_dict['data']['rooms']:
                        live_name = room['title']
                        live_host = room['nickname']
                        view_raw_cnt = room['online']
                        ins_live_satus(live_name, live_host , view_raw_cnt, cate_id, 'zhanqi')
                        #print(live_name, live_host , view_raw_cnt, cate_id, 'zhanqi')
            elif 'huya' in url:
                live_rooms = soup.find('ul',attrs={'class':'live-list'}).find_all('li')
                for room in live_rooms:
                    live_name = room.find('a',attrs={'class':'title'}).text
                    live_host = room.find('i',attrs={'class':'nick'}).text
                    view_raw_cnt = room.find('i',attrs={'class':'js-num'}).text
                    #print(live_name,live_host,view_raw_cnt)
                    ins_live_satus(live_name, live_host , view_raw_cnt, cate_id, 'huya')
            elif 'douyu' in url:
                live_rooms = soup.find('ul',attrs={'id':'live-list-contentbox'}).find_all('li')
                for room in live_rooms:
                    live_name = room.find('h3',attrs={'class':'ellipsis'}).text.strip()
                    live_host = room.find('span',attrs={'class':'dy-name'}).text
                    view_raw_cnt = room.find('span',attrs={'class':'dy-num'}).text
                    #print(live_name,live_host,view_raw_cnt)
                    ins_live_satus(live_name, live_host , view_raw_cnt, cate_id, 'douyu')
            elif 'panda' in url:
                live_rooms = soup.find('ul',attrs={'class':'video-list'}).find_all('li')
                for room in live_rooms:
                    live_name = room.find('span',attrs={'class':'video-title'}).text.strip()
                    live_host_item = room.find('span',attrs={'class':'video-nickname'})
                    if live_host_item is None:
                        live_host_item = room.find('span',attrs={'class':'userinfo-nickname'})
                    live_host = live_host_item.text
                    view_raw_cnt = room.find('span',attrs={'class':'video-number'}).text
                    #print(live_name,live_host,view_raw_cnt)
                    ins_live_satus(live_name, live_host , view_raw_cnt, cate_id, 'panda')

        except AttributeError as ex:
            print("ERROR: can't capture live status", url)
            print(ex)
            #print(html)


def ins_live_satus(live_name,live_host,view_raw_cnt,cate_id,site):
    sql="INSERT INTO live_status(live_name,live_host,view_raw_cnt,site_category_id,site,capture_time) \
        VALUES ('%s', '%s', '%s', %d,'%s', now());" % \
        (live_name.replace("'",'"').replace('\\',''), live_host.replace("'",'"').replace('\\','') , view_raw_cnt, cate_id, site)
    query(sql)

def query(sql):
    try:
        cursor.execute(sql)
        localdb.commit()
    except pymysql.Error as e:
        print ("MySQL Error [%d]: %s" % (e.args[0], e.args[1]))
        print (sql)
        localdb.rollback()

localdb=pymysql.connect('localhost','root','1234','feed',charset='utf8')
cursor=localdb.cursor()

#gen_category('zhanqi')
#gen_category('huya')
#gen_category('douyu')
#gen_category('panda')
#gen_category('huomao')

if len(sys.argv) != 2:
    sys.exit("ERROR: python3 " + sys.argv[0] + " [ all | zhanqi | huya | huomao | douyu | panda ]")
else:
    if sys.argv[1] == 'all':
        for k in site_categories.keys():
            print("INFO: capturing %s" % k)
            gen_category(k)
    else:
        if sys.argv[1] in site_categories.keys():
            print("INFO: capturing %s" % sys.argv[1])
            gen_category(sys.argv[1])
        else:
            sys.exit("ERROR: " + sys.argv[1] + " is not valid platform")

    # log history
    sql = "INSERT INTO live_status_hist SELECT * FROM live_status;"
    query(sql)
```
