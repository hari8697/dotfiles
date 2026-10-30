#!/usr/bin/env bash

set -u

DEVICES=(
    "88:C9:E8:4B:67:33" # WH-1000XM4
    "F0:D3:1F:62:1A:D7" # AirPods Pro
)

log() {
    echo "[bluetooth-autoconnect] $*"
}

wait_for_bluetooth() {
    log "Waiting for Bluetooth controller..."

    for _ in {1..30}; do
        if bluetoothctl show 2>/dev/null | grep -q "Powered:"; then
            log "Bluetooth controller ready"
            return 0
        fi

        sleep 1
    done

    log "Bluetooth controller did not become ready"
    return 1
}

connect_device() {
    local device="$1"

    local info
    info="$(bluetoothctl info "$device" 2>/dev/null || true)"

    # Device isn't known to BlueZ yet
    if ! grep -q "Paired: yes" <<< "$info"; then
        return 0
    fi

    # Already connected
    if grep -q "Connected: yes" <<< "$info"; then
        return 0
    fi

    log "Attempting connection to $device"

    if bluetoothctl connect "$device" >/dev/null 2>&1; then
        log "Connected to $device"
    else
        log "Connection failed for $device"
    fi
}

log "Starting"

# Wait until BlueZ is actually available
wait_for_bluetooth || exit 1

# Make sure the adapter is powered
bluetoothctl power on >/dev/null 2>&1 || true

while true; do
    for device in "${DEVICES[@]}"; do
        connect_device "$device"
    done

    sleep 3
done
