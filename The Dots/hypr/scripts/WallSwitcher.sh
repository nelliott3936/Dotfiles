#!/usr/bin/env bash

export TARGET_DIR="$HOME/Pictures/Wallpapers"

# We use 'export' so any child processes spawned by your command can see it
export LAST_PICKED_FILE=""

while true; do
    # 1. Grab all files safely (handles spaces and weird characters)
    all_files=()
    while IFS= read -r -d '' file; do
        all_files+=("$file")
    done < <(find "$TARGET_DIR" -maxdepth 1 -type f -print0 2>/dev/null)

    # 2. Shuffle the files array using Knuth-Fisher-Yates shuffle
    # This guarantees a random order without repeats in this cycle
    size=${#all_files[@]}
    for ((i=size-1; i>0; i--)); do
        j=$(( RANDOM % (i + 1) ))
        temp="${all_files[i]}"
        all_files[i]="${all_files[j]}"
        all_files[j]="$temp"
    done

    echo "--- Starting new cycle of ${#all_files[@]} files ---"

    # 3. Loop through the shuffled array
    for file in "${all_files[@]}"; do
        # Update the environment variable
        export LAST_PICKED_FILE="$file"
        
        echo "🎯 Running on: $LAST_PICKED_FILE"
        
        # Execute your command, safely quoting the file path
        eval "hyprctl hyprpaper wallpaper ,$LAST_PICKED_FILE,fill"
        eval "bash ~/.config/hypr/scripts/Color.sh \"$LAST_PICKED_FILE\""
        
        # Avoid tight-looping CPU meltdowns (adjust or remove if your command takes time)
        sleep 10 
    done

done
