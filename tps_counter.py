#!/usr/bin/env python

from datetime import datetime
import fileinput
import simplejson as json
import sys

from collections import Counter

seconds = Counter()
days = Counter()

for line in fileinput.input():
    tweet_id, restaurants, tweet_id_2, tweet_longitude, tweet_latitude, tweet_json = line.split('\t')
    tweet = json.loads(tweet_json)
    # print tweet['created_at']
    # Sample: Sun Nov 11 07:06:02 +0000 2012
    dt = datetime.strptime(tweet['created_at'], '%a %b %d %H:%M:%S +0000 %Y')
    unix_time = int(dt.strftime('%s'))
    seconds[unix_time] += 1
    days[unix_time - (unix_time % 86400)] += 1

k = seconds.keys()
for i in range(min(k), max(k)):
    seconds[i] = seconds.get(i, 0)

k = days.keys()
for i in range(min(k), max(k), 86400):
    days[i] = days.get(i, 0)

print 'Average:'
print sum(seconds.values())/float(len(seconds.keys())), 'TPS'
print sum(days.values())/float(len(days.keys())), 'TPD'
