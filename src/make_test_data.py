#coding:utf-8
import sys
import os

#テストデータを作成する
#訓練データで出現回数が一回しかないトークンを<unk>に置き換える

#たなしゅんのmkunktest.pyがこれに対応するコードだろうけど、得体が知れないので自分で書き直す
#もし時間かかりすぎるならリユーズを検討しよう

def replace_with_unk(vocab_dict, word):
    if word in vocab_dict:
        if vocab_dict[word] <= 1:
            return "<unk>"
        else:
            return word
    else:
        return "<unk>"

def main():
    vocab_dict = {}
    base = os.path.dirname(os.path.abspath(__file__))
    vocab_file = os.path.normpath(os.path.join(base, '../model10000k/uniqtrain10000k.txt'))

    with open(vocab_file, 'r') as voc:
        for line in voc:
            line = line.rstrip()
            lst = line.split()
            vocab_dict[lst[1]] = int(lst[0])
 
    #標準入力からJumanで分かち書きしたファイルを読み込み、訓練データ中で1回しか出現しなかった単語を<unk>に置き換える
    for line in sys.stdin:
        line = line.rstrip()
        words = line.split(' ')
        print ' '.join([replace_with_unk(vocab_dict, word) for word in words])

if __name__ == '__main__':
    main()
