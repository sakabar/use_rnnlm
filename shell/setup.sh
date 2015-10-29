#!/bin/zsh

cat model10000k/model_splitted_* > model10000k/model

if [ $# -eq 1 ]; then
  outputdir=$1
  mkdir $outputdir
  mkdir $outputdir/data
  mkdir $outputdir/result
  mkdir $outputdir/testdata
elif [ $# -eq 0 ]; then
  #Do nothing
else
  echo "argument error"
  exit 1
fi
