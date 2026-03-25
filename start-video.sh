#!/bin/sh
set -eu

MEDIAMTX_HOST="${MEDIAMTX_HOST:-mediamtx}"
MEDIAMTX_PORT="${MEDIAMTX_PORT:-8554}"
RTSP_PATH_VIDEO="${RTSP_PATH_VIDEO:-cam}"

while true; do
  if [ ! -e /dev/video0 ]; then
    echo "No video device detected. Retrying in 10s..."
    sleep 10
    continue
  fi

  echo "Starting video publisher..."
  ffmpeg \
    -thread_queue_size 512 -f v4l2 -i /dev/video0 \
    -c:v libx264 -preset ultrafast -tune zerolatency \
    -f rtsp "rtsp://${MEDIAMTX_HOST}:${MEDIAMTX_PORT}/${RTSP_PATH_VIDEO}" || true

  echo "ffmpeg exited. Retrying in 5s..."
  sleep 5
done
