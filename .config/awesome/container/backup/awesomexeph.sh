#!/bin/bash

TMP="$(mktemp -d)"
LOG="$TMP/stdout.log"
LOG_ERROR="$TMP/stderr.log"

truncate --size 0 "$LOG" "$LOG_ERROR"

tail -f "$LOG" > /dev/stdout &
tail -f "$LOG_ERROR" > /dev/stderr &

DP_NUM=1
DP=":$DP_NUM"

trap "rm -r $TMP" SIGINT SIGTERM EXIT SIGKILL
trap '[ -n "$(jobs -p)" ] && kill $(jobs -p) 2>/dev/null' SIGINT SIGTERM EXIT SIGKILL

ln -s `pwd` "$TMP/awesome"

Xephyr "$DP" -s 10000 -ac -noreset -screen 1280x720 > "$LOG" 2> "$LOG_ERROR" &

# Need to wait for Xehpyr display to become available
while [ ! -e /tmp/.X11-unix/X${DP_NUM} ] ; do
    sleep 0.1
done

export DEBUG="true"
export XDG_CONFIG_HOME="$TMP"
export DISPLAY="$DP.0"

awesome -c "$TMP/awesome/rc.lua" > "$LOG" 2> "$LOG_ERROR" &
WM_PID="$!"

# Debounce interval in seconds
interval=1
(( limit = $(date +"%s") + interval ))
inotifywait -r -m -e close_write --exclude 'index.lock|run.sh|.git' . | while read dir events f
do
    if (( limit < $(date +"%s") )); then
        (( limit = $(date +"%s") + interval ))
        echo "Changed '$f'. Reloading... " > "$LOG"
        kill -HUP "$WM_PID"
    else
        echo "Waiting ${interval}s..." > "$LOG"
    fi
done
