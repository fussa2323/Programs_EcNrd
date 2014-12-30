#!/usr/bin/env python
# coding: UTF-8

# 空の配列を宣言
ls = []

# ファイルを一行ずつ読み込んでStringとしてリストに格納
for line in open('../../Result/make_semantic_result/matome.txt', 'r'):
    ls.append(line)

# 文字列の重複を消して再び配列に格納
output = []
for i in ls:
    if not i in output:
        output.append(i)

# print output
f = open("../../Result/make_semantic_result/unigram_list_nrd.txt","w")
for i in range(len(output)):
	f.write(output[i])

