#!/bin/bash

FEATURE_FILE=analysis_inputs/features__mfcc.h5f
ITEM_FILE=analysis_inputs/item___for_h5f.item

TASK_FILE=$DIR/$BASENAME.task
DISTANCE_FILE=$DIR/$BASENAME.distance
SCORE_FILE=$DIR/$BASENAME.score

RESULTS_FILE=$DIR/$BASENAME.csv

abx-task $ITEM_FILE $TASK_FILE --on type --by place speaker question position-wd following-v
abx-distance $FEATURE_FILE $TASK_FILE $DISTANCE_FILE --normalization 1 --njobs 1
abx-score $TASK_FILE $DISTANCE_FILE $SCORE_FILE
abx-analyze $SCORE_FILE $TASK_FILE $RESULTS_FILE
