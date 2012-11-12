
-- custom funcs
-- register 'twitter_helpers.py' using jython as twitter;
REGISTER berkeleyfoodudfs.jar;

-- Load tweets as uncompressed JSON - huge pain
json_tweets = LOAD 'data/tweets.*.json.gz' USING PigStorage() AS (json_record:chararray);
tweets = FOREACH json_tweets GENERATE berkeleyfoodudfs.SplitJSON(json_record);
flattened_tweets = FOREACH tweets GENERATE FLATTEN($0);
projected_tweets = FOREACH flattened_tweets GENERATE $0 AS
                 id_str:chararray, $1 AS lon:double, $2 AS lat:double, $3 AS json:chararray;
filtered_tweets = FILTER projected_tweets BY lat is not NULL;

-- Load restaurants
restaurants = LOAD 'data/rest-berk.tsv' USING PigStorage() AS
            (name:chararray, website:chararray, address:chararray, lon:double, lat:double);
projected_restaurants = FOREACH restaurants GENERATE name, lon, lat;
filtered_restaurants = FILTER projected_restaurants BY lat is not NULL;

-- Get tweets within range

tweet_restaurant_cross = CROSS filtered_tweets, filtered_restaurants;

-- Distance search
-- http://www.movable-type.co.uk/scripts/latlong.html
-- https://developers.google.com/maps/articles/phpsqlsearch_v3
-- Is the tweet within a 10km radius of the restaurant?
tweet_restaurant_cross_distance = FOREACH tweet_restaurant_cross GENERATE
    filtered_tweets::id_str,
    filtered_restaurants::name, filtered_restaurants::lat, filtered_restaurants::lon,
    (6371.0 *
    ACOS(SIN(filtered_tweets::lat * 3.14159265359 / 180) * SIN(filtered_restaurants::lat * 3.14159265359 / 180)
    + COS(filtered_tweets::lat * 3.14159265359 / 180) * COS(filtered_restaurants::lat * 3.14159265359 / 180)
    * COS(filtered_restaurants::lon * 3.14159265359 / 180 - filtered_tweets::lon * 3.14159265359 / 180))) AS distance:double;

-- Matches a tweet-restaurant pair within 5 km from each other
matched_tweets_restaurants = FILTER tweet_restaurant_cross_distance BY distance < 5.0;

tweet_restaurant_group = GROUP matched_tweets_restaurants BY (filtered_tweets::id_str);

matched_tweet_restaurants = FOREACH tweet_restaurant_group {
    rests = FOREACH matched_tweets_restaurants GENERATE distance, name, lat, lon;
    ordered_rests = ORDER rests BY distance;
    GENERATE group, ordered_rests;
}

DESCRIBE matched_tweets_restaurants;

results = JOIN matched_tweet_restaurants BY group, filtered_tweets BY id_str;

STORE results INTO 'data/location_matching.tsv' USING PigStorage();
