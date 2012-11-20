#!/usr/bin/env python

from __future__ import print_function

import argparse
import boto
import os
import sys

parser = argparse.ArgumentParser(
    description='Download all .json.gz files from an Amazon S3 bucket')

parser.add_argument('-b', '--bucket',  type=str, required=True)
parser.add_argument('-v', '--verbosity', action='store_true',
                    help='Log messages')
args = vars(parser.parse_args())

s3 = boto.connect_s3()
bucket = s3.get_bucket(args['bucket'])

keys = bucket.list('old/tweets.')
already_downloaded = os.listdir('data/')
filtered_keys = [k for k in keys
                 if str(k.name.split('/')[-1]) not in already_downloaded]

for key in filtered_keys:
    if '.json.gz' in key.name:
        new_file_name = 'data/' + key.name.split('/')[-1]
        try:
            key.get_contents_to_filename(new_file_name)
            if args['verbosity']:
                print('Downloaded:', new_file_name)
        except:
            print('ERROR while downloading:', new_file_name, file=sys.stderr)
