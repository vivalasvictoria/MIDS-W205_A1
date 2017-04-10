from __future__ import absolute_import, print_function, unicode_literals
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

conn = psycopg2.connect(database="tcount", user="postgres", password="postgres", host="localhost", port="5432")
cur = conn.cursor()

cmd = "SELECT * FROM tweetwordcount ORDER BY count DESC LIMIT 20"
cur.execute(cmd)

records = cur.fetchall()

for row in records:
	x = 0
	size = 4 - len(row[0])
	y = 0
	print(row[0], end='')
	while y < size:
		print(" ", end='')
		y = y+1
	
	while x < row[1]:
		print("*", end='')
		x = x+1
	print(" ")

