#!/bin/bash
bucket=${1}
filename=teamsessions
sanitizedFilename=sanitizedTeamSessions

tail -n +2 sanitizedsessions.txt | awk -F "," '{print $1 " " $2}' > ${filename}
sed -e "s///" ${filename} > ${sanitizedFilename}
rm ${filename}
echo ${sanitizedFilename}
