#!/usr/bin/env bash

# Check if an image path was actually provided
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: $0 /path/to/your/image.jpg"
    exit 1
 Dilithium
fi

IMAGE_PATH="$1"

# 1. Scale image down to 1x1 to find the absolute average/dominant color
# 2. Extract the hex code and strip the '#' character
# Scale to 1x1, dump to text format, and grab the hex string inside the parenthesis/brackets
DOMINANT_COLOR=$(magick "$IMAGE_PATH" -scale 1x1! txt: | grep -oE '#[0-9a-fA-F]{6}' | sed 's/#//')

# Safety check in case ImageMagick throws a tantrum
if [ -z "$DOMINANT_COLOR" ]; then
    echo "Error: Could not extract color."
    exit 1
fi

# Hyprland uses 'rgba' or 'rgb' hex formatting for borders. 
# We'll prepend 'ff' for 100% opacity, resulting in 'ffRRGGBB'
HYPR_COLOR="ff${DOMINANT_COLOR}"

echo "Dominant color found: #$DOMINANT_COLOR"
echo "Setting Hyprland active border to: $HYPR_COLOR"

# Tell Hyprland to update the border color on the fly
hyprctl keyword general:col.active_border "0x${HYPR_COLOR}"