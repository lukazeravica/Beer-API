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

-- Ingredients Junction Table

CREATE TABLE ingredients_table 
(
    beer_id	INT REFERENCES beer_table (beer_id),
    malt_id	INT REFERENCES malt_table (malt_id),
    hops_id	INT REFERENCES hops_table (hops_id),
    yeast_id	INT REFERENCES yeast_table (yeast_id)
);

INSERT INTO ingredients_table (beer_id, malt_id, hops_id, yeast_id) VALUES
	('1', '12', '4', '7'),
	('2', '12', '2', '7'),
	('3', '10', '6', '7'),
	('4', '12', '11', '4'),
	('5', '9', '13', '4'),
	('6', '9', '11', '5'),
	('7', '13', '10', '6'),
	('8', '8', '13', '4'),
	('9', '14', '8', '1'),
	('10', '6', '6', '7'),
	('11', '7', '14', '7'),
	('12', '4', '7', '7'),
	('13', '13', '4', '7'),
	('14', '3', '15', '7'),
	('15', '2', '5', '6'),
	('16', '1', '5', '7'),
	('17', '13', '11', '8'),
	('18', '5', '7', '7'),
	('19', '6', '15', '7'),
	('20', '2', '9', '3'),
	('21', '6', '12', '2'),
	('22', '15', '15', '7'),
	('23', '11', '2', '7'),
	('24', '11', '1', '6'),
	('25', '11', '3', '7');

SELECT * FROM ingredients_table;


