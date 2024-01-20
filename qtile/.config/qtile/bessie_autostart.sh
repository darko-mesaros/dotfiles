#!/bin/sh

# nitrogen
nitrogen --restore &
# Authentication agent
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
#
## 1password application
1password &
#
#
## Remap CAPS lock to CTRL
#run xmodmap ~/.Xmodmap
#
## Automatically mount disks
udiskie &
#
## Compositor
#run picom --experimental-backend
#
## bluetooth
#run "blueman-applet"
