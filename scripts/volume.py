#!/usr/bin/env python3

import argparse
import subprocess


volume_icons = [
                " ",
                " ",
                " ",
                " "
                ]

def send_notification():
    output = subprocess.run(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], stdout=subprocess.PIPE)
    outputStr = output.stdout.decode().strip()
    if "[MUTED]" in outputStr:
        subprocess.run([f"dunstify -a \"changeVolume\" -u low -i {volume_icons[0]} \"Muted\""], shell=True)
    else:
        value = float(outputStr.split(":")[1].strip())
        percentage = int(value * 100)
        icon_index = int(percentage / 100 * (len(volume_icons) - 2) + 1)
        if percentage == 0:
            icon_index = 0

        subprocess.run([f"dunstify -a \"changeVolume\" -u low -i {volume_icons[icon_index]} -h string:x-dunst-stack-tag:\"Volume\" -h int:value:{percentage} {percentage}%"], shell=True)


def changeVolume(negative):
    if negative:
        subprocess.run(["wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"], shell=True)
    else:
        subprocess.run(["wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"], shell=True)
    send_notification()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Optional')

    parser.add_argument("command", type=str, help="up, down, mute")

    args = parser.parse_args()

    if args.command == "up":
        changeVolume(False)
    elif args.command == "down":
        changeVolume(True)
    elif args.command == "mute":
        subprocess.run(["wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"], shell=True)
        send_notification()
    else:
        print("Wrong argument")
        exit(1)
