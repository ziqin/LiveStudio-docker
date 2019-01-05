#!/bin/sh

on_termination ()
{
    pkill -KILL -P $$ # kill all children processes
}

trap 'on_termination' TERM

echo "Starting Nginx..."
nginx

echo "Starting uWSGI..."
cd /usr/bin && \
    uwsgi --uid nobody --gid nobody \
        --plugins http,python3 \
        --http 127.0.0.1:5000 \
        --module http_api:app \
        --enable-threads \
        --logto /dev/null &
        # --daemonize /dev/null

echo "====================================================="
echo "[CS305] Live Studio: DASH-based Live Streaming System"
echo ">>> running..."

wait
