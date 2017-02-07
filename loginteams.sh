#!/usr/bin/env bash

# Example
# ./loginteams.sh CTFURL CTFDB CREDSFILE SSLCERTFORCTF

#Variables
ctfurl=$1
ctfdb=$2
filename=$3
sslcert=$4
teamid=10
ctffqdn="https://$ctfurl/index.php?ajax=true"

#Create Sessions and pull from MySQL DB via CTF for each login
echo "Looping creds to login"
while read line
do
    creds=(${line})
    teamlogin.sh $ctfurl $ctfdb $sslcert ${creds[0]} ${creds[1]}
   echo ""
done < "$filename"

#Remove cookie/data from session doc
awk 'NR%2==0' session.txt >> sessions.txt


#BRYAN SCRIPT

#Use Tokens to submit answers/attemps to CTF for each user
echo "Launching Answer Script"
while read line
do
    tokens=($line})
    python process_levels.py $ctfurl ${tokens[1]} ${tokens[0]} &
done < "sessions.txt"