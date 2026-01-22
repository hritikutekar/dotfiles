#!/usr/bin/env bash

# CPU Temperature monitoring for SketchyBar on Apple Silicon
# Uses macmon for temperature readings with fallbacks

# Color Palette (Catppuccin Macchiato)
COLOR_GREEN=0xffa6da95
COLOR_YELLOW=0xfff5a97f
COLOR_RED=0xffed8796

update_temp() {
    local temp=$1
    local color=$COLOR_GREEN
    
    if [[ "$temp" =~ ^[0-9]+$ ]]; then
        if [ "$temp" -ge 80 ]; then
            color=$COLOR_RED
        elif [ "$temp" -ge 60 ]; then
            color=$COLOR_YELLOW
        fi
        sketchybar -m --set cpu_temp icon="" icon.color=$color label="${temp}°C"
    else
        # Handle non-numeric status (like thermal pressure)
        case "$temp" in
            *"Nominal"*) color=$COLOR_GREEN ;;
            *"Moderate"*) color=$COLOR_YELLOW ;;
            *"Heavy"*|*"Critical"*) color=$COLOR_RED ;;
            *) color=$COLOR_YELLOW ;;
        esac
        sketchybar -m --set cpu_temp icon="" icon.color=$color label="$temp"
    fi
}

# Try to get temperature from macmon first
if command -v macmon >/dev/null 2>&1; then
    CPU_TEMP=$(macmon pipe -s 1 | jq -r '.temp.cpu_temp_avg' 2>/dev/null | cut -d. -f1)

    if [ -n "$CPU_TEMP" ] && [ "$CPU_TEMP" != "null" ]; then
        update_temp "$CPU_TEMP"
        exit 0
    fi
fi

# Fallback: Try smctemp if available
if command -v smctemp >/dev/null 2>&1; then
    CPU_TEMP=$(smctemp -c 2>/dev/null | head -1)
    if [ -n "$CPU_TEMP" ]; then
        update_temp "$CPU_TEMP"
        exit 0
    fi
fi

# Fallback: Try iSMC if available
if command -v iSMC >/dev/null 2>&1; then
    CPU_TEMP=$(iSMC temp 2>/dev/null | grep -i "cpu" | head -1 | awk '{print $2}' | tr -d '°C')
    if [ -n "$CPU_TEMP" ]; then
        update_temp "$CPU_TEMP"
        exit 0
    fi
fi

# Final fallback: Show thermal pressure or unavailable
THERMAL_PRESSURE=$(sudo powermetrics -s thermal -n 1 2>/dev/null | grep "thermal level" | awk '{print $3}')
if [ -n "$THERMAL_PRESSURE" ]; then
    update_temp "$THERMAL_PRESSURE"
else
    sketchybar -m --set cpu_temp icon="" icon.color=$COLOR_YELLOW label="--"
fi
