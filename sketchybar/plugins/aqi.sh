#!/usr/bin/env zsh

STATION="Mhada Colony, Pune - IITM"

AQI_XML=$(curl -s "https://airquality.cpcb.gov.in/caaqms/rss_feed")

# Extract AQI from XML using awk
# Finds the station, then looks for Air_Quality_Index tag before the Station closing tag
AQI_LINE=$(echo "$AQI_XML" | awk -v station="$STATION" '$0 ~ "id=\"" station "\"" {found=1} found && /<\/Station>/ {exit} found && /Air_Quality_Index/ {print; exit}')

# Extract integer value (e.g. Value="190" -> 190)
AQI=$(echo "$AQI_LINE" | sed -E 's/.*Value="([0-9]+)".*/\1/')

if [ -z "$AQI" ]; then
  sketchybar --set "$NAME" label="AQI ?"
  return
fi

# CPCB AQI Color Scale
if [ "$AQI" -le 50 ]; then
  COLOR=0xffa6da95 # Good (0-50)
elif [ "$AQI" -le 100 ]; then
  COLOR=0xffeed49f # Satisfactory (51-100)
elif [ "$AQI" -le 200 ]; then
  COLOR=0xfff5a97f # Moderate (101-200)
elif [ "$AQI" -le 300 ]; then
  COLOR=0xffed8796 # Poor (201-300)
elif [ "$AQI" -le 400 ]; then
  COLOR=0xffc6a0f6 # Very Poor (301-400)
else
  COLOR=0xff8087a2 # Severe (401-500)
fi

ICON=

sketchybar --set "$NAME" label="AQI $AQI" icon="$ICON" icon.color=$COLOR
