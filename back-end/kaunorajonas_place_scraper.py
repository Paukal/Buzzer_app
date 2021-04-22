from bs4 import BeautifulSoup
from urllib.request import urlopen, Request
import psycopg2
from db_connect import connect
import time
from threading import Thread
import re

class KaunorajonasPlaceScraper(Thread):

    def __init__(self):
        Thread.__init__(self)


    def run(self):
        while 1:
            print('*KaunorajonasPlaceScraper is connecting to the PostgreSQL database...')
            conn = connect()
            cur = conn.cursor()

            lst = []
            url = "https://www.kaunorajonas.lt/lankytinos-vietos"
            hdr = {'User-Agent': 'Mozilla/5.0'}
            req = Request(url,headers=hdr)

            page = urlopen(req)
            html = page.read().decode("utf-8")
            soup = BeautifulSoup(html, "html.parser")

            rows = soup.find_all("li", {"class": "one"})

            for row in rows:
                nameDiv = row.find("div", {"class":"name"})
                placeName = nameDiv.find('a').text
                placeName = re.sub('[\n\t\r]', '', placeName)

                placeType = row.find("div", {"class":"object-type"}).text
                placeType = re.sub('[\n\t\r]', '', placeType)

                if placeType == "Poilsiavietės":
                    placeType = "restPlaces"
                elif placeType == "Apžvalgos aikštelė":
                    placeType = "sceneryPlaces"
                elif placeType == "Pėsčiųjų takai":
                    placeType = "hikingTrails"
                elif placeType == "Fortai":
                    placeType = "forts"
                elif placeType == "Dviračių maršrutai":
                    placeType = "bikeTrails"
                elif placeType == "Gatvės menas":
                    placeType = "streetArt"
                elif placeType == "Muziejai":
                    placeType = "museums"
                elif placeType == "Architektūra":
                    placeType = "architecture"
                elif placeType == "Gamta":
                    placeType = "nature"
                elif placeType == "Istorija":
                    placeType = "history"
                elif placeType == "Maršrutai":
                    placeType = "trails"
                elif placeType == "Ekspozicijos":
                    placeType = "expositions"
                elif placeType == "Parkai":
                    placeType = "parks"
                elif placeType == "Skulptūros ir paminklai":
                    placeType = "sculptures"
                elif placeType == "Bažnyčios":
                    placeType = "churches"
                elif placeType == "Piliakalniai":
                    placeType = "mounds"


                photoDiv = row.find("div", {"class":"photo"})
                link = photoDiv.find('a')['href']

                address = placeName
                city = "Kaunas"
                public = "true"
                user_added_id = "-1"

                photo_url = ""

                try:
                    photo_url = photoDiv.find("div").find("div")['data-bg']
                except TypeError:
                    photo_url = "https://www.marketing91.com/wp-content/uploads/2020/02/Definition-of-place-marketing.jpg"

                '''print(placeName)
                print(placeType)
                print(link)
                print(address)
                print(city)
                print("")'''

                lst.append((placeName, placeType, link, address, city, public, user_added_id, photo_url))

                sql = "INSERT INTO places(place_name, place_type, link, address, city, public, user_added_id, photo_url) \
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s) RETURNING place_id;"

                try:
                    cur.execute(sql, (placeName, placeType, link, address, city, public, user_added_id, photo_url))
                    id = cur.fetchone()[0]

                    print("Created place. id from db: ", id)
                    print("")
                except psycopg2.errors.UniqueViolation:
                    #print("Place already exists in the DB")
                    pass
                except psycopg2.errors.StringDataRightTruncation:
                    print("One of the place values too long for DB")

                conn.commit()

            #print(lst)
            conn.close()
            time.sleep(10800)
