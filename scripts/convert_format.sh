#!/bin/sh

APP=$1
NAME=$2
PORT=$3
ROOT=localhost

on_termination ()
{
    pkill -KILL -P $$ # kill all children processes
}

trap 'on_termination' TERM
ffmpeg -i rtmp://${ROOT}:${PORT}/$APP/$NAME \
    -c:a aac -b:a 64k -c:v libx264 -preset fast -profile:v baseline -vsync vfr \
        -s 1024x576 -b:v 1280K -bufsize 1280k -f flv rtmp://${ROOT}:${PORT}/dash/${NAME}_576p \
    -c:a aac -b:a 64k -c:v libx264 -preset fast -profile:v baseline -vsync vfr \
        -s 640x360 -b:v 960K -bufsize 960k -f flv rtmp://${ROOT}:${PORT}/dash/${NAME}_360p \
    -c:a aac -b:a 64k -c:v libx264 -preset fast -profile:v baseline -vsync vfr \
        -s 480x270 -b:v 324K -bufsize 324k -f flv rtmp://${ROOT}:${PORT}/dash/${NAME}_270p &
wait
