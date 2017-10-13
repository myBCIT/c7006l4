#!/bin/bash
cfg=$PWD/$1.cfg

echo $cfg
user=$(awk '$1 ~ /user/ { print $2 }' $cfg)
pass=$(awk '$1 ~ /pass/ { print $2 }' $cfg)
host=$(awk '$1 ~ /host/ { print $2 }' $cfg)
echo $user $pass $host

