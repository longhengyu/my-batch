#!/usr/bin/expect 
spawn git push origin +master 
expect "*?sername:*" 
send -- "GITUSER\r" 
expect "*?assword:*" 
send -- "GITPASS\r" 
expect eof
