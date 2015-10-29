#!/bin/zsh

set -ue

if [ $# -eq 1 ]; then
  outputdir=$1
elif [ $# -eq 0 ]; then
  outputdir=.
else
  echo "argument error"
  exit 1
fi

function juman_wakati(){
  cat - | juman | grep -v "^@" | awk '{print $1}' | tr '\n' ' ' | sed -e 's/ EOS /\n/g'
}

if [ ! -e $outputdir/data/orig.txt ]; then
  echo "Not found: $outputdir/data/orig.txt"
  exit 1
fi

if [ ! -e $outputdir/data/changed.txt ]; then
  echo "Not found: $outputdir/data/changed.txt"
  exit 1
fi

if [ ! -e model10000k/model ]; then
  echo "Not found: model"
  echo "execute shell/setup.sh"
  exit 1
fi

#分かち書きの後、<unk>を置換してテストデータ作成
files=("$outputdir/data/orig.txt" "$outputdir/data/changed.txt")
for f in $files; do
   lv $f | juman_wakati | python src/make_test_data.py  > $outputdir/testdata/$f:t:r".jumanwakati"
done

#RNNLMでテスト
testfiles=("$outputdir/testdata/orig.jumanwakati" "$outputdir/testdata/changed.jumanwakati")
for f in $testfiles; do
  shell/test.sh $f $outputdir
done

#結果を1つのファイルに結合
paste -d '\t' $outputdir/result/orig.result $outputdir/result/changed.result| awk -F'\t' '{print $0"\t"$4-$2}' > $outputdir/result/result.txt

#結果を整形
./shell/show_result.sh $outputdir/result/result.txt > $outputdir/result/result.format.txt
