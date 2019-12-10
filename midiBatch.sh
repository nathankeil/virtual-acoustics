#!/bin/sh
# synthesizes a batch of MIDI files in non-real time
for FILE in *.mid
do
  # remove file extension
  NAME="${FILE%.*}"
  # process file using mid2wav.ck in silent mode
  chuck mid2wav.ck:$NAME -s
done
