#!/usr/bin/env bash

# Example
# ./loginteams.sh CTFURL CTFDB CREDSFILE SSLCERTFORCTF


ctfurl=$1
ctfdb=$2
filename=$3
sslcert=$4
teamid=10
ctffqdn="https://$ctfurl/index.php?ajax=true"
useragent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0"
echo "Looping creds to login"
while read line
do
    creds=(${line})
   /usr/bin/curl $ctffqdn --data "action=login_team&team_id=$teamid&teamname=${creds[0]}&password=${creds[1]}"
   ((teamid++))
   echo ""
done < "$filename"

while read line
do
   creds=(${line})
   ssh -i $sslcert ubuntu@$ctfurl "mysql -u ctf -h $ctfdb -pctf -e 'select cookie,data FROM sessions WHERE data LIKE \"%${creds[0]}%\";'  fbctf" >>session.txt &
done < "$filename"


awk 'NR%2==0' session.txt >> sessions.txt
