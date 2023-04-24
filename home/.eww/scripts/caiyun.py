#!/usr/bin/env python

import json
import requests
from datetime import datetime

import time

from pathlib import Path

# https://docs.caiyunapp.com/docs/tables/skycon
# 优先级：降雪 > 降雨 > 雾 > 沙尘 > 浮尘 > 雾霾 > 大风 > 阴 > 多云 > 晴

t = {'CLEAR_DAY': '晴（白天）',
     'CLEAR_NIGHT': '晴（夜间）',
     'PARTLY_CLOUDY_DAY': '多云（白天）',
     'PARTLY_CLOUDY_NIGHT': '多云（夜间）',
     'CLOUDY': '阴',
     'LIGHT_HAZE': '轻度雾霾',
     'MODERATE_HAZE': '中度雾霾',
     'HEAVY_HAZE': '重度雾霾',
     'LIGHT_RAIN': '小雨',
     'MODERATE_RAIN': '中雨',
     'HEAVY_RAIN': '大雨',
     'STORM_RAIN': '暴雨',
     'FOG': '雾',
     'LIGHT_SNOW': '小雪',
     'MODERATE_SNOW': '中雪',
     'HEAVY_SNOW': '大雪',
     'STORM_SNOW': '暴雪',
     'DUST': '浮尘',
     'SAND': '沙尘',
     'WIND': '大风'}

base_url = 'https://api.caiyunapp.com/v2.6/TAkhjf8d1nlSlspN/113.3401,23.1535/'

if __name__ == '__main__':
    # while True:

    realtime = requests.get(
        base_url + "realtime").json()
    if realtime['status'] == 'ok':
        print(t[realtime['result']['realtime']['skycon']], end='')

    if not realtime['result']['realtime']['skycon'] in ['CLEAR_DAY', 'CLEAR_NIGHT']:
        weather = requests.get(
            base_url+"minutely").json()

        if weather['status'] == 'ok':
            print(' '+weather['result']['forecast_keypoint'])
    # time.sleep(60*10)
