#!/usr/bin/env bash

SRC=$1
SRC2=$2
DEST_INC=$3

# Copy all headers to devel/include
for i in $(find $SRC -name *.h); do
	F=$DEST_INC/${i##$SRC}
	mkdir -p $(dirname $F)
	cp $i $F
done

for i in $(find $SRC2 -name *.h); do
	F=$DEST_INC/${i##$SRC2}
	mkdir -p $(dirname $F)
	cp $i $F
done
