#!/bin/zsh

#<unk>に置き換え済みの、testdataのファイルを引数にとる

filename=$1 #jumanwakati/changed.jumanwakati
lv $filename | python src/calc_unigram_log_prob.py > result/$filename:t:r".unigram.result"
rnnlm -test $filename -rnnlm model10000k/model -lambda 0.5 -nbest | grep "^-[0-9]*\.[0-9]*" > result/$filename:r:t".rnnlm.result"

#RNNLMの対数確率からユニグラムの対数確率を引いて、acceptabilityを求める
paste -d '\t' result/$filename:t:r".unigram.result" result/$filename:t:r".rnnlm.result" | awk -F'\t' '{p = $3-$2; print $1"\t"p}' > result/$filename:t:r".result"
