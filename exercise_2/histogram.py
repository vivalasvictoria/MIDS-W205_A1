from __future__ import absolute_import, print_function, unicode_literals

import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

if len(sys.argv) > 2:
        print("too many arguments")
        exit(1)

if len(sys.argv) < 2:
        print("too few arguments")
        exit(1)

arg = sys.argv[1]

if "," not in arg:
        print("separate numbers with comma")
        exit(1)

split = arg.split(",")
k1 = split[0]
k2 = split[1]

conn = psycopg2.connect(database="tcount", user="postgres", password="postgres", host="localhost", port="5432")
cur = conn.cursor()

cmd = "SELECT * FROM tweetwordcount WHERE count >= (%s) AND count <= (%s) ORDER BY count DESC"
cur.execute(cmd, (k1, k2,))
records = cur.fetchall()
if cur.rowcount > 0:
        for row in records:
                        print("(%s, %s)" % (row[0], row[1]))

else:
        print("No results for this search.")


conn.commit()
conn.close()
