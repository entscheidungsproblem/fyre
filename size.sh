#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# sane resize in a direction

usage() {
    cat >&2 << EOF
Usage: $(basename $0) <direction> [wid]
    gr | growright:  Grow current or given window right
    gd | growdown:   Grow current or given window down.
    sl | shrinkleft: Shrink current or given window left.
    su | shrinkup:   Shrink current or given window up.
    h  | help:       Show this help.
EOF

    test -z $1 || exit $1
}

grow_down() {
    test $H -lt $((minH - BW)) && {
        H=$minH
    } || {
        H=$((H + minH + VGAP))
        test $((Y + H - minH - BGAP)) -gt $eSH && {
            Y=$((Y - minH - VGAP))
        }
        test $H -gt $eSH && {
            Y=$TGAP
            H=$eSH
        }
    }
}

grow_right() {
    test $W -lt $minW && {
        W=$minW
    } || {
        W=$((W + minW + IGAP))
        test $((X + W - minW - XGAP)) -gt $eSW && {
            X=$((X - minW - IGAP))
        }
        test $W -gt $eSW && {
            X=$XGAP
            W=$eSW
        }
    }
}

shrink_up() {
    test $H -le $minH && {
        H=$minH
    } || {
        H=$((H - minH - VGAP))
    }
}

shrink_left() {
    test $W -le $minW && {
        W=$minW
    } || {
        W=$((W - minW - IGAP))
    }
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $wid
}

. fyrerc.sh

wid=$PFW

case $2 in
    0x*) wid=$2 ;;
esac

case $1 in
    gd|growdown)    grow_down    ;;
    su|shrinkup)    shrink_up    ;;
    gr|growright)   grow_right   ;;
    sl|shrinkleft)  shrink_left  ;;
    *)              usage 0      ;;
esac

wtp $X $Y $W $H $wid
test "$MOUSE" = "true" && moveMouse
