#!/bin/sh
# synthesizes a batch of MIDI files in non-real time
for FILE in data/midi/*.mid
do
  # remove path and file extension
  NAME=$(basename "${FILE%.*}")
  # process file using mid2wav.ck in silent mode
  chuck ChucK/mid2wav.ck:$NAME -s
done
