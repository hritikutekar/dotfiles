#!/usr/bin/env zsh

LOCATION="Pune"

# Line below replaces spaces with +
LOCATION_ESCAPED="${LOCATION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1")

# Fallback if empty or invalid JSON
if [ -z "$WEATHER_JSON" ] || ! echo "$WEATHER_JSON" | jq -e . > /dev/null 2>&1; then

    sketchybar --set "$NAME" label="$LOCATION"
    sketchybar --set "$NAME.moon" icon=

    return
fi

# Calculate closest hourly time for fallback (e.g. 0, 300, 600...)
# 10/3 = 3 -> 900
HOUR=$(date +%-H)
TIME_KEY=$(( (HOUR / 3) * 300 ))

TEMPERATURE=$(echo "$WEATHER_JSON" | jq -r --arg t "$TIME_KEY" '.current_condition[0].temp_C // (first(.weather[0].hourly[] | select(.time == $t) | .tempC)) // .weather[0].hourly[0].tempC')
WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq -r --arg t "$TIME_KEY" '.current_condition[0].weatherDesc[0].value // (first(.weather[0].hourly[] | select(.time == $t) | .weatherDesc[0].value)) // .weather[0].hourly[0].weatherDesc[0].value' | sed 's/\(.\{25\}\).*/\1.../')
MOON_PHASE=$(echo "$WEATHER_JSON" | jq -r '.weather[0].astronomy[0].moon_phase')

case ${MOON_PHASE} in
"New Moon")
    ICON=
    ;;
"Waxing Crescent")
    ICON=
    ;;
"First Quarter")
    ICON=
    ;;
"Waxing Gibbous")
    ICON=
    ;;
"Full Moon")
    ICON=
    ;;
"Waning Gibbous")
    ICON=
    ;;
"Last Quarter")
    ICON=
    ;;
"Waning Crescent")
    ICON=
    ;;
esac

sketchybar --set "$NAME" label="$LOCATION  $TEMPERATURE℃ $WEATHER_DESCRIPTION"
sketchybar --set "$NAME.moon" icon="$ICON"
