#!/bin/bash

DEVICES=(
    "88:C9:E8:4B:67:33" # WH-100XM4
    "F0:D3:1F:62:1A:D7" # Airpods Pro
)

bluetoothctl power on >/dev/null 2>&1

while true; do
    for device in "${DEVICES[@]}"; do
        info=$(bluetoothctl info "$device" 2>/dev/null)

        if echo "$info" | grep -q "Connected: yes"; then
            continue
        fi

        if echo "$info" | grep -q "Paired: yes"; then
            bluetoothctl connect "$device" >/dev/null 2>&1
        fi
    done

    sleep 1
done
