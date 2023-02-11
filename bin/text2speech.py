import requests
import sys
from bs4 import BeautifulSoup as bs
import os

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    # 'Accept-Encoding': 'gzip, deflate, br',
    'Origin': 'https://readloud.net',
    'Connection': 'keep-alive',
    'Referer': 'https://readloud.net/',
    'Upgrade-Insecure-Requests': '1',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-User': '?1',
}


with open(sys.argv[1], 'r') as f:
    contents = f.read()

data = {
    'but1': contents,
    'fruits': 'Amy',
    'but': 'Submit Query',
    'butS': '0',
    'butP': '0',
    'butPauses': '0',
}

response = requests.post('https://readloud.net/', headers=headers, data=data)


soup = bs(response.content, 'html.parser')
center = soup.find('center')
ahref = center.find('a').get('href')

print(ahref)
link = f'https://readloud.net{ahref}'
os.popen(f'wget {link}')