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

                '''print(placeName)
                print(placeType)
                print(link)
                print(address)
                print(city)
                print("")'''

                lst.append((placeName, placeType, link, address, city))

                sql = "INSERT INTO places(place_name, place_type, link, address, city) \
                VALUES (%s,%s,%s,%s,%s) RETURNING place_id;"

                try:
                    cur.execute(sql, (placeName, placeType, link, address, city))
                    id = cur.fetchone()[0]

                    print("Created place. id from db: ", id)
                    print("")
                except psycopg2.errors.UniqueViolation:
                    print("Place already exists in the DB")
                except psycopg2.errors.StringDataRightTruncation:
                    print("One of the place values too long for DB")

                conn.commit()

            #print(lst)
            conn.close()
            time.sleep(10800)
