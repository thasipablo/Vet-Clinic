--- SECTION 1
BEGIN;
UPDATE animals SET species='unspecified';
ROLLBACK;
SELECT * FROM animals;
---------------------------
BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
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
