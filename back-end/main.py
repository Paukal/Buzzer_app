'''
Lets Go App
Paulius Tomas Kalvers
Main server logic
'''

# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from kasvyksta_event_scraper import KasVykstaEventScraper
from kaunorajonas_place_scraper import KaunorajonasPlaceScraper
from db_connect import connect
from threading import Thread
import json
import datetime
from datetime import date
import decimal
import psycopg2
from urllib.parse import urlparse, parse_qs

hostName = "localhost"
serverPort = 8081
print('*Main Server is connecting to the PostgreSQL database...')
conn = connect()
cur = conn.cursor()

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):

        if "/user/events" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = query_components["userId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.events WHERE user_added_id = %s ORDER BY event_id ASC "

            cur.execute(sql, userId)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/user/places" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = query_components["userId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.places WHERE user_added_id = %s ORDER BY place_id ASC "

            cur.execute(sql, userId)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "events" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = int(query_components["userId"][0])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.events WHERE public = true OR (public = false AND user_added_id = {0}) ORDER BY event_id ASC ".format(userId)

            cur.execute(sql)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/places" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = int(query_components["userId"][0])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.places WHERE public = true OR (public = false AND user_added_id = {0}) ORDER BY place_id ASC ".format(userId)

            cur.execute(sql)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/user/like" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = ' '.join([str(elem) for elem in query_components["userId"]])
            object = ' '.join([str(elem) for elem in query_components["object"]])
            objectId = int(' '.join([str(elem) for elem in query_components["objectId"]]))

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.likes WHERE user_id = %s and object = %s and object_id = %s ORDER BY like_id ASC"

            list = []

            try:
                cur.execute(sql, (userId, object, objectId))
                list = cur.fetchall()

            except psycopg2.errors.InFailedSqlTransaction:
                pass
            except TypeError:
                pass

            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/eventview" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            eventId = query_components["eventId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.events WHERE event_id = %s"

            cur.execute(sql, eventId)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/placeview" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            placeId = query_components["placeId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT * FROM public.places WHERE place_id = %s"

            cur.execute(sql, placeId)
            list = cur.fetchall()

            #print("raw list: ", list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/like/count" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            object = ' '.join([str(elem) for elem in query_components["object"]])
            objectId = int(' '.join([str(elem) for elem in query_components["objectId"]]))

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = %s and object_id = %s"

            try:
                cur.execute(sql, (object, objectId))
                num = cur.fetchone()[0]

            except psycopg2.errors.InFailedSqlTransaction:
                pass
            except TypeError:
                pass

            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(bytes(str(num).encode('utf-8')))
            self.wfile.flush()

        elif "/click/count" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            object = ' '.join([str(elem) for elem in query_components["object"]])
            objectId = ' '.join([str(elem) for elem in query_components["objectId"]])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = ""
            num = 0

            if object == "event":
                sql = "SELECT clicks FROM public.events WHERE event_id = {0};".format(objectId)
            if object == "place":
                sql = "SELECT clicks FROM public.places WHERE place_id = {0};".format(objectId)

            try:
                cur.execute(sql)
                num = cur.fetchone()[0]

            except psycopg2.errors.InFailedSqlTransaction:
                pass
            except TypeError:
                pass
            except UnboundLocalError:
                pass

            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(bytes(str(num).encode('utf-8')))
            self.wfile.flush()

        elif "/like/chart" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            object = ' '.join([str(elem) for elem in query_components["object"]])
            objectId = ' '.join([str(elem) for elem in query_components["objectId"]])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            today = date.today()

            beforeSevenDays = (today - datetime.timedelta(7)).strftime("%Y-%m-%d")
            beforeSixDays = (today - datetime.timedelta(6)).strftime("%Y-%m-%d")
            beforeFiveDays = (today - datetime.timedelta(5)).strftime("%Y-%m-%d")
            beforeFourDays = (today - datetime.timedelta(4)).strftime("%Y-%m-%d")
            beforeThreeDays = (today - datetime.timedelta(3)).strftime("%Y-%m-%d")
            beforeTwoDays = (today - datetime.timedelta(2)).strftime("%Y-%m-%d")
            beforeOneDays = (today - datetime.timedelta(1)).strftime("%Y-%m-%d")
            tomorrow = (today + datetime.timedelta(1)).strftime("%Y-%m-%d")

            sql = ""
            list = []

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeSevenDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeSixDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeFiveDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeFourDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeThreeDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeTwoDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date = '{2}';".format(object, objectId, str(beforeOneDays))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)

            sql = "SELECT COUNT(*) FROM public.likes WHERE object = '{0}' and object_id = {1} and date < '{2}';".format(object, objectId, str(tomorrow))
            cur.execute(sql)
            num = cur.fetchone()[0]
            list.append(num)
            print(list)

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')
            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/comments" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            object = ' '.join([str(elem) for elem in query_components["object"]])
            objectId = ' '.join([str(elem) for elem in query_components["objectId"]])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = ""
            list = []

            sql = "SELECT * FROM public.comments WHERE object = '{0}' AND object_id = {1};".format(object, objectId)

            try:
                cur.execute(sql)
                list = cur.fetchall()

            except psycopg2.errors.InFailedSqlTransaction:
                pass
            except TypeError:
                pass
            except UnboundLocalError:
                pass

            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(list, default=json_default, ensure_ascii=False).encode('utf8')

            self.wfile.write(json_string)
            self.wfile.flush()

        elif "/user/data" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            userId = ' '.join([str(elem) for elem in query_components["userId"]])

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = ""
            list = []

            sql = "SELECT * FROM public.users WHERE user_id = {0};".format(userId)

            try:
                cur.execute(sql)
                user = cur.fetchall()

            except psycopg2.errors.InFailedSqlTransaction:
                pass
            except TypeError:
                pass
            except UnboundLocalError:
                pass

            #print("raw list: ", list)

            #print("DB returned json: ", json_string.decode())

            def json_default(value):
                if isinstance(value, datetime.datetime):
                    return str('{0}-{1:0=2d}-{2:0=2d} {3:0=2d}:{4:0=2d}:00'.format(value.year, value.month, value.day, value.hour, value.minute))
                if isinstance(value, decimal.Decimal):
                    return str('{0}'.format(value))
                else:
                    return value.__dict__

            json_string = json.dumps(user, default=json_default, ensure_ascii=False).encode('utf8')

            self.wfile.write(json_string)
            self.wfile.flush()

    def do_POST(self):

        if self.path == "/user/connected":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            userId = values["id"]
            firstName = values["first_name"]
            lastName = values["last_name"]
            email = values["email"]
            verified = "false"
            admin = "false"

            sql = "INSERT INTO users(user_id, first_name, last_name, email, verified, admin) \
            VALUES (%s,%s,%s,%s,%s,%s) RETURNING user_id;"

            try:
                cur.execute(sql, (userId, firstName, lastName, email, verified, admin))
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

        elif self.path == "/user/event":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            eventName = values["event_name"]
            placeName = values["place_name"]
            link = values["link"]
            address = values["address"]
            city = values["city"]
            start_date = values["start_date"]
            public = values["public"]
            userId = values["user_id"]
            photoUrl = values["photo_url"]
            clicks = 0

            sql = "INSERT INTO events(event_name, place_name, link, address, city, start_date, public, user_added_id, photo_url, clicks) \
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) RETURNING event_id;"

            try:
                cur.execute(sql, (eventName, placeName, link, address, city, start_date, public, userId, photoUrl, clicks))
                id = cur.fetchone()[0]

                print("")
                print("Created new event by user. id from db: ", id)
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

        elif self.path == "/user/place":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            placeName = values["place_name"]
            placeType = values["place_type"]
            link = values["link"]
            address = values["address"]
            city = values["city"]
            public = values["public"]
            userId = values["user_id"]
            photoUrl = values["photo_url"]
            clicks = 0

            sql = "INSERT INTO places(place_name, place_type, link, address, city, public, user_added_id, photo_url, clicks) \
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s) RETURNING place_id;"

            try:
                cur.execute(sql, (placeName, placeType, link, address, city, public, userId, photoUrl, clicks))
                id = cur.fetchone()[0]

                print("")
                print("Created new place by user. id from db: ", id)
                print("")
            except psycopg2.errors.UniqueViolation:
                print("Place already exists in the DB")
            except psycopg2.errors.StringDataRightTruncation:
                print("One of the place values too long for DB")
            except psycopg2.errors.NumericValueOutOfRange:
                print("ID of the place is too long for DB")

            conn.commit()

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))
            self.wfile.flush()

        elif self.path == "/like/press":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            userId = values["user_id"]
            object = values["object"]
            objectId = values["object_id"]
            date = values["date"]

            sql = "INSERT INTO likes(user_id, object, object_id, date) \
            VALUES (%s,%s,%s,%s) RETURNING like_id;"

            try:
                cur.execute(sql, (userId, object, objectId, date))
                id = cur.fetchone()[0]

                print("")
                print("Created new like by user. id from db: ", id)
                print("")
            except psycopg2.errors.UniqueViolation:
                print("Like already exists in the DB")
            except psycopg2.errors.StringDataRightTruncation:
                print("One of the like values too long for DB")
            except psycopg2.errors.NumericValueOutOfRange:
                print("ID of the like is too long for DB")

            conn.commit()

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(bytes(str(id).encode('utf-8')))
            self.wfile.flush()

        elif self.path == "/comment/new":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            userId = values["user_id"]
            userName = values["user_name"]
            object = values["object"]
            objectId = values["object_id"]
            date = values["date"]
            comment = values["comment"]

            sql = "INSERT INTO comments(user_id, user_name, object, object_id, date, comment) \
            VALUES (%s,%s,%s,%s,%s,%s) RETURNING comment_id;"

            try:
                cur.execute(sql, (userId, userName, object, objectId, date, comment))
                id = cur.fetchone()[0]

                print("")
                print("Created new comment by user. id from db: ", id)
                print("")
            except psycopg2.errors.UniqueViolation:
                print("Comment already exists in the DB")
            except psycopg2.errors.StringDataRightTruncation:
                print("One of the comment values too long for DB")
            except psycopg2.errors.NumericValueOutOfRange:
                print("ID of the comment is too long for DB")

            conn.commit()

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(bytes(str(id).encode('utf-8')))
            self.wfile.flush()

    def do_PUT(self):

        if self.path == "/user/event/update":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("PUT request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            eventId = values["event_id"]
            eventName = values["event_name"]
            placeName = values["place_name"]
            link = values["link"]
            address = values["address"]
            city = values["city"]
            start_date = values["start_date"]
            public = values["public"]

            sql = "UPDATE events SET event_name = %s, place_name = %s, link = %s, address = %s, city = %s, start_date = %s, public = %s \
            WHERE event_id = %s RETURNING event_id;"

            try:
                cur.execute(sql, (eventName, placeName, link, address, city, start_date, public, eventId))
                id = cur.fetchone()[0]

                print("")
                print("Updated event by user. id from db: ", id)
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

        elif self.path == "/user/place/update":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("PUT request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            placeId = values["place_id"]
            placeName = values["place_name"]
            placeType = values["place_type"]
            link = values["link"]
            address = values["address"]
            city = values["city"]
            public = values["public"]

            sql = "UPDATE places SET place_name = %s, place_type = %s, link = %s, address = %s, city = %s, public = %s \
            WHERE place_id = %s RETURNING place_id;"

            try:
                cur.execute(sql, (placeName, placeType, link, address, city, public, placeId))
                id = cur.fetchone()[0]

                print("")
                print("Updated place by user. id from db: ", id)
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

        elif self.path == "/event/click":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("PUT request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            eventId = values["event_id"]

            sql = "UPDATE events SET clicks = clicks + 1 \
            WHERE event_id = {0} RETURNING event_id;".format(eventId)


            try:
                cur.execute(sql)
                id = cur.fetchone()[0]

                print("")
                print("Updated event by user. id from db: ", id)
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
            self.wfile.write("PUT request for {}".format(self.path).encode('utf-8'))
            self.wfile.flush()

        elif self.path == "/place/click":
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            print("PUT request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                    str(self.path), str(self.headers), post_data.decode('utf-8'))

            values = json.loads(post_data.decode('utf-8'))

            placeId = values["place_id"]

            sql = "UPDATE places SET clicks = clicks + 1 \
            WHERE place_id = {0} RETURNING place_id;".format(placeId)


            try:
                cur.execute(sql)
                id = cur.fetchone()[0]

                print("")
                print("Updated place by user. id from db: ", id)
                print("")
            except psycopg2.errors.UniqueViolation:
                print("Place already exists in the DB")
            except psycopg2.errors.StringDataRightTruncation:
                print("One of the place values too long for DB")
            except psycopg2.errors.NumericValueOutOfRange:
                print("ID of the place is too long for DB")

            conn.commit()

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write("PUT request for {}".format(self.path).encode('utf-8'))
            self.wfile.flush()

    def do_DELETE(self):

        if "/user/event/delete" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            eventId = query_components["eventId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "DELETE FROM public.events WHERE event_id = %s"

            cur.execute(sql, eventId)

            conn.commit()
            #print("raw list: ", list)

            self.wfile.flush()

        elif "/user/place/delete" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            placeId = query_components["placeId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "DELETE FROM public.places WHERE place_id = %s"

            cur.execute(sql, placeId)

            conn.commit()
            #print("raw list: ", list)

            self.wfile.flush()

        elif "/like/unpress" in self.path:
            query_components = parse_qs(urlparse(self.path).query)
            likeId = query_components["likeId"]

            self.send_response(200)
            self.send_header("Content-type", "application/json; charset=utf-8")
            self.end_headers()

            sql = "DELETE FROM public.likes WHERE like_id = %s"

            cur.execute(sql, likeId)

            conn.commit()
            #print("raw list: ", list)

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
