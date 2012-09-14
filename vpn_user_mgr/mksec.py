#!/usr/bin/env python
#coding=utf-8

import csv
import os
import time
from datetime import datetime

def hostname():
    sys = os.name

    if sys == 'nt':
        hostname = os.getenv('computername')
        return hostname
    elif sys == 'posix':
        host = os.popen('echo $HOSTNAME')
        try:
            hostname = host.read()
            return hostname[:-1]
        finally:
            host.close()
    else:
        return 'Unkwon hostname'

index = 0
reader = csv.reader(open("/home/vpnuser/sec.csv"))
cont = ""
for myhost, username, key, password, plan, email, starttime, endtime, comment in reader:
    if index == 0:
        index += 1
    else:
        try:
            endt = time.strptime(endtime, "%Y-%m-%d")
            nowt = datetime.now().timetuple()
            if nowt < endt:
                thishost = hostname()
                if myhost == thishost:
                    cont += username + "\tl2tpd\t" + password + "\t*\n"
        except:
            pass
print cont
