#!/bin/sh
set -eu

MEDIAMTX_HOST="${MEDIAMTX_HOST:-mediamtx}"
MEDIAMTX_PORT="${MEDIAMTX_PORT:-8554}"
RTSP_PATH_OPUS="${RTSP_PATH_OPUS:-mic}"
RTSP_PATH_AAC="${RTSP_PATH_AAC:-mic-aac}"

while true; do
  if [ ! -e /dev/snd ]; then
    echo "No audio device detected. Retrying in 10s..."
    sleep 10
    continue
  fi

  echo "Starting audio publisher..."
  ffmpeg \
    -thread_queue_size 512 -f alsa -i default \
    -c:a libopus -f rtsp "rtsp://${MEDIAMTX_HOST}:${MEDIAMTX_PORT}/${RTSP_PATH_OPUS}" \
    -c:a aac -b:a 128k -f rtsp "rtsp://${MEDIAMTX_HOST}:${MEDIAMTX_PORT}/${RTSP_PATH_AAC}" || true

  echo "ffmpeg exited. Retrying in 5s..."
  sleep 5
done
