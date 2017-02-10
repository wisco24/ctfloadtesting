#!/usr/bin/env bash

# Example
# ./loginteams.sh CTFURL CTFDB SSLCERTFORCTF S3BUCKET

#Variables
ctfurl=$1
ctfdb=$2
filename=sanitizedTeamCreds
sslcert=$3
bucket=$4
teamid=10
ctffqdn="https://$ctfurl/index.php?ajax=true"

echo "Get Sanitized Creds"
./getTeamsCsv.sh $bucket
#Create Sessions and pull from MySQL DB via CTF for each login
echo "Looping creds to login"
while read line
do
    creds=(${line})
   ./teamlogin.sh $ctfurl $ctfdb $sslcert ${creds[0]} ${creds[1]}
   echo ""
done < "$filename"
sleep 10
#Remove cookie/data from session doc
awk 'NR%2==0' session.txt >> sessions.txt

sleep 5
#BRYAN SCRIPT
sed -e 's/^\(.\{32\}\).*s:2[1|2|3]:"\(.\{21,23\}\)".*;/\1,\2/' sessions.txt > sanitizedsessions.txt

#Wait for previous to finish
sleep 5
#Clean Special Characters
./getTeamSessions.sh
sleep 5
#Use Tokens to submit answers/attemps to CTF for each user
echo "Launching Answer Script"
while read line
do
    tokens=($line})
    python process_levels.py $ctfurl ${tokens[0]} ${tokens[1]} &
done < "sanitizedTeamSessions"
