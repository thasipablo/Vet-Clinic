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


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';