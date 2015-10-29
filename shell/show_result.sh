#!/bin/zsh

result=$1
sort -t $'\t' -k5,5n $result | tr -d ' ' | awk -F'\t' '{print "前:"$1"\n後:"$3"\n差:"$5"\n-----"}'
