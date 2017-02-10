import csv
import requests
import sys

#Process Variables from Script Parameters
hostname = sys.argv[1]
csrf_token = sys.argv[3]
session = sys.argv[2]
url = "https://" + hostname + "/index.php?p=game&ajax=true"

#Header Data for CTF
headers =  {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',\
            'Accept': '*/*', 'Connection': 'keep-alive', 'Accept-Encoding': 'gzip, deflate',\
            'Origin': 'https://' + hostname, \
            'Cookie': 'Leaderboard=close;  Announcements=close; Activity=close; Teams=close; Filter=close; Game Clock=close; FBCTF={}'.format(session)}

#Loop through level.csv to try each attempt in file as user tokens provived in parameters
with open('level.csv') as csvfile:
    reader = csv.DictReader(csvfile)

    for index, row in enumerate(reader):
        flag = row['Answer']
        level_id = row['Level_ID']
        params = {'csrf_token': csrf_token, 'action':'answer_level', 'level_id': level_id, 'answer': flag}
        r = requests.post(url, verify=True, headers=headers, data=params)
        print(r.content)
