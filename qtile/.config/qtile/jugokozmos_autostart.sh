#!/bin/sh

# Authentication agent
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# 1password application
1password &

# Enabling two finger right click on the touchpad
xinput set-prop "PIXA3854:00 093A:0274 Touchpad" "libinput Click Method Enabled" 0 1 &

# Remap CAPS lock to CTRL
xmodmap ~/.Xmodmap &

# Automatically mount disks
udiskie &

# Compositor
picom -b &

# desktop wallpaper
nitrogen --restore &

# bluetooth
blueman-applet &
