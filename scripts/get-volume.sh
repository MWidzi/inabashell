#!/bin/bash

for control in Master PCM Headphone Speaker 'IEC958,0'; do
    for card in 0 1; do
        output=$(amixer -c "$card" sget "$control" 2>/dev/null)
        if echo "$output" | grep -q "$control"; then
            mute_status=$(echo "$output" | awk -F'[][]' '/Mono:|Left:/ {for(i=1;i<=NF;i++) if($i=="off") {print "off"; exit}; print "on"}')

      # Get volume level
      volume=$(echo "$output" | awk -F'[][]' '/Left:|Mono:/ {print $2; exit}')

      echo "$volume $mute_status"
      exit 0
        fi
    done
done
echo "0% off" >&2
exit 1
