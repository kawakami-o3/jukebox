#!/bin/bash
set -x
#gcc volume.m -lobjc -static -I/usr/include/GNUstep -L/usr/lib/GNUstep -lgnustep-base -fconstant-string-class=NSConstantString


cc JukeboxMessed.m -lobjc \
	-framework Foundation \
	&& ./a.out
