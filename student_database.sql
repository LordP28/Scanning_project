-- Création de la base de données pour les étudiants
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

-- Table des étudiants
CREATE TABLE IF NOT EXISTS students1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    major VARCHAR(100) NOT NULL,
    profile_picture VARCHAR(255),
    qr_code VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion des étudiants de test
INSERT INTO students1 (student_id, first_name, last_name, major, profile_picture, qr_code) VALUES
('103495', 'John', 'Doe', 'Computer Science', 'profile1.jpg', 'QR001'),
('104567', 'Jane', 'Smith', 'Engineering', 'profile2.jpg', 'QR002'),
('103438', 'Michael', 'Johnson', 'Business', 'profile3.jpg', 'QR003'),
('103712', 'Sarah', 'Williams', 'Mathematics', 'profile4.jpg', 'QR004'),
('104444', 'David', 'Brown', 'Physics', 'profile5.jpg', 'QR005'),
('104290', 'Emma', 'Davis', 'Chemistry', 'profile6.jpg', 'QR006'),
('103033', 'James', 'Wilson', 'Biology', 'profile7.jpg', 'QR007'),
('104822', 'Olivia', 'Taylor', 'History', 'profile8.jpg', 'QR008'),
('104001', 'William', 'Anderson', 'Psychology', 'profile9.jpg', 'QR009'),
('103229', 'Sophia', 'Martinez', 'Sociology', 'profile10.jpg', 'QR010'); 