#!/bin/bash

mkdir $1
sed -e "s/, '/,'/g" results.csv > TMP; mv TMP results.csv
