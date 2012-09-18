#!/bin/sh
nowtimemilsec=`date +%s`
output=`echo $(pwd)/output_$nowtimemilsec`
python run.py > $output
sort $output | uniq > output
rm $output
