#!/usr/bin/env bash

# Example
# ./teamlogin.sh CTFURL CTFDB CREDSFILE SSLCERTFORCTF

#Variables
ctfurl=$1
ctfdb=$2
sslcert=$3
login=$4
password=$5
teamid=10
ctffqdn="https://$ctfurl/index.php?ajax=true"

#Login to generate Session data
   /usr/bin/curl $ctffqdn --data "action=login_team&team_id=$teamid&teamname=$login&password=$password"
   ((teamid++))
# Login via SSH to CTF and query session data from mySQL DB
   ssh -i $sslcert ubuntu@$ctfurl "mysql -u ctf -h $ctfdb -pctf -e 'select cookie,data FROM sessions WHERE data LIKE \"%$login%\";'  fbctf" >>session.txt &