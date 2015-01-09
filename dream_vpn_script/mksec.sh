#!/bin/sh

sec_dir=/etc/ppp
work_dir=$(pwd)
service="http://dream-vpn.com/secure/chapSec"
secKey="abcdefg"
hostname=$(hostname)

requestUrl="${service}/${secKey}/${hostname}"

cd $work_dir
cp ${sec_dir}/chap-secrets ${hostname}.backup
wget $requestUrl -O $hostname
read -r format < vps001.backup
read -r header < vps001

if [ "$header" != "$format" ]; then
        exit 1
fi

cat master >> $hostname
diff $hostname ${hostname}.backup > /dev/null
v1=$?
if [ $v1 -ne 0 ]; then
    cp $hostname ${sec_dir}/chap-secrets
    cp $hostname.backup $work_dir/backup/$hostname.backup.$(date +"%Y%m%d-%H%M%S")
fi

