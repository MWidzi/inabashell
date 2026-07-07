#!/bin/bash

ethernet=$(nmcli device status | grep ethernet | grep -w "connected")
wifi=$(nmcli device status | grep wifi | grep -w "connected")
con="none"

if [ -n "$ethernet" ]; then
    con="ethernet"
fi

# Check if any wifi device is connected (prioritize ethernet)
if [ -n "$wifi" ] && [ "$con" = "none" ]; then
    con="wifi"
    strength="$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^\*' | cut -d: -f2)"
fi

case $con in
    "ethernet")
        echo "󰈀 100" ;;
    "wifi")
        if [ "$strength" -gt 80 ]; then 
            echo "󰤨 $strength"
        elif [ "$strength" -lt 80 ] && [ "$strength" -gt 60 ]; then 
            echo "󰤥 $strength"
        elif [ "$strength" -lt 60 ] && [ "$strength" -gt 40 ]; then 
            echo "󰤢 $strength"
        elif [ "$strength" -lt 40 ] && [ "$strength" -gt 20 ]; then 
            echo "󰤟 $strength"
        else 
            echo "󰤯 $strength"
        fi ;;
    *)
        echo "󰤮 -" ;;
esac
