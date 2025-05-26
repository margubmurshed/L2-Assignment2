create table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
)

create table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status TEXT NOT NULL
)

create table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location TEXT NOT NULL,
    notes TEXT
)

-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers(name, region) VALUES ('Derek Fox', 'Coastal Plains');

-- 2. Count unique species ever sighted.
SELECT count(DISTINCT species_id) as "unique_species_count"  from sightings;

-- 3. Find all sightings where the location includes "Pass".
SELECT * from sightings WHERE location LIKE '%Pass%';

-- 4. List each ranger's name and their total number of sightings.
SELECT r.name, count(*) as "total_sightings" 
from sightings s
JOIN rangers r ON r.ranger_id = s.ranger_id 
GROUP BY r.ranger_id, r.name;

-- 5. List species that have never been sighted.
SELECT common_name from species WHERE species_id NOT IN (SELECT species_id FROM sightings WHERE species_id IS NOT NULL);

-- 6. Show the most recent 2 sightings.
SELECT sp.common_name, s.sighting_time, r.name  from sightings s
JOIN species sp ON s.species_id = sp.species_id 
JOIN rangers r ON s.ranger_id = r.ranger_id 
ORDER BY sighting_time DESC LIMIT 2;

-- 7. Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(YEAR from discovery_date) < 1800;

-- 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT 
sighting_id,
CASE 
    WHEN extract(HOUR FROM sighting_time) < 12 THEN 'Morning'  
    WHEN extract(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'  
    WHEN extract(HOUR FROM sighting_time) > 17 THEN 'Evening'  
    ELSE 'Night' 
END AS "time_of_day"
from sightings;

-- 9. Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT ranger_id from sightings WHERE ranger_id IS NOT NULL); 
