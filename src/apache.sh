#!/bin/bash

if [ -n "$1" ]
then 
	cfg=$PWD/$1.cfg
	echo $cfg
else
	echo "using default config"
	cfg=$PWD/apache.cfg
	echo $cfg
fi



user=$(awk '$1 ~ /user/ { print $2 }' $cfg)
pass=$(awk '$1 ~ /pass/ { print $2 }' $cfg)
host=$(awk '$1 ~ /host/ { print $2 }' $cfg)
file=$(awk '$1 ~ /file/ { print $2 }' $cfg)
echo $user $pass $host $file
