# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from kasvyksta_event_scraper import KasVykstaEventScraper
from kaunorajonas_place_scraper import KaunorajonasPlaceScraper
from db_connect import connect
from threading import Thread
import json
import datetime
import psycopg2

hostName = "localhost"
serverPort = 8081
conn = connect()
cur = conn.cursor()

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/events":
            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.events ORDER BY event_id ASC "

            cur.execute(sql)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        if self.path == "/places":
            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.places ORDER BY place_id ASC "

            cur.execute(sql)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

    def do_POST(self):
        if self.path == "/users":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            userId = values["id"]
            firstName = values["first_name"]
            lastName = values["last_name"]
            email = values["email"]

            sql = "INSERT INTO users(user_id, first_name, last_name, email) \
            VALUES (%s,%s,%s,%s) RETURNING user_id;"

            try:
                cur.execute(sql, (userId, firstName, lastName, email))
                id = cur.fetchone()[0]

                print("")
                print("Created user. id from db: ", id)
                print("")
            except psycopg2.errors.UniqueViolation:
                print("User already exists in the DB")
            except psycopg2.errors.StringDataRightTruncation:
                print("One of the user values too long for DB")
            except psycopg2.errors.NumericValueOutOfRange:
                print("ID of the user is too long for DB")

            conn.commit()

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))
            self.wfile.flush()


if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))
    print("")

    # Create 8 threads
    #for x in range(8):
    kasVykstaEventScraper = KasVykstaEventScraper()
    # Setting daemon to True will let the main thread exit even though the workers are blocking
    kasVykstaEventScraper.daemon = True
    kasVykstaEventScraper.start()

    kaunorajonasPlaceScraper = KaunorajonasPlaceScraper()
    # Setting daemon to True will let the main thread exit even though the workers are blocking
    kaunorajonasPlaceScraper.daemon = True
    kaunorajonasPlaceScraper.start()

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
