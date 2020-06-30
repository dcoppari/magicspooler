#!/bin/sh

if [ $# != 2 ]; then
    echo "NOK Arguments Missmatch"
    exit 1;
fi

tmpdir=$(mktemp -d)

cd $tmpdir

case "$1" in

    --chrome-to-pdf)
        /opt/google/chrome-beta/google-chrome-beta \
        --headless \
        --no-sandbox \
        --disable-gpu \
        --run-all-compositor-stages-before-draw \
        --print-to-pdf \
        "$2" >/dev/null 2>&1
        RESULT="$tmpdir/output.pdf"
        ;;

    --chrome-to-png)
        /opt/google/chrome-beta/google-chrome-beta \
        --headless \
        --no-sandbox \
        --disable-gpu \
        --run-all-compositor-stages-before-draw \
        --screenshot --window-size=1280,1696 \
        "$2" >/dev/null 2>&1
        RESULT="$tmpdir/screenshot.png"
        ;;

    --office-to-pdf)
        SOURCEFILE=$(basename "$2")
        RESULT="$tmpdir/${SOURCEFILE%.*}.pdf"

        /usr/bin/libreoffice \
        --headless \
        --convert-to pdf \
        --outdir $tmpdir \
        "$2" >/dev/null 2>&1
        ;;

    --pcl-to-pdf)
        SOURCEFILE=$(basename "$2")
        RESULT="$tmpdir/${SOURCEFILE%.*}.pdf"

        unix2dos "$2"
        /usr/local/bin/pcl6 \
        -dNOPAUSE \
        -dQUIET \
        -dBATCH \
        -dEPSFitPage \
        -sstdout=/dev/null \
        -sDEVICE=pdfwrite \
        -sOutputFile="$RESULT"
        "$2" >/dev/null 2>&1
        ;;

    *)
        echo "NOK Bad Arguments"
        exit 1
        ;;

esac

if [ -f "$RESULT" ]; then
    echo "OK $RESULT"
else
    echo "NOK Error generating file"
fi
