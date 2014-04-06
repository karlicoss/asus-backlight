#!/bin/bash
# taken from https://aur.archlinux.org/packages/as/asus-kbd-backlight/PKGBUILD

path="/sys/class/leds/asus::kbd_backlight"
if [ ! -e "$path" ]; then
  path="/sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight"
fi

# max should be 3
max=$(cat ${path}/max_brightness)
# step: represent the difference between previous and next brightness
step=1
previous=$(cat ${path}/brightness)

function commit {
    if [[ $1 = [0-9]* ]]
    then 
        if [[ $1 -gt $max ]]
        then 
            next=$max
        elif [[ $1 -lt 0 ]]
        then 
            next=0
        else 
            next=$1
        fi
        echo $next >> ${path}/brightness
        exit 0
    else 
        exit 1
    fi
}

case "$1" in
 up)
     commit $(($previous + $step))
  ;;
 down)
     commit $(($previous - $step))
  ;;
 max)
     commit $max
  ;;
 on)
     $0 max
  ;;
 off)
     commit 0
  ;;
 show)
     echo $previous
  ;;
 night)
     commit 1 
     ;;
 allowusers)
     # Allow members of users group to change brightness
     sudo chgrp karlicos ${path}/brightness
     sudo chmod g+w ${path}/brightness
  ;;
 disallowusers)
     # Allow members of users group to change brightness
     sudo chgrp root ${path}/brightness
     sudo chmod g-w ${path}/brightness
  ;;
 *)
     commit $1
esac

exit 0
