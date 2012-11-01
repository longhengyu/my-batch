#!/usr/bin/expect 
set timeout 60
spawn git push origin +master 
expect "*?sername:*" 
send -- "username\r" 
expect "*?assword:*" 
send -- "password\r" 
expect eof
