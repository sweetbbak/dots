#!/bin/bash
#

sources='Manganato'

query=$(mangal inline -j -S ${sources} -q "$1")

results=$()
