#!/bin/bash

INCREMENT=50
MINIMUM=1
MAXIMUM=$(</sys/class/backlight/intel_backlight/max_brightness)

brightness=$(</sys/class/backlight/intel_backlight/brightness)

let brightness/=$INCREMENT
let brightness*=$INCREMENT

if test "_$1" = "_--brighter" ; then
  let brightness+=$INCREMENT
fi

if test "_$1" = "_--dimmer" ; then
  let brightness-=$INCREMENT
fi

if test $brightness -lt $MINIMUM ; then
  brightness=$MINIMUM
fi

if test $brightness -gt $MAXIMUM ; then
  brightness=$MAXIMUM
fi

echo $brightness > /sys/class/backlight/intel_backlight/brightness
