#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# test window classes when being opened

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [wid]
EOF

    test $# -eq 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        0x*) wid=$1  ;;
        *)   usage 0 ;;
    esac

    windowName=$(name $wid)
    windowClass=$(class $wid)

    setborder.sh active $wid

    case "$windowName" in
        "urxvt")
            position.sh res $wid
            snap.sh tl $wid
            ;;
        "mosh")
            position.sh res $wid
            position.sh ext $wid
            snap.sh tl $wid
            windows.sh -a $wid 3
            ;;
        "tmux")
            position.sh res $wid
            position.sh ext $wid
            snap.sh tl $wid
            windows.sh -a $wid 1
            ;;
        "mpsyt")
            position.sh res $wid
            position.sh ext $wid
            snap.sh right $wid
            windows.sh -a $wid 9
            ;;
        "alsamixer")
            position.sh quar $wid
            snap.sh md $wid
            ;;
        "Legions.exe")
            windows.sh -a $wid 6
            ;;
        *)
            case "$windowClass" in
                "google-chrome")
                    wtp $(($(wattr x $wid) - BW)) $(($(wattr y $wid) - BW)) \
                        $(wattr wh $wid) $wid
                    windows.sh -a $wid 2
                    ;;
                "mpv")
                    windows.sh -a $wid 5
                    ;;
                "TeamSpeak 3")
                    snap.sh md $wid
                    windows.sh -a $wid 4
                    ;;
                # seriously fuck this program
                "telegram")
                    windows.sh -a $wid 4
                    ;;
                "MuPDF")
                    snap.sh md $wid
                    windows.sh -a $wid 6
                    ;;
                *)
                    snap.sh md $wid
                    ;;
            esac
            ;;
    esac

}

main $ARGS
