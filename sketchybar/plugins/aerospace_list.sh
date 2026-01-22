#!/usr/bin/env bash

AEROSPACE_WORKSPACES=$(aerospace list-workspaces --all)

for sid in $AEROSPACE_WORKSPACES; do
  if ! sketchybar --query space.$sid > /dev/null 2>&1; then
    
    bg_drawing="off"
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      bg_drawing="on"
    fi

    sketchybar --add item space.$sid left \
               --subscribe space.$sid aerospace_workspace_change \
               --set space.$sid \
               background.color=0x44ffffff \
               background.corner_radius=5 \
               background.height=20 \
               icon.padding_left=0 \
               icon.padding_right=0 \
               label.padding_left=4 \
               background.drawing="$bg_drawing" \
               padding_left=5 \
               label.width=20 \
               label.height=20 \
               label.align="center" \
               label="$sid" \
               click_script="aerospace workspace $sid" \
               script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    
    sketchybar --move space.$sid before front_app > /dev/null 2>&1
  fi
done

CURRENT_ITEMS=$(sketchybar --query bar | jq -r '.items[]')

for item in $CURRENT_ITEMS; do
  if [[ "$item" =~ ^space\.(.+)$ ]]; then
    sid="${BASH_REMATCH[1]}"
    if ! echo "$AEROSPACE_WORKSPACES" | grep -qx "$sid"; then
       sketchybar --remove "$item"
    fi
  fi
done
