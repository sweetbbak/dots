#!/bin/bash
agent='"Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"'
wget --no-check-certificate -U "$agent" "$1" -q -O - | grep -Po "(?<=href=\")[^^\"]*" | grep chapter
