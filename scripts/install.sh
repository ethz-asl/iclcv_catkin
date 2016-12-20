#!/usr/bin/env bash

SRC=$1
SRC2=$2
DEST_INC=$3
echo "#####################"
echo $(find $SRC -name *.h)
echo "#####################"
echo $(find $SRC2 -name *.h)

# Copy all headers to devel/include
for i in $(find $SRC -name *.h); do
  echo ${i}
	F=$DEST_INC/${i##$SRC}
	mkdir -p $(dirname $F)
	cp $i $F
done

for i in $(find $SRC2 -name *.h); do
  echo ${i}
	F=$DEST_INC/${i##$SRC2}
	mkdir -p $(dirname $F)
	cp $i $F
done
