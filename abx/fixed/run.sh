#!/bin/bash

FEATURE_FILE=../mono_mfcc.h5f
ITEM_FILE=abx.item

TASK_FILE=abx.task
DISTANCE_FILE=abx.distance
SCORE_FILE=abx.score

RESULTS_FILE=results.csv
OUTPUT_TXT=distance.txt


abx-task $ITEM_FILE $TASK_FILE --on pulm --by place speaker question position vowel && \
  abx-distance $FEATURE_FILE $TASK_FILE $DISTANCE_FILE --normalization 1 --njobs 1 && \
  abx-score $TASK_FILE $DISTANCE_FILE $SCORE_FILE && \
  abx-analyze $SCORE_FILE $TASK_FILE $RESULTS_FILE && \
  rm -f $OUTPUT_TXT && \
  python ../dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT


