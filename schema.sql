CREATE DATABASE vet_clinic;

CREATE TABLE animals (
  id INT, 
  name VARCHAR(50), 
  date_of_birth DATE, 
  escape_attempts INT, 
  neutered BOOLEAN, 
  weight_kg DECIMAL
);
