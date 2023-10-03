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

--- Add Vets and Visits ---

SELECT a.name AS last_animal_seen
  FROM visits AS v
  JOIN animals AS a ON v.animal_id = a.id
  WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
  ORDER BY v.visit_date DESC
  LIMIT 1;

SELECT COUNT(DISTINCT v.animal_id) AS num_animals_seen
  FROM visits AS v
  WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

SELECT v.name AS vet_name, COALESCE(array_agg(s.name), '{}'::text[]) AS specialties
  FROM vets AS v
  LEFT JOIN specializations AS sp ON v.id = sp.vet_id
  LEFT JOIN species AS s ON sp.species_id = s.id
  GROUP BY v.name;

SELECT a.name AS animal_name
  FROM visits AS v
  JOIN animals AS a ON v.animal_id = a.id
  WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
  AND v.visit_date >= '2020-04-01' AND v.visit_date <= '2020-08-30';

SELECT a.name AS most_visited_animal
  FROM (
      SELECT animal_id, COUNT(*) AS visit_count
      FROM visits
      GROUP BY animal_id
      ORDER BY visit_count DESC
      LIMIT 1
  ) AS most_visits
  JOIN animals AS a ON most_visits.animal_id = a.id;

SELECT vet.name AS first_vet_visited
  FROM visits AS v
  JOIN vets AS vet ON v.vet_id = vet.id
  WHERE v.animal_id = (SELECT id FROM animals WHERE name = 'Maisy Smith')
  ORDER BY v.visit_date ASC
  LIMIT 1;

SELECT a.name AS animal_name, vet.name AS vet_name, v.visit_date AS last_visit_date
  FROM visits AS v
  JOIN animals AS a ON v.animal_id = a.id
  JOIN vets AS vet ON v.vet_id = vet.id
  ORDER BY v.visit_date DESC
  LIMIT 1;

SELECT COUNT(*) AS num_visits_without_specialty
  FROM visits AS v
  JOIN animals AS a ON v.animal_id = a.id
  LEFT JOIN specializations AS sp ON v.vet_id = sp.vet_id AND a.species_id = sp.species_id
  WHERE sp.vet_id IS NULL;

SELECT a.name AS most_visited_animal
  FROM (
      SELECT animal_id, COUNT(*) AS visit_count
      FROM visits
      GROUP BY animal_id
      ORDER BY visit_count DESC
      LIMIT 1
  ) AS most_visits
  JOIN animals AS a ON most_visits.animal_id = a.id;
