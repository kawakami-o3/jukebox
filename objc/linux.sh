#!/bin/bash
set -x
#gcc volume.m -lobjc -static -I/usr/include/GNUstep -L/usr/lib/GNUstep -lgnustep-base -fconstant-string-class=NSConstantString


cc JukeboxMessed.m -lobjc -std=c99\
 	-I/usr/include/GNUstep -L/usr/lib \
 	-fconstant-string-class=NSConstantString \
 	-lgnustep-base \
	-D_NATIVE_OBJC_EXCEPTIONS \
	&& ./a.out
