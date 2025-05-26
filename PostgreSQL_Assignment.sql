-- Active: 1747627262171@@127.0.0.1@5432@conservation_db
create table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
)

create table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
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

INSERT INTO rangers(name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species(common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger', 'Panthera tigris tigris','1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens','1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus','1758-01-01', 'Endangered');

INSERT INTO sightings(ranger_id, species_id, location, sighting_time, notes) VALUES
(1, 1,'Peak Ridge','2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2,'Bankwood Area','2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3,'Bamboo Grove East','2024-05-15 09:10:00', 'Feeding observed'),
(1, 2,'Snowfall Pass','2024-05-18 18:30:00', NULL);


-- - Problem 1
INSERT INTO rangers(name, region) VALUES ('Derek Fox', 'Coastal Plains');

-- - Problem 2
SELECT count(DISTINCT species_id) as "unique_species_count"  from sightings;

-- - Problem 3
SELECT * from sightings WHERE location LIKE '%Pass%';

-- - Problem 4
SELECT r.name, count(*) as "total_sightings" 
from sightings s
JOIN rangers r ON r.ranger_id = s.ranger_id 
GROUP BY r.ranger_id, r.name;

-- - Problem 5
SELECT common_name from species WHERE species_id NOT IN (SELECT species_id FROM sightings WHERE species_id IS NOT NULL);

-- - Problem 6
SELECT sp.common_name, s.sighting_time, r.name  from sightings s
JOIN species sp ON s.species_id = sp.species_id 
JOIN rangers r ON s.ranger_id = r.ranger_id 
ORDER BY sighting_time DESC LIMIT 2;

-- - Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(YEAR from discovery_date) < 1800;

-- - Problem 8
SELECT 
sighting_id,
CASE 
    WHEN extract(HOUR FROM sighting_time) < 12 THEN 'Morning'  
    WHEN extract(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'  
    WHEN extract(HOUR FROM sighting_time) > 17 THEN 'Evening'  
    ELSE 'Night' 
END AS "time_of_day"
from sightings;

-- - Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT ranger_id from sightings WHERE ranger_id IS NOT NULL); 
