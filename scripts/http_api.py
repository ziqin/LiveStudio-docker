#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask, request, jsonify


app = Flask(__name__)

_data = {}

def db():
    global _data
    return _data

def wrap_channel(name):
    return {
        "name": name,
        "type": "dash",
        "quality": [
            { "name": "Auto", "url": "/dash/{}.mpd".format(name) },
            { "name": "High", "url": "/dash/{}_576p/index.mpd".format(name) },
            { "name": "Medium", "url": "/dash/{}_360p/index.mpd".format(name) },
            { "name": "Low", "url": "/dash/{}_270p/index.mpd".format(name) }
        ],
        "defaultQuality": 0
    }

@app.route('/channels/all')
def channels_get():
    videos = [wrap_channel(name) for name in db().keys()]
    return jsonify(channels=videos)

@app.route('/api/channels/new', methods=['POST'])
def channels_publish():
    channel_name = request.form['name']
    ip = request.form['addr']
    repo = db()
    if channel_name not in repo:
        repo[channel_name] = ip
        return 'ok'
    else:
        return 'failed', 500

@app.route('/api/channels/done', methods=['POST'])
def channels_publish_done():
    channel_name = request.form['name']
    ip = request.form['addr']
    repo = db()
    if channel_name in repo and repo.pop(channel_name) == ip:
        return 'done'
    else:
        return 'failed', 500

if __name__ == '__main__':
    # Don't run this script directly in production environment
    app.run(host='127.0.0.1', port=5000)
