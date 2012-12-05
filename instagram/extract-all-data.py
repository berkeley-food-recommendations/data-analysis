import sys
import json as json
import re
import gzip

output = open("insta_data.tsv", "w")

#unicode fix for chars outside ASCII range
reload(sys)
sys.setdefaultencoding("utf-8")


#run this as 'python extract-all-data.py data/*txt.gz'
for filename in sys.argv[1:]:
    print "running...", filename
    with gzip.open(filename, 'rb') as f:
        insta_data = f.read()   
        # annoying hackiness b/c data actually isn't valid json
        entry_indices = [m.start()+1 for m in re.finditer('}{', insta_data)]
        # insert an entry for the first JSON
        entry_indices.insert(0, 0)
            
        for i in range(len(entry_indices) - 1):
            # iterate through actual JSONs of instagram data
            insta_text = insta_data[entry_indices[i]:entry_indices[i+1]]
            insta_json = json.loads(insta_text)
            #output.write(insta_text + "\n")
            data = insta_json.get('data')[0]
            loc = data.get('location')
            latitude = loc.get('latitude')
            longitude = loc.get('longitude')
            time = data.get('created_time')
            image = data.get('images').get('standard_resolution').get('url')
            caption = "None"
            if data.get('caption'):
                caption = data.get('caption').get("text")
            photo_id = data.get('id')
            user = data.get('user').get('username')
            line = user + "\t" + image + "\t" + photo_id + "\t" + str(time) + "\t" + caption + "\t" + str(latitude) + "\t" + str(longitude) + "\n"
            output.write(line)
