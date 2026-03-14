```bash
# Начальный доступ (SSH)
docker compose up -d

# Виртуальный рабочий стол (webtop)
docker compose --profile desktop-webtop up -d

# Камера/микрофон
docker compose --profile camera up -d

# VNC (Remote Desktop)
sudo ./install-vnc.sh
docker compose --profile desktop-real up -d
```

Если авто‑детект install-vnc ошибся, можно явно указать:

```bash
sudo FORCE_VNC=wayvnc ./install-vnc.sh
# или
sudo FORCE_VNC=x11vnc ./install-vnc.sh
```

После установки можно проверить порт:

```bash
ss -tlnp | grep 5900
```

### Camera + Mic
FFmpeg забирает видео из `/dev/video0` и аудио из ALSA `default`, публикует поток в MediaMTX:

```
rtsp://127.0.0.1:8554/cam
```

MediaMTX раздаёт HLS и WebRTC через порты `8888` и `8889`.

## Настройка устройств

- Если камера на другом устройстве, замените `/dev/video0`.
- Если микрофон не `default`, укажите нужный ALSA‑input.
- Контейнер с публикацией FFmpeg теперь в цикле и не падает, если устройства временно отсутствуют.
- В compose для ffmpeg используется `privileged: true` и монтируется `/dev`, чтобы контейнер не падал при отсутствии устройств.