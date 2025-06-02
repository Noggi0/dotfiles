#!/usr/bin/bash

# How to use :
# ./volume.sh up
# ./volume.sh down
# ./volume.sh mute

raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$raw" | grep -oP '\d+\.\d+' | awk '{ printf("%.0f", $1 * 100) }')

get_volume_percent() {
    local raw
    raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    echo "$raw" | grep -oP '\d+\.\d+' | awk '{ printf("%.0f", $1 * 100) }'
}

if echo "$raw" | grep -q '\[MUTED\]'; then
    muted=false
else
    muted=true
fi

case $1 in
up)
    wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    dunstify -a "changeVolume" -u low -i " " -h string:x-dunst-stack-tag:"Volume" -h int:value:"$(get_volume_percent)" "${volume}%"
    ;;
down)
    wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
    dunstify -a "changeVolume" -u low -i " " -h string:x-dunst-stack-tag:"Volume" -h int:value:"$(get_volume_percent)" "${volume}%"
    ;;
mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if [ $muted = true ]; then
        message="Muted"
        icon=" "
    else
        message="Unmuted"
        icon=" "
    fi
    dunstify -a "changeVolume" -u low -i $icon -h string:x-dunst-stack-tag:"Volume" $message
    ;;
esac
