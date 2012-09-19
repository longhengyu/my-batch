#!/usr/bin/expect 
set timeout 120
spawn mvn gae:deploy
expect "*Email:*" 
send -- "GAE_USERNAME\r" 
expect "*?assword for*" 
send -- "GAE_PASSWORD\r" 
expect eof
