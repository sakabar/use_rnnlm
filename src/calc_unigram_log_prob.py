#coding:utf-8
import sys
import math
import os

#<unk>置換済みの分かち書きされたファイルを標準入力から受け取り、
#元文とユニグラムの対数確率を計算して返す (タブ区切り)

def main():
    unigram_dic = {}
    unigram_dic["<unk>"] = 0
    base = os.path.dirname(os.path.abspath(__file__))
    unigram_file = os.path.normpath(os.path.join(base, '../model10000k/uniqtrain10000k.txt'))
    vocab_num = 1.0 #全単語数(unkは一単語扱い、つまり、頻度1の語がいくらあっても、それらは<unk>となり、語彙数は1しか増やさない。簡単のため、あらかじめvocab_numに足しておく)
    with open(unigram_file, 'r') as unigram_file:
        for line in unigram_file:
            line = line.rstrip()
            lst = line.split(' ')
            cnt = int(lst[0])
            key = lst[1]

            #未知語のとき
            if cnt <= 1:
                unigram_dic["<unk>"] += 1
                #あらかじめ、<unk>のぶんの値を考えてvocab_numを1に初期化しているので、
                #ここで加算することはない

            #既知語のとき
            else:
                unigram_dic[key] = cnt
                vocab_num += 1

                
    for line in sys.stdin:
        line = line.rstrip()
        words = line.split(' ')
        for word in words:
            if unigram_dic[word] == 0:
                raise Exception(word)

        unigram_log_p = sum([math.log10(unigram_dic[word]) - math.log10(vocab_num) for word in words])
        print line + "\t" + str(unigram_log_p)
            
    return

if __name__ == '__main__':
    main()
