#!/usr/bin/env bash

# Test script for CPU temperature monitoring on Apple Silicon

echo "Testing CPU temperature monitoring tools..."

# Test macmon
if command -v macmon >/dev/null 2>&1; then
    echo "✓ macmon found"
    TEMP=$(macmon pipe -s 1 | jq -r '.temp.cpu_temp_avg' 2>/dev/null)
    if [ -n "$TEMP" ] && [ "$TEMP" != "null" ]; then
        echo "  CPU Temperature: ${TEMP}°C"
    else
        echo "  ✗ Could not read temperature from macmon"
    fi
else
    echo "✗ macmon not found"
fi

# Test smctemp
if command -v smctemp >/dev/null 2>&1; then
    echo "✓ smctemp found"
    TEMP=$(smctemp -c 2>/dev/null | head -1)
    if [ -n "$TEMP" ]; then
        echo "  CPU Temperature: ${TEMP}°C"
    else
        echo "  ✗ Could not read temperature from smctemp"
    fi
else
    echo "✗ smctemp not found"
fi

# Test iSMC
if command -v iSMC >/dev/null 2>&1; then
    echo "✓ iSMC found"
    TEMP=$(iSMC temp 2>/dev/null | grep -i "cpu" | head -1)
    if [ -n "$TEMP" ]; then
        echo "  CPU Temperature info: $TEMP"
    else
        echo "  ✗ Could not read temperature from iSMC"
    fi
else
    echo "✗ iSMC not found"
fi

# Test thermal pressure
echo "Testing thermal pressure fallback..."
THERMAL=$(sudo powermetrics -s thermal -n 1 2>/dev/null | grep "thermal level" | awk '{print $3}')
if [ -n "$THERMAL" ]; then
    echo "  Thermal Pressure: $THERMAL"
else
    echo "  ✗ Could not read thermal pressure"
fi

echo "Done!"
