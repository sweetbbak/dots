#!/bin/bash

INCREMENT=10
MINIMUM=10
MAXIMUM=100

brightness=$(brightnessctl | grep -o "(.*)" | tr -d "()" | cut -d ":" -f2 | sed 's/%//g')
echo "$brightness"


if test "_$1" = "_--brighter" ; then
  brightness=$(( brightness + INCREMENT ))
fi

if test "_$1" = "_--dimmer" ; then
   brightness=$(( brightness - INCREMENT ))
fi

if test "$brightness" -lt "$MINIMUM" ; then
  brightness=$MINIMUM
fi

if test "$brightness" -gt "$MAXIMUM" ; then
  brightness=$MAXIMUM
fi

brightnessctl s "${brightness}"%