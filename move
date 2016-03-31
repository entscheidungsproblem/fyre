#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# move a window its width/height / snap it to edge of the screen

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [direction] <wid>
    -u | --up:    Move current or given window up.
    -l | --left:  Move current or given window left.
    -d | --down:  Move current or given window down.
    -r | --right: Move current or given window right.
    -h | --help:  Show this help.
EOF

    test $# -eq 0 || exit $1
}

moveUp() {
    test $H -le $minH && {
        test $((H % 2)) -eq 0 && {
            Y=$((Y - H - VGAP))
        } || {
            Y=$((Y - H - VGAP - 1))
        }
    } || {
        Y=$((Y - minH - VGAP))
    }

    test $Y -lt $TGAP && {
        snap --up
        exit 0
    }
}

moveLeft() {
    test $W -le $minW && {
        test $((W % 2)) -eq 0 && {
            X=$((X - W - IGAP))
        } || {
            X=$((X - W - IGAP - 1))
        }
    } || {
        X=$((X - minW - IGAP))
    }

    test $X -le $XGAP && {
        snap --left
        exit 0
    }
}

moveDown() {
    test $H -le $minH && {
        test $((H % 2)) -eq 0 && {
            Y=$((Y + H + VGAP))
        } || {
            Y=$((Y + H + VGAP + 1))
        }
    } || {
        Y=$((Y + minH + VGAP))
    }

    test $((Y + H)) -gt $eSH && {
        snap --down
        exit 0
    }
}

moveRight() {
    test $W -le $minW && {
        test $((W % 2)) -eq 0 && {
            X=$((X + W + IGAP))
        } || {
            X=$((X + W + IGAP + 1))
        }
    } || {
        X=$((X + minW + IGAP))
    }

    test $((X + W)) -gt $eSW && {
        snap --right
        exit 0
    }
}

moveMouse() {
    . mouse

    mouseStatus=$(getMouseStatus)
    test $mouseStatus -eq 1 && moveMouseEnabled "$wid"
}

main() {
    . fyrerc

    wattr "$2" && wid="$2" || wid="$PFW"

    case "$1" in
        "-u"|"--up")    moveUp    ;;
        "-l"|"--left")  moveLeft  ;;
        "-d"|"--down")  moveDown  ;;
        "-r"|"--right") moveRight ;;
    esac

    wtp $X $Y $W $H "$wid"
    test "$MOUSE" = "true" && moveMouse
}

test $# -eq 0 && usage 1

for arg in $ARGS; do
    case "$arg" in
        -q|--quiet)       QUIETFLAG=true ;;
        h|help|-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}