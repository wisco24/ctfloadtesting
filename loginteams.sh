#!/usr/bin/env bash

# Example
# ./loginteams.sh CTFURL CTFDB SSLCERTFORCTF S3BUCKET

#Variables
ctfurl=$1
ctfdb=$2
filename=sanitizedTeamCreds
sslcert=$4
bucket=$5
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

#Remove cookie/data from session doc
awk 'NR%2==0' session.txt >> sessions.txt


#BRYAN SCRIPT
cat sessions.txt | sed -r 's/^(.{32}).*:22:"([0-9a-zA-Z]{0,22}).*/\1,\2/'

#Use Tokens to submit answers/attemps to CTF for each user
echo "Launching Answer Script"
while read line
do
    tokens=($line})
    python process_levels.py $ctfurl ${tokens[1]} ${tokens[0]} &
done < "sessions.txt"
