#!/bin/sh
cur_dir=$(pwd)
sec_file=$cur_dir/mysec
cp $sec_file ${sec_file}.bak 
cat $cur_dir/superadmin > $cur_dir/mysec
#python /home/vpnuser/mksec.py >> /home/vpnuser/mysec
#diff /home/vpnuser/mysec /home/vpnuser/mysec.bak > /dev/null
#v1=$?
#if [ $v1 -ne 0 ]; then
#	cp /home/vpnuser/mysec /etc/ppp/chap-secrets
#fi
