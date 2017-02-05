#!/usr/bin/env bash
ctfurl=$1
filename=$2
teamid=10
ctfurl="https://$ctfurl/index.php?ajax=true"
useragent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0"
echo "Looping creds to login"
while read line
do
    creds=(${line})
    echo '/usr/bin/curl $ctfurl --data "action=login_team&team_id=$teamid&teamname=${creds[0]}&password=${creds[1]}"'
    ((teamid++))
    echo ""
done < "$filename"

echo "Writing Tokens to File"
while read line
do
    creds=(${line})
    echo 'mysql -u ctf -h ctfrds-cluster.cluster-cmrmp3qxqcap.ap-northeast-1.rds.amazonaws.com -pctf -e 'select cookie,data FROM sessions WHERE data LIKE "%${creds[0]}%";'  fbctf >>output.txt'
done < "$filename"


#curl https://ctf.jpskotest.trenddemos.com/index.php?ajax=true --data "action=login_team&team_id=2&teamname=Tester9&password=Tester1234"
