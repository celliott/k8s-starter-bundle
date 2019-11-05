#!/usr/bin/env python

import os
import options
import requests
import json
from flask import Flask, render_template, request, abort

app = Flask(__name__)
options = options.get()
base_url = "http://{api_host}:{api_port}".format(**options)

def api_call(url):
    r = requests.get(url, auth=(options['api_user'], options['api_pass']))
    if r.status_code == 200:
        return r
    else:
        abort(r.status_code)

@app.route("/", methods=['GET'])
def index():
    data = api_call(base_url)
    return render_template('index', **data.json())

@app.route('/<path>', methods=['GET'])
def dynamic_route(path):
    url = "{}/{}".format(base_url, path)
    data = api_call(url)
    return data.text

@app.route("/v2/crash", methods=['GET'])
def crash():
    raise ValueError("Crash!")

if __name__ == "__main__":
    app.run(host=options['app_host'], port=options['app_port'])
