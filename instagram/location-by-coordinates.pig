--Load all instagram data
insta = LOAD 'insta_data.tsv' USING PigStorage AS (user:chararray, url:chararray, photo_id:chararray, time:double, caption:chararray, lat:double, lon:double);

--Load restaurant-- Load restaurants
restaurants = LOAD 'rest-berk.tsv' USING PigStorage() AS
            (name:chararray, website:chararray, address:chararray, lon:double, lat:double);
projected_restaurants = FOREACH restaurants GENERATE name, lon, lat;
filtered_restaurants = FILTER projected_restaurants BY lat is not NULL;

--Cross insta photos and restaurants
inst_rests_cross = CROSS filtered_restaurants, insta;

--Get instagram photos within range
--Based off of http://www.movable-type.co.uk/scripts/latlong.html
insta_rests_cross_distance = FOREACH inst_rests_cross GENERATE
    insta::photo_id,
    filtered_restaurants::name, filtered_restaurants::lat, filtered_restaurants::lon,
    (6371.0 *
    ACOS(SIN(insta::lat * 3.14159265359 / 180) * SIN(filtered_restaurants::lat * 3.14159265359 / 180)
    + COS(insta::lat * 3.14159265359 / 180) * COS(filtered_restaurants::lat * 3.14159265359 / 180)
    * COS(filtered_restaurants::lon * 3.14159265359 / 180 - insta::lon * 3.14159265359 / 180))) AS distance:double;

--Match insta photos within 10m of a restaurant 
--Since these are tagged usually with FourSquare we can afford to be precise
matched_insta_restaurants = FILTER insta_rests_cross_distance BY distance < 0.01;
insta_rest_group = GROUP matched_insta_restaurants BY (insta::photo_id);

matched_insta_restaurants = FOREACH insta_rest_group GENERATE group, FLATTEN(matched_insta_restaurants); 

matched_insta_rests_detailed = JOIN matched_insta_restaurants BY insta::photo_id, insta BY photo_id;

--Project relevant fields
results = FOREACH matched_insta_rests_detailed GENERATE 
    matched_insta_restaurants::matched_insta_restaurants::filtered_restaurants::name AS rest_name,
    matched_insta_restaurants::matched_insta_restaurants::insta::photo_id AS photo_id, 
    matched_insta_restaurants::matched_insta_restaurants::filtered_restaurants::name AS name, 
    matched_insta_restaurants::matched_insta_restaurants::distance AS distance, 
    insta::user AS user, 
    insta::url AS url, 
    insta::time AS time,
    insta::caption AS caption,
    insta::lat AS lat, 
    insta::lon AS lon;

STORE results INTO 'location_matching-10-m.tsv' USING PigStorage();


