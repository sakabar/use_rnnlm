#!/bin/zsh

#第一引数として、<unk>に置き換え済みの、testdataのファイルを引数にとる(orig.jumanwakatiなど)
#第二引数として、出力先のディレクトリを引数にとる

if [ $# -eq 2 ]; then
  juman_wakati_file_name=$1
  outputdir=$2
elif [ $# -eq 1 ]; then
  juman_wakati_file_name=$1
  outputdir=.
else
  echo "argument error"
  exit 1
fi

lv $juman_wakati_file_name | python src/calc_unigram_log_prob.py > $outputdir/result/$juman_wakati_file_name:t:r".unigram.result"
rnnlm -test $juman_wakati_file_name -rnnlm model10000k/model -lambda 0.5 -nbest | grep "^-[0-9]*\.[0-9]*" > $outputdir/result/$juman_wakati_file_name:r:t".rnnlm.result"

#RNNLMの対数確率からユニグラムの対数確率を引いて、その値を文のトークン数で除算(正規化)し、acceptabilityを求める
#便宜的に、RNNLMとユニグラムの対数確率をそれぞれ正規化した後で、減算する
paste -d '\t' $outputdir/result/$juman_wakati_file_name:t:r".unigram.result" $outputdir/result/$juman_wakati_file_name:t:r".rnnlm.result" | awk -F'\t' '{p = $3-$2; print $1"\t"p}' | awk -F'\t' -f shell/normalize.awk > $outputdir/result/$juman_wakati_file_name:t:r".result"
