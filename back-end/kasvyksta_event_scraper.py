from bs4 import BeautifulSoup
from urllib.request import urlopen
import psycopg2
from db_connect import connect
import time
from threading import Thread

class KasVykstaEventScraper(Thread):

    def __init__(self):
        Thread.__init__(self)

    def run(self):
        while 1:
            print('*KasVykstaEventScraper is connecting to the PostgreSQL database...')
            conn = connect()
            cur = conn.cursor()

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
                public = "true";
                user_added_id = "-1";

                '''print(eventName)
                print(placeName)
                print(link)
                print(address)
                print(city)
                print(startDate)
                print("")'''

                lst.append((eventName, placeName, link, address, city, startDate, public, user_added_id))

                sql = "INSERT INTO events(event_name, place_name, link, address, city, start_date, public, user_added_id) \
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s) RETURNING event_id;"

                try:
                    cur.execute(sql, (eventName, placeName, link, address, city, startDate, public, user_added_id))
                    id = cur.fetchone()[0]

                    print("Created event. id from db: ", id)
                    print("")
                except psycopg2.errors.UniqueViolation:
                    #print("Event already exists in the DB")
                    pass
                except psycopg2.errors.StringDataRightTruncation:
                    print("One of the event values too long for DB")

                conn.commit()

            #print(lst)
            conn.close()
            time.sleep(10800)
