#!/usr/bin/env python

from __future__ import print_function

import fileinput
import simplejson as json
import sys

from collections import Counter
from datetime import datetime
from operator import itemgetter

hours = Counter()

for line in fileinput.input():
    tweet_id, restaurants, tweet_id_2, tweet_longitude, \
        tweet_latitude, tweet_json = line.split('\t')
    tweet = json.loads(tweet_json)
    dt = datetime.strptime(tweet['created_at'], '%a %b %d %H:%M:%S +0000 %Y')
    unix_time = int(dt.strftime('%s'))
    hours[unix_time - (unix_time % 3600)] += 1

k = hours.keys()
for i in range(min(k), max(k), 3600):
    hours[i] = hours.get(i, 0)

by_the_hour = hours.items()
by_the_hour.sort(key=itemgetter(0))
for hour, count in by_the_hour:
    print(hour, count, sep='\t')
