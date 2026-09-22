#!/bin/bash

# 1. WirePlumber / PipeWire
if command -v wpctl &>/dev/null; then
    output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    if [ -n "$output" ]; then
        vol_float=$(echo "$output" | awk '{print $2}')
        vol_pct=$(awk -v v="$vol_float" 'BEGIN { printf "%d", (v * 100) + 0.5 }')
        if echo "$output" | grep -q "MUTED"; then
            status="off"
        else
            status="on"
        fi
        echo "${vol_pct}% $status"
        exit 0
    fi
fi

# 2. PulseAudio / pactl fallback
if command -v pactl &>/dev/null; then
    vol_pct=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -Po '\d+(?=%)' | head -n 1)
    if [ -n "$vol_pct" ]; then
        mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)
        if echo "$mute" | grep -q "yes"; then
            status="off"
        else
            status="on"
        fi
        echo "${vol_pct}% $status"
        exit 0
    fi
fi

# 3. ALSA fallback
for control in Master PCM Headphone Speaker 'IEC958,0'; do
    for card in 0 1; do
        output=$(amixer -c "$card" sget "$control" 2>/dev/null)
        if echo "$output" | grep -q "$control"; then
            mute_status=$(echo "$output" | awk -F'[][]' '/Mono:|Left:/ {for(i=1;i<=NF;i++) if($i=="off") {print "off"; exit}; print "on"}')
            volume=$(echo "$output" | awk -F'[][]' '/Left:|Mono:/ {print $2; exit}')
            echo "$volume $mute_status"
            exit 0
        fi
    done
done

echo "0% off"
exit 1
