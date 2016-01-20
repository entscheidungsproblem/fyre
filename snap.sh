#!/bin/sh
#
# wildefyr & kekler - 2016 (c) wtfpl
# snap windows without resize

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <option> [wid]
    h|left:  Snap window to the left side of the screen.
    j|down:  Snap window to the bottom side of the screen.
    k|up:    Snap window to the up side of the screen.
    l|right: Snap window to the right side of the screen.
    tl:      Snap window to the top-left corner of the screen.
    tr:      Snap window to the top-right corner of the screen.
    bl:      Snap window to the bottom-left corner of the screen.
    br:      Snap window to the bottom-right corner of the screen.
    md:      Snap window to the middle of the screen.
    h|help:  Show this help.
EOF
    test -z $1 && exit 0 || exit $1
}

snap_left() {
    X=$XGAP
}

snap_up() {
    Y=$TGAP
}

snap_down() {
    Y=$((SH - BGAP - H + BW))
}

snap_right() {
    X=$((SW - XGAP - W - BW))
}

snap_tl() {
    X=$XGAP
    Y=$TGAP
}

snap_tr() {
    X=$((SW - XGAP - W - BW))
    Y=$TGAP
}

snap_bl() {
    X=$XGAP
    Y=$((SH - BGAP - H + BW))
}

snap_br() {
    X=$((SW - XGAP - W - BW)) 
    Y=$((SH - BGAP - H + BW))
}

snap_md() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    X=$((SW/2 - W/2 - BW + XGAP)) 
    Y=$((SH/2 - H/2 + TGAP))
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $PFW
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in 
        h|left)  snap_left  ;;
        j|down)  snap_down  ;;
        k|up)    snap_up    ;;
        l|right) snap_right ;;
        tl)      snap_tl    ;;
        tr)      snap_tr    ;;
        bl)      snap_bl    ;;
        br)      snap_br    ;;
        md)      snap_md    ;;
        *)       usage      ;;
    esac

    wtp $X $Y $W $H $PFW
    moveMouse
} 

main $ARGS
