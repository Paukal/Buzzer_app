# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from kasvyksta_event_scraper import KasVykstaEventScraper
from kaunorajonas_place_scraper import KaunorajonasPlaceScraper
from db_connect import connect
from threading import Thread
import json
import datetime

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

            print("raw list: ", list)

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

            print("raw list: ", list)

            def json_default(value):
                return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
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
