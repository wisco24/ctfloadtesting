#!/usr/bin/env bash
ctfurl=$1
echo "Launching Answer Script"
while read line
do
    tokens=($line)
     python process_levels.py $ctfurl ${tokens[0]} ${tokens[1]}
done < "sanitizedTeamSessions"
