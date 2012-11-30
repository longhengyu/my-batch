#!/bin/sh

sec_dir=/etc/ppp
work_dir=$(pwd)
service="http://dream-pkg.cloudfoundry.com/secure/chapSec"
secKey="abcdefg"
hostname=$(hostname)

requestUrl="${server}/${secKey}/${hostname}"

cd $work_dir
cp $hostname ${hostname}.backup
wget requestUrl
diff $hostname ${hostname}.backup > /dev/null
v1=$?
if [ $v1 -ne 0 ]; then
	cp $hostname ${sec/dir}/chap-secrets
fi
