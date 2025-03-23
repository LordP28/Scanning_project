-- Création de la base de données pour les administrateurs
CREATE DATABASE IF NOT EXISTS admin_db;
USE admin_db;

-- Table des administrateurs
CREATE TABLE IF NOT EXISTS administrators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion des administrateurs de test avec mot de passe hashé
INSERT INTO administrators (email, password) VALUES
('admin1@university.com', '$2a$10$YourHashedPasswordHere'),
('admin2@university.com', '$2a$10$YourHashedPasswordHere'),
('admin3@university.com', '$2a$10$YourHashedPasswordHere'),
('admin4@university.com', '$2a$10$YourHashedPasswordHere'),
('admin5@university.com', '$2a$10$YourHashedPasswordHere'); 