#!/bin/sh
mv bashrc ~/.bashrc
mv ssr_check.sh ~/ssr_check.sh
./initmudbjson.sh
./logrun.sh
cd ~
source .bashrc
a 10000
