INSERT INTO animals (
  name,
  species,
  date_of_birth,
  weight_kg,
  neutered,
  escape_attempts
)
VALUES 
  ('Charmander', NULL, '2020-02-08', -11, false, 0),
  ('Plantmon', NULL, '2021-11-15', -5.7, true, 2),
  ('Squirtle', NULL, '1993-04-02', -12.13, false, 3),
  ('Angemon', NULL, '2005-06-12', -45, true, 1),
  ('Boarmon', NULL, '2005-06-07', 20.4, true, 7),
  ('Blossom', NULL, '1998-10-13', 17, true, 3),
  ('Ditto', NULL, '2022-05-14', 22, true, 4);

--- Request multiple tables
INSERT INTO owners (full_name, age)
VALUES 
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

INSERT INTO species (name)
VALUES 
  ('Pokemon'),
  ('Digimon');

BEGIN;
update animals set 
  species_id=(select id from species where name = 'Digimon') 
  where name like '%mon';
SELECT * FROM animals;

update animals set 
  species_id=(select id from species where name = 'Pokemon') 
  where name not like '%mon';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Sam Smith') 
  where name like 'Agumon';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Jennifer Orwell') 
  where name like 'Gabumon' or name like 'Pikachu';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Bob') 
  where name like 'Devimon' or name like 'Devimon';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Melody Pond') 
  where name like 'Charmander' or name like 'Squirtle' or name like 'Blossom';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Dean Winchester') 
  where name like 'Angemon' or name like 'Boarmon';
SELECT * FROM animals;

update animals set 
  owner_id=(select id from owners where full_name = 'Bob') 
  where name like 'Plantmon' or name like 'Devimon';
SELECT * FROM animals;

COMMIT;
SELECT * FROM animals;

--- Add Vets and Visits ---
INSERT INTO 
  vets (name, age, date_of_graduation)
VALUES 
  ('William Tatcher', 45, '2000-04-23'),
  ('Maisy Smith', 26, '2019-01-17'),
  ('Stephanie Mendez', 64, '1981-05-04'),
  ('Jack Harkness', 38, '2008-06-08');

INSERT INTO specializations (vet_id, species_id)
  SELECT v.id, s.id
  FROM vets AS v
  JOIN species AS s ON s.name = 'Pokemon'
  WHERE v.name = 'William Tatcher';

INSERT INTO specializations (vet_id, species_id)
  SELECT v.id, s.id
  FROM vets AS v
  JOIN species AS s ON s.name IN ('Digimon', 'Pokemon')
  WHERE v.name = 'Stephanie Mendez';

INSERT INTO specializations (vet_id, species_id)
  SELECT v.id, s.id
  FROM vets AS v
  JOIN species AS s ON s.name = 'Digimon'
  WHERE v.name = 'Jack Harkness';

INSERT INTO visits (vet_id, animal_id, visit_date)
VALUES
  ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Agumon'), '2020-05-24'),
  ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Agumon'), '2020-07-22'),
  ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Gabumon'), '2021-02-02'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-01-05'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-03-08'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-05-14'),
  ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Devimon'), '2021-05-04'),
  ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Charmander'), '2021-02-24'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2019-12-21'),
  ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2020-08-10'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2021-04-07'),
  ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Squirtle'), '2019-09-29'),
  ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Angemon'), '2020-10-03'),
  ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Angemon'), '2020-11-04'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2019-01-24'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2019-05-15'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2020-02-27'),
  ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2020-08-03'),
  ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Blossom'), '2020-05-24'),
  ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Blossom'), '2021-01-11');


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
