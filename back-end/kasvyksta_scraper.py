from bs4 import BeautifulSoup
from urllib.request import urlopen
import psycopg2
from db_connect import connect

def scrape():
    conn = connect()
    cur = conn.cursor()
    cur.execute('SET client_encoding TO \'UTF8\';')
    conn.commit()

    lst = []

    url = "https://renginiai.kasvyksta.lt/lietuva"
    page = urlopen(url)
    html = page.read().decode("utf-8")
    soup = BeautifulSoup(html, "html.parser")

    rows = soup.find_all("div", {"class": "block event-block"})

    for row in rows:

        loc = row.find("div", itemprop="location")
        meta = loc.find_all("meta")

        locationData = []
        for data in meta:
            locationData.append(data["content"])

        eventName = row.find(itemprop ='name').string
        placeName=locationData[0]
        link=locationData[1]
        address=locationData[2]
        city=locationData[3]
        startDate = row.find("meta", itemprop="startDate")["content"]

        '''print(eventName)
        print(placeName)
        print(link)
        print(address)
        print(city)
        print(startDate)
        print("")'''

        lst.append((eventName, placeName, link, address, city, startDate))

        sql = "INSERT INTO events(event_name, place_name, link, address, city, start_date) \
        VALUES (%s,%s,%s,%s,%s,%s) RETURNING event_id;"

        cur.execute(sql, (eventName, placeName, link, address, city, startDate))
        id = cur.fetchone()[0]

        '''print("id from db: ", id)
        print("")'''

        conn.commit()

    #print(lst)
    conn.close()
