#!/bin/bash

ethernet=$(nmcli device status | grep ethernet)
wifi=$(nmcli device status | grep wifi)
con="none"

if [ -n "$ethernet" ]; then
    con="ethernet"
fi

# Check if any wifi device is connected (prioritize ethernet)
if [ -n "$wifi" ] && [ "$con" = "none" ]; then
    con="wifi"
fi

case $con in
    "ethernet")
        echo "󰈀" ;;
    "wifi")
        echo "󰤨" ;;
    *)
        echo "󰤮" ;;
esac
