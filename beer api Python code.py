# Importing the packages

import json
import pandas as pd
import requests
import psycopg2

# Getting the json Beer API

beer_api_url = 'https://api.punkapi.com/v2/beers'

r = requests.get(beer_api_url)

beer_data = json.loads(r.text)

beer_str = json.dumps(beer_data, indent=2, sort_keys=True)


print(beer_data)
print(len(beer_data))


# Making an empty list

beer_list= []

# for loop

for beer in beer_data:
    id= beer['id']
    name = beer['name']
    tagline=beer['tagline']
    first_brewed = beer['first_brewed']
    description= beer['description']
    abv= beer['abv']
    food_pairing= beer['food_pairing']
    volume_value = beer['volume']['value']
    volume_unit = beer['volume']['unit']
    malt_name = beer['ingredients']['malt'][-1]['name']
    malt_value_kg = beer['ingredients']['malt'][-1]['amount']['value']
    hops_name = beer['ingredients']['hops'][-1]['name']
    hops_value_g = beer['ingredients']['hops'][-1]['amount']['value']
    yeast = beer['ingredients']['yeast']
    brewers_tips= beer['brewers_tips']


    beer_item = {
        'id': id,
        'name': name,
        'tagline': tagline,
        'first_brewed': first_brewed,
        'description': description,
        'abv': abv,
        'food_pairing': food_pairing,
        'volume_value' : volume_value,
        'volume_unit' : volume_unit,
        'malt_name' : malt_name,
        'malt_value_kg' : malt_value_kg,
        'hops_name' : hops_name,
        'hops_value_g' : hops_value_g,
        'yeast' : yeast,
        'brewers_tips' : brewers_tips
    }
    beer_list.append(beer_item)

#list into tuple

def convert(list):
    return tuple(list)

convert(beer_list)

print(beer_list)

#tuple into dataframe

beer_df = pd.DataFrame(beer_list)
print(beer_df[['abv','name']].to_string())
print(type(beer_df['abv']))
print(beer_df[['id', 'name', 'tagline', 'first_brewed', 'description', 'abv', 'food_pairing', 'volume_value', 'volume_unit', 'malt_name',
'malt_value_kg', 'hops_name', 'hops_value_g', 'yeast', 'brewers_tips']].to_string())

# Connecting PostgreSQL to Python

#Establishing connection
pgconn = psycopg2.connect(
    database="beer_api_database",
    user='postgres',
    password='*******',
    host='localhost',
    port=1111
)
#Creating a cursor object using the cursor() method

pgcursor = pgconn.cursor()

#Checking if database is right

pgcursor.execute('SELECT current_database()')

print(pgcursor.fetchone())

#Creating the beer table

pgcursor.execute(''' CREATE TABLE IF NOT EXISTS beer_api (
                            id  SERIAL PRIMARY KEY,
                            name TEXT,
                            tagline TEXT,
                            first_brewed TEXT,
                            description TEXT,
                            abv FLOAT,
                            food_pairing TEXT,
                            volume_value FLOAT,
                            volume_unit TEXT,
                            malt_name TEXT,
                            malt_value_kg FLOAT,
                            hops_name TEXT,
                            hops_value_g FLOAT,
                            yeast TEXT,
                            brewers_tips TEXT);  
                            ''')

pgconn.commit()

#Inserting the data

from psycopg2.extras import execute_values

execute_values(pgcursor,
'INSERT INTO beer_api (id, name, tagline, first_brewed, description, abv, food_pairing, volume_value, volume_unit, malt_name, malt_value_kg, hops_name, hops_value_g, yeast, brewers_tips) VALUES %s',
beer_df.values)

pgconn.commit()

#Closing cursor

pgcursor.close()

#Closing connection

pgconn.close()