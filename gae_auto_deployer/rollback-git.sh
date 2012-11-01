#!/usr/bin/expect 
set timeout 60
spawn git push origin +master 
expect "*?sername:*" 
send -- "GIT_USERNAME\r" 
expect "*?assword:*" 
send -- "GIT_PASSWORD\r" 
expect eof
