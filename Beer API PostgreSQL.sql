SELECT * FROM beer_api;

SELECT TRIM(REGEXP_REPLACE(TRANSLATE(food_pairing,'{""}',''),',',', ','g')) as food_pairing FROM beer_api;

-- Beer Table

CREATE TABLE beer_table
(beer_id SERIAL PRIMARY KEY,
beer_name TEXT,
tagline TEXT,
first_brewed TEXT,
description TEXT,
abv FLOAT);


INSERT INTO beer_table(beer_id, beer_name, tagline, first_brewed,description, abv)
(SELECT id, name, tagline, first_brewed, description, abv
FROM beer_api);

SELECT * FROM beer_table;

-- Meal Table

CREATE TABLE meal_table
(meal_id SERIAL PRIMARY KEY,
food_pairing TEXT,
beer_id INT REFERENCES beer_table);

INSERT INTO meal_table(food_pairing,beer_id)
(SELECT TRIM(REGEXP_REPLACE(TRANSLATE(food_pairing,'{""}',''),',',', ','g')) 
as meal_name, id FROM beer_api);

SELECT * FROM meal_table;

-- Adding the foreign key

ALTER TABLE meal_table
ADD CONSTRAINT fk_beer_id
FOREIGN KEY(beer_id) 
REFERENCES beer_table (beer_id);

-- Malt table

CREATE TABLE malt_table
(malt_id SERIAL PRIMARY KEY,
malt_name TEXT 
);

INSERT INTO malt_table(malt_name)
(SELECT DISTINCT(malt_name)
FROM beer_api);

-- Hops Table

CREATE TABLE hops_table
(hops_id SERIAL PRIMARY KEY,
hops_name TEXT 
);

INSERT INTO hops_table(hops_name)
(SELECT DISTINCT(hops_name)
FROM beer_api);

SELECT * FROM hops_table;

-- Yeast Table

CREATE TABLE yeast_table
(yeast_id SERIAL PRIMARY KEY,
yeast_name TEXT 
);

INSERT INTO yeast_table(yeast_name)
(SELECT DISTINCT(yeast) as yeast_name
FROM beer_api);

SELECT * FROM yeast_table;


-- Ingredients Table

CREATE TABLE ingredients_table
(malt_id INT,
hops_id INT,
yeast_id INT
);

