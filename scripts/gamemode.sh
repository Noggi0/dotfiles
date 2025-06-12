#!/usr/bin/bash

###################################################################
### Switches between Performance and Schedutil scaling governor ###
###                                                             ###
###   Peformance governor gets the most out of your system,     ###
###      at the expense of heating and power consumption.       ###
###                                                             ###
###   Schedutil uses the kernel scheduler to lower or raise     ###
###          CPU freqs. It is very balanced overall.            ###
###################################################################

if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ "$current_governor" = "performance" ]; then
    new_governor="schedutil"
elif [ "$current_governor" = "schedutil" ]; then
    new_governor="performance"
else
    echo "Current governor $current_governor not handled."
    exit 1
fi

for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    echo "$new_governor" >"$cpu/cpufreq/scaling_governor" || {
        echo "Error while changing governor for CPU $cpu"
    }
done

echo "CPU Governor changed to $new_governor"
