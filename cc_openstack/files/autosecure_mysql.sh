#!/bin/bash

expect -c "

spawn mysql_secure_installation

# enter root password
expect \"Enter current password for root (enter for none):\"
send \"tobias1234\r\"

# change root password?
expect -exact \"\]\"
send \"n\r\"

# remove anonymous user?
expect -exact \"\]\"
send \"y\r\"

# disallow root login remotely
expect -exact \"\]\"
send \"n\r\"

# remove test databases?
expect -exact \"\]\"
send \"y\r\"

# reload privileges table
expect -exact \"\]\"
send \"y\r\"

expect -exact \".\"

"

touch done.ran



