CREATE DATABASE vet_clinic;

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY, 
  name VARCHAR(50), 
  date_of_birth DATE, 
  escape_attempts INT, 
  neutered BOOLEAN, 
  weight_kg DECIMAL
);

ALTER TABLE animals ADD species VARCHAR(100);

CREATE TABLE owners (
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(150),
	age INT,
	PRIMARY KEY(id)
);

CREATE TABLE species (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(150),
	PRIMARY KEY(id)
);

ALTER TABLE animals ADD PRIMARY KEY (id);
ALTER TABLE animals DROP species;
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD COLUMN owner_id INT;

ALTER TABLE animals ADD CONSTRAINT species_id FOREIGN KEY (species_id) REFERENCES species (id);
ALTER TABLE animals ADD CONSTRAINT owner_id FOREIGN KEY (owner_id) REFERENCES owners (id);

CREATE TABLE vets (
  id INT  GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  age INTEGER,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);

CREATE TABLE visits (
  vet_id INTEGER REFERENCES vets(id),
  animal_id INTEGER REFERENCES animals(id),
  visit_date DATE,
  PRIMARY KEY (vet_id, animal_id, visit_date)
);
