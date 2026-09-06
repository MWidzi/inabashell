#!/bin/bash

# 1. Try lm_sensors
if command -v sensors &>/dev/null; then
    temp=$(sensors coretemp-* k10temp-* zenpower-* cpu_thermal-* thinkpad-* asus-* dell_smm-* 2>/dev/null | awk '
        /Package id 0|Tctl|Tdie|CPU|temp1:/ {
            for (i = 1; i <= NF; i++) {
                if ($i ~ /^\+[0-9]+(\.[0-9]+)?°C/) {
                    gsub(/^\+|\..*|°C/, "", $i)
                    print $i
                    exit
                }
            }
        }
    ')

    if [ -z "$temp" ]; then
        temp=$(sensors 2>/dev/null | awk '
            /^(coretemp|k10temp|zenpower|cpu_thermal)/ { in_cpu = 1; next }
            /^$/ { in_cpu = 0 }
            in_cpu || /Package id 0|Tctl|Tdie|CPU/ {
                for (i = 1; i <= NF; i++) {
                    if ($i ~ /^\+[0-9]+(\.[0-9]+)?°C/) {
                        gsub(/^\+|\..*|°C/, "", $i)
                        print $i
                        exit
                    }
                }
            }
        ')
    fi

    if [ -n "$temp" ] && [ "$temp" -gt 0 ] 2>/dev/null; then
        echo "$temp"
        exit 0
    fi
fi

# 2. Fallback: Query /sys/class/hwmon for dedicated CPU drivers
for h in /sys/class/hwmon/hwmon*; do
    [ -d "$h" ] || continue
    name=$(cat "$h/name" 2>/dev/null)
    case "$name" in
        coretemp|k10temp|zenpower|cpu_thermal|thinkpad|asus|dell_smm)
            for t in "$h"/temp*_input; do
                [ -f "$t" ] || continue
                val=$(cat "$t" 2>/dev/null)
                if [ -n "$val" ] && [ "$val" -gt 0 ] 2>/dev/null; then
                    echo "$((val / 1000))"
                    exit 0
                fi
            done
            ;;
    esac
done

# 3. Fallback: Query /sys/class/thermal zones (CPU / package / k10temp)
for z in /sys/class/thermal/thermal_zone*; do
    [ -d "$z" ] || continue
    type=$(cat "$z/type" 2>/dev/null)
    case "$type" in
        *x86*|*pkg*|*CPU*|*cpu*|*k10temp*)
            val=$(cat "$z/temp" 2>/dev/null)
            if [ -n "$val" ] && [ "$val" -gt 0 ] 2>/dev/null; then
                echo "$((val / 1000))"
                exit 0
            fi
            ;;
    esac
done

# 4. Fallback: ACPI thermal zones
for h in /sys/class/hwmon/hwmon*; do
    [ -d "$h" ] || continue
    name=$(cat "$h/name" 2>/dev/null)
    if [ "$name" = "acpitz" ]; then
        for t in "$h"/temp*_input; do
            [ -f "$t" ] || continue
            val=$(cat "$t" 2>/dev/null)
            if [ -n "$val" ] && [ "$val" -gt 0 ] 2>/dev/null; then
                echo "$((val / 1000))"
                exit 0
            fi
        done
    fi
done

for z in /sys/class/thermal/thermal_zone*; do
    [ -d "$z" ] || continue
    type=$(cat "$z/type" 2>/dev/null)
    if [[ "$type" == *acpitz* ]]; then
        val=$(cat "$z/temp" 2>/dev/null)
        if [ -n "$val" ] && [ "$val" -gt 0 ] 2>/dev/null; then
            echo "$((val / 1000))"
            exit 0
        fi
    fi
done

# 5. Final fallback: any thermal zone with a positive temperature
for z in /sys/class/thermal/thermal_zone*/temp; do
    [ -f "$z" ] || continue
    val=$(cat "$z" 2>/dev/null)
    if [ -n "$val" ] && [ "$val" -gt 0 ] 2>/dev/null; then
        echo "$((val / 1000))"
        exit 0
    fi
done

echo "0"
exit 1
