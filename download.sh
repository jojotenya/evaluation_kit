#!/bin/bash

# make needed dirs
./make_dirs.sh

# download data and models
data_path="data/"
model_path="saved_model/"
dict_fasttext=$data_path"dict_fasttext.txt.gz","1jk6pjs535ujn4SQkK5GTwy_LWaLbyMto"
sentiment_mapping=$data_path"mapping","1Jl8TURNKydbgw01QuAljOEX4tsHjAcjP"
lm_mapping=$data_path"words_char.json.gz","1iMD5KAgH4Ro8JqLo_V3XCGLGwz9nsTaw"
#coh1=$model_path"/coh1/coh2_20181021.tar.gz","1rJUDPJ8nng-vKUNuaSbSGlz1Ye05qOj4"
coh2_model=$model_path"/coh2/coh2.tar.gz","1rJUDPJ8nng-vKUNuaSbSGlz1Ye05qOj4"
lm_model=$model_path"LM/LM.tar.gz","16vZJvf5_NqFabcKITOjyVYeAKfryb6Ei"
sent_model=$model_path"sentiment_analysis/sentiment.zip","1oA9WuYa-jHCimMYRElC7qVuOggrBdaE9"


files_arr=($dict_fasttext $sentiment_mapping $lm_mapping)
for f in ${files_arr[@]}; do
    IFS=',' read filename fileid <<< "${f}"
    curl -L -o "${filename}" "https://drive.google.com/uc?export=download&id=${fileid}"
    echo "${filename}" ":" "${fileid} downloaded!"
    if [[ ${filename} = *"zip"* ]]; then
        unzip ${filename}
        rm ${filename}
    elif [[ ${filename} = *"gz"* ]]; then
        gunzip ${filename}
    elif [[ ${filename} = *".tar.bz"* ]]; then
        tar jxvf ${filename}
        rm ${filename} --strip 1
    elif [[ ${filename} = *".tar.gz"* ]]; then
        tar zxvf ${filename} --strip 1
        rm ${filename}
    fi
done

# download fasttext model
filename=$data_path"cc.zh.300.bin.gz"
wget -O $filename https://s3-us-west-1.amazonaws.com/fasttext-vectors/word-vectors-v2/cc.zh.300.bin.gz
gunzip $filename

# build soft link
data_path="data/"
fasttext_model=$PWD/$data_path"cc.zh.300.bin"
dict_fasttext=$PWD/$data_path"dict_fasttext.txt"
test_raw=$PWD/$data_path"test_raw.csv"
echo $test_raw
sentiment_mapping=$PWD/$data_path"mapping"
echo $sentiment_mapping
lm_mapping=$PWD/$data_path"words_char.json"
ln -s $dict_fasttext coh1/;
ln -s $test_raw coh1/corpus/;
ln -s $dict_fasttext coh2/data/;
ln -s $fasttext_model coh2/data/;
ln -s $test_raw coh2/data/;
ln -s $dict_fasttext LM/data/;
ln -s $test_raw LM/data/;
ln -s $lm_mapping LM/data/;
ln -s $test_raw sentiment_analysis/corpus/;
ln -s $sentiment_mapping sentiment_analysis/corpus/;
