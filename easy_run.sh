#!/bin/sh
mv bashrc ~/.bashrc
mv ssr_check.sh ~/ssr_check.sh
./initmudbjson.sh
./logrun.sh
source ~/.bashrc
cd ~
a 10000
