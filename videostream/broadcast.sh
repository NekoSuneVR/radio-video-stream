#!/usr/bin/env bash

source /etc/container_environment.sh

ffmpeg \
    -re -f image2 -loop 1 -i 247radio.png \
    -thread_queue_size 512 -i "${VS_AUDIO_SOURCE}" -i nekocr.png \
    -map 0:v:0 -map 1:a:0 \
    -map_metadata:g 1:g \
    -filter_complex "overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01,drawtext=textfile=${VS_TEXT_SOURCE}:reload=1:x=(w-text_w)/2:y=h-th:fontsize=34:fontcolor=white" \
    -vcodec libx264 -pix_fmt yuv420p -preset ${VS_QUALITY} -r ${VS_FPS} -g $((${VS_FPS} * 2)) -b:v ${VS_VBR} \
    -acodec libmp3lame -ar 44100 -threads 6 -qscale:v 3 -b:a 320000 -bufsize 512k \
    -f flv "${VS_RTMP_SERVER}"
