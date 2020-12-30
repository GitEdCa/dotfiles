#!/bin/sh
# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%h %d (%a) %R")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

# Returns the battery status: "Full", "Discharging", or "Charging".
battery_status=$(cat /sys/class/power_supply/BAT0/status)
case "$battery_status" in
    "Full") battery_status="⚡" ;;
    "Discharging") battery_status="🔋" ;;
    "Charging") battery_status="🔌" ;;
    "Not charging") battery_status="🛑" ;;
    "Unknown") battery_status="♻️" ;;
esac
bat_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
[ "$battery_status" = "🔋" ] && [ "$bat_capacity" -le 25 ] && warn="❗"
# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
#prints the info
#echo $uptime_formatted 🐧 $battery_status $warn $bat_capacity % $date_formatted; unset warn
printf "%s %s | %s%s%s %% | %s\n" "$uptime_formatted" "🐧" "$battery_status" "$warn" "$bat_capacity" "$date_formatted"
unset warn
