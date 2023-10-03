--- SECTION 1
BEGIN;
UPDATE animals SET species='unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT * FROM animals;
---------------------------
BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
SELECT * FROM animals;
UPDATE animals SET species='pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;
---------------------------
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
---------------------------
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * (-1);
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * (-1) WHERE weight_kg < 1;
COMMIT;

--- SECTION 2
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
SELECT MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-12-31' GROUP BY species;

-- Query multiple tables
SELECT name, full_name FROM animals 
  JOIN owners ON owner_id = (SELECT id FROM owners 
  WHERE full_name = 'Melody Pond') WHERE full_name = 'Melody Pond';

SELECT * FROM animals JOIN species 
  ON species_id = (SELECT id FROM species WHERE name = 'Pokemon') 
  WHERE species.name = 'Pokemon';

SELECT o.full_name AS owner_name, a.name AS animal_name, s.name AS species_name
  FROM owners AS o
  LEFT JOIN animals AS a ON o.id = a.owner_id
  LEFT JOIN species AS s ON a.species_id = s.id
  ORDER BY o.full_name, a.name;

SELECT s.name AS species_name, COUNT(*) AS animal_count
  FROM animals AS a
  INNER JOIN species AS s ON a.species_id = s.id
  GROUP BY s.name;

SELECT a.name
  FROM animals AS a
  INNER JOIN species AS s ON a.species_id = s.id
  INNER JOIN owners AS o ON a.owner_id = o.id
  WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

SELECT a.name, s.name AS species_name
  FROM animals AS a
  INNER JOIN species AS s ON a.species_id = s.id
  INNER JOIN owners AS o ON a.owner_id = o.id
  WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

SELECT o.full_name, COUNT(a.id) AS animal_count
  FROM owners AS o
  LEFT JOIN animals AS a ON o.id = a.owner_id
  GROUP BY o.full_name
  ORDER BY animal_count DESC
  LIMIT 1;

EXPLAIN ANALYSE SELECT COUNT(*) FROM visits WHERE animal_id = 4;

EXPLAIN ANALYSE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYSE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYSE SELECT * FROM owners where email = 'owner_18327@mail.com';
