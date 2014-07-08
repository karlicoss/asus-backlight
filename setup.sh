#!/bin/bash
set -e
set -x
cp upstart/asus-backlight.conf /etc/init/asus-backlight.conf
dconf write "/org/mate/power-manager/kbd-backlight-battery-reduce" "false"
