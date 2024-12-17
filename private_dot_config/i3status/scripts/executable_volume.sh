#!/bin/bash
# Save this as ~/scripts/volume.sh and make it executable (chmod +x ~/scripts/volume.sh)

VOLUME=$(amixer get Master | grep -o -m 1 '[0-9]\+%' | tr -d '%')
MUTE=$(amixer get Master | grep '\[off\]' | wc -l)

if [ "$MUTE" -eq 1 ]; then
  echo "🔇 Muted"
else
  echo "🔊 $VOLUME%"
fi
