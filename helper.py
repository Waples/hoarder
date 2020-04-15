#!/usr/bin/env python3
"""Helper module"""
#pylint: disable=C0103,W0703
project_home = '/home/pi'
try:
    from requests import get as r
    if r('http://ifconfig.co/json').ok:
        with open('configs/nginx/flask.conf', 'r') as f:
            data = f.read()
            f.close()
        with open('configs/nginx/flask.conf', 'w') as f:
            f.write(data.replace('CH_HOME', project_home))
            f.write(
                data.replace('IP_ADDR',
                    r('http://ifconfig.co/json').json()['ip']
                    )
                )
except Exception as err:
    print(err)
