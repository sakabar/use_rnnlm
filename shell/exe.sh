#!/bin/zsh

set -ue

function juman_wakati(){
  cat - | juman | grep -v "^@" | awk '{print $1}' | tr '\n' ' ' | sed -e 's/ EOS /\n/g'
}

if [ ! -e data/orig.txt ]; then
  echo "Not found: data/orig.txt"
  exit 1
fi

if [ ! -e data/changed.txt ]; then
  echo "Not found: data/changed.txt"
  exit 1
fi

if [ ! -e model10000k/model ]; then
  echo "Not found: model"
  echo "execute shell/setup.sh"
  exit 1
fi

#分かち書きの後、<unk>を置換してテストデータ作成
files=("data/orig.txt" "data/changed.txt")
for f in $files; do
  # lv $f | juman_wakati > jumanwakati/$f:t:r".jumanwakati"
   lv $f | juman_wakati | python src/make_test_data.py  > testdata/$f:t:r".jumanwakati"
done

#RNNLMでテスト
testfiles=("testdata/orig.jumanwakati" "testdata/changed.jumanwakati")
for f in $testfiles; do
  shell/test.sh $f
done

#結果を1つのファイルに結合
paste -d '\t' result/orig.result result/changed.result| awk -F'\t' '{print $0"\t"$4/$2}' > result/result.txt

#結果を整形
./shell/show_result.sh result/result.txt > result/result.format.txt
