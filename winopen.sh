#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# test window classes when being opened

usage() {
    printf '%s\n' "usage: $(basename $0) <wid>"
    exit 1
}

test -z $1 && usage

wid=$1
windowC=$(wclass.sh c $wid)
windowM=$(wclass.sh m $wid)

# for speed
setborder.sh active $wid

if [ "$windowC" = "mupdf" ]; then
    wgroups.sh -s $wid 1
elif [ "$windowC" = "Navigator" ]; then
    sleep 0.5
    wgroups.sh -s $wid 2
elif [ "$windowC" = "Dialog" ]; then
    position.sh md $wid
elif [ "$windowC" = "mosh" ]; then
    position.sh mid $wid
    wgroups.sh -s $wid 3
elif [ "$windowC" = *"ts3"* ]; then
    position.sh tl $wid
    position.sh ext $wid
    wgroups.sh -s $wid 4
elif [ "$windowM" = "mpv" ]; then
    wgroups.sh -s $wid 5
    transset-df -i $wid 1
    tile.sh
elif [ "$windowC" = "ncmpcpp" ]; then
    position.sh tr $wid
    position.sh ext $wid
    wgroups.sh -s $wid 8
elif [ "$windowC" = "mpsyt" ]; then
    position.sh tr $wid
    position.sh ext $wid
    wgroups.sh -s $wid 9
elif [ "$windowC" = "alsamixer" ]; then
    position.sh mid $wid
elif [ "$windowC" = "Terminal" ]; then
    tile.sh
elif [ "$windowC" = "urxvt" ]; then
    position.sh md $wid
else
    position.sh md $wid
fi
