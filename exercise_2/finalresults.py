from __future__ import absolute_import, print_function, unicode_literals

import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

if len(sys.argv) > 2:
	print("too many arguments")
	exit(1)

if len(sys.argv) < 2:
	arg = ''
else:
	arg = sys.argv[1]
	arg = arg.lower()

conn = psycopg2.connect(database="tcount", user="postgres", password="postgres", host="localhost", port="5432")
cur = conn.cursor()
	
if arg == '':
	cmd = "SELECT * FROM tweetwordcount ORDER BY word ASC"
	cur.execute(cmd)
	records = cur.fetchall()
	for row in records:
		print("(%s, %s)" % (row[0], row[1]))

else:
	cmd = "SELECT * FROM tweetwordcount WHERE word = (%s)"
	cur.execute(cmd, (arg,))
	if cur.rowcount > 0:
		records = cur.fetchall()
        	for row in records:	
			print("""Total number of occurrences of "%s": %s""" % (row[0], row[1]))
	
	else:
		print("""Total number of occurrences of "%s": 0""" % (arg))

conn.commit()
conn.close()
