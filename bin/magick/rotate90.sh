#!/bin/bash

DIRECTION="$1"
shift

case "$DIRECTION" in
  "r")
    while (( "$#" )); do
      convert -rotate 90 -quality 100 "$1" "$1" 
      shift
    done
  ;;
  "l")
    while (( "$#" )); do
      convert -rotate -90 -quality 100 "$1" "$1"
      shift
    done
  ;;
esac

exit 0
