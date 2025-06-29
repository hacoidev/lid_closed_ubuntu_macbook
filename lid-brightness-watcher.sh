#!/bin/bash

DEVICE=$(ls /sys/class/backlight/ 2>/dev/null | grep -E "intel|amdgpu|nvidia|radeon" | head -n1)
[ -z "$DEVICE" ] && DEVICE=$(ls /sys/class/backlight/ | head -n1)
[ -z "$DEVICE" ] && { echo "Không tìm thấy thiết bị backlight"; exit 1; }

ORIGINAL_BRIGHTNESS=$(brightnessctl -d $DEVICE get)

ALS_PATH="/sys/bus/iio/devices/iio:device0/in_illuminance_raw" // thay đổi device cảm biến tiệm cận ở đây
THRESHOLD=1    # ánh sáng nhỏ hơn ngưỡng này => màn hình đang bị gập
STATE=""

while true; do
  LIGHT=$(cat "$ALS_PATH" 2>/dev/null)
  if [[ "$LIGHT" =~ ^[0-9]+$ ]]; then
    if [ "$LIGHT" -lt "$THRESHOLD" ]; then
      if [ "$STATE" != "closed" ]; then
        echo "$(date): Lid likely closed (light=$LIGHT)"
        brightnessctl -d "$DEVICE" set 1
        STATE="closed"
      fi
    else
      if [ "$STATE" != "open" ]; then
        echo "$(date): Lid likely open (light=$LIGHT)"
        brightnessctl -d "$DEVICE" set $ORIGINAL_BRIGHTNESS
        STATE="open"
        break
      fi
    fi
  fi
  sleep 1
done


