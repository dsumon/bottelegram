#!/bin/bash
CURRENT=$(df | grep -Ev '/dev/sda15' | grep 'dev/sda1' | awk '{print $5}' | sed 's/%//g')
#CURRENT=$(df | grep 'dev/sda' | awk '{print $5}' | sed 's/%//g')
#CURRENT=$(cd /home/xxx && du -hs | sed -e 's/[^0-9]//g')
THRESHOLD=90
HOSTNAME=$(echo 'xxx - xxx')

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    . /home/path/bottelegram/telegram-notify --error --title "Disque Plein $HOSTNAME" --text "Partition /dev/sda1 > 90%. Utilisé: $CURRENT%"
fi
