import csv
import requests
import sys

hostname = sys.argv[1]
csrf_token = sys.argv[2]
session = sys.argv[3]
url = "https://" + hostname + "/index.php?p=game&ajax=true"
user = "Tester1"
password = "Tester1234"

def login():
    s = requests.Session()
    uri = url + '/index.php?ajax=true'
    data = {
        'action': 'login_team',
        'team_id': '2',
        'teamname': 'eshulze',
        'password': 'Password123',
    }
    r = s.post(uri, data=data, verify=verify)
    res = json.loads(r.content)
    if res['result'] == 'OK':
        print '[+] Logged in successfully'
    else:
        print '[!] Log in failed, exiting'
        exit(1)

    return s


headers =  {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',\
            'Accept': '*/*', 'Connection': 'keep-alive', 'Accept-Encoding': 'gzip, deflate',\
            'Origin': 'https://' + hostname, \
            'Cookie': 'Leaderboard=close;  Announcements=close; Activity=close; Teams=close; Filter=close; Game Clock=close; FBCTF={}'.format(session)}


with open('level.csv') as csvfile:
    reader = csv.DictReader(csvfile)

    for index, row in enumerate(reader):
        flag = row['Answer']
        level_id = row['Level_ID']
        params = {'csrf_token': csrf_token, 'action':'answer_level', 'level_id': level_id, 'answer': flag}
        r = requests.post(url, verify=True, headers=headers, data=params)
        print(r.content)
