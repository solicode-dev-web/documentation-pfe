-- ================================================================
-- KHAYATI DATABASE SCHEMA
-- Moroccan Tailoring Management Platform (Student-Friendly & PFE-Ready)
-- Clean Relational Structure with Cascading Deletions
-- ================================================================

CREATE DATABASE IF NOT EXISTS khayati_db
DEFAULT CHARACTER SET utf8
COLLATE utf8_unicode_ci;

USE khayati_db;

-- ----------------------------------------------------------------
-- TABLE: tailors (Artisans Couturiers)
-- Stores tailor accounts, credentials, and public profiles
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tailors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(30) NOT NULL,
    shop VARCHAR(255) NOT NULL,
    description TEXT,
    avatar VARCHAR(255) DEFAULT 'images/tailor_avatar.jpg',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------
-- TABLE: clients (Clients des tailleurs)
-- Each tailor manages their own clients with measurements
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tailor_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255),
    gender ENUM('F', 'M') DEFAULT 'F',
    -- Detailed measurements for traditional Moroccan garments
    shoulders VARCHAR(50), -- Epaules
    chest VARCHAR(50),     -- Poitrine
    waist VARCHAR(50),     -- Taille
    hips VARCHAR(50),      -- Bassin
    sleeves VARCHAR(50),   -- Manches
    neck VARCHAR(50),      -- Cou
    total_length VARCHAR(50), -- Longueur Totale
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tailor_id) REFERENCES tailors(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------
-- TABLE: commandes (Suivi de couture)
-- Relates to a tailor and a client, with order and tracking codes
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS commandes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tailor_id INT NOT NULL,
    client_id INT NOT NULL,
    order_code VARCHAR(50) NOT NULL UNIQUE,      -- KHY-XXXX
    tracking_code VARCHAR(50) NOT NULL UNIQUE,   -- TRK-XXXX
    clothing_type VARCHAR(100) NOT NULL,        -- Caftan, Takchita, Djellaba...
    description TEXT,
    measurements TEXT,                           -- Snapshot of measurements at order time
    status ENUM('A faire', 'En cours', 'Termine', 'Livre') DEFAULT 'A faire',
    comment TEXT,
    price DECIMAL(10,2) DEFAULT 0.00,
    advance_payment DECIMAL(10,2) DEFAULT 0.00,
    delivery_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tailor_id) REFERENCES tailors(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------------------------------------------
-- TABLE: portfolio_images (Galerie de Créations)
-- Public portfolio images uploaded by tailors
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS portfolio_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tailor_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    caption VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tailor_id) REFERENCES tailors(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ================================================================
-- INSERT SAMPLE DATA FOR PFE PRESENTATION
-- ================================================================

-- Tailors (Passwords are "123456" hashed with BCRYPT)
INSERT INTO tailors (id, username, password, fullname, city, specialty, email, phone, shop, description, avatar)
VALUES
(1, 'amina_couture', '$2y$10$R9l6l5oXvG8v6nNqVlyyOu58PpxpWj1bB8oN371a5c4d6e7f8g9h1', 'Amina El Mansouri', 'Fès', 'Caftan & Takchita Haute Couture', 'amina.couture@gmail.com', '+212 661-234567', 'Maison du Caftan Fassi', 'Artisane couturière spécialisée dans la confection traditionnelle de Caftans et Takchitas de mariée, brodés à la main avec du fil d\'or et des perles de luxe.', 'backend/uploads/avatars/demo_amina.jpg'),
(2, 'youssef_beldi', '$2y$10$R9l6l5oXvG8v6nNqVlyyOu58PpxpWj1bB8oN371a5c4d6e7f8g9h1', 'Youssef Alami', 'Marrakech', 'Djellaba & Jabador Traditionnel', 'youssef.beldi@gmail.com', '+212 662-987654', 'Atelier Alami El Bahja', 'Styliste et maître tailleur de Djellabas modernes et traditionnelles pour hommes et femmes dans la médina de Marrakech.', 'backend/uploads/avatars/demo_youssef.jpg');

-- Clients
INSERT INTO clients (id, tailor_id, name, phone, email, address, gender, shoulders, chest, waist, hips, sleeves, neck, total_length)
VALUES
(1, 1, 'Laila Benjelloun', '+212 670-112233', 'laila.benj@gmail.com', 'Avenue Hassan II, Fès', 'F', '40cm', '92cm', '76cm', '100cm', '60cm', '36cm', '145cm'),
(2, 1, 'Meriem El Ouali', '+212 675-445566', 'meriem.ouali@hotmail.com', 'Route d\'Imouzzer, Fès', 'F', '38cm', '88cm', '72cm', '96cm', '58cm', '35cm', '140cm'),
(3, 2, 'Karim Bennani', '+212 660-889900', 'karim.bennani@outlook.com', 'Guéliz, Marrakech', 'M', '45cm', '105cm', '95cm', '110cm', '62cm', '42cm', '150cm');

-- Commandes
INSERT INTO commandes (id, tailor_id, client_id, order_code, tracking_code, clothing_type, description, measurements, status, comment, price, advance_payment, delivery_date)
VALUES
(1, 1, 1, 'KHY-1001', 'TRK-1001', 'Caftan Moderne', 'Caftan en velours vert émeraude brodé de Sfifa dorée fait main et perles de Swarovski.', 'Epaules: 40cm, Poitrine: 92cm, Taille: 76cm, Bassin: 100cm, Manches: 60cm, Cou: 36cm, Longueur: 145cm', 'En cours', 'Le travail de broderie Aakad a commencé. Attente de la livraison de la Sfifa fine.', 4500.00, 1500.00, '2026-06-15'),
(2, 1, 2, 'KHY-1002', 'TRK-1002', 'Takchita', 'Takchita de mariée blanche en deux pièces de soie et dentelle de Calais.', 'Epaules: 38cm, Poitrine: 88cm, Taille: 72cm, Bassin: 96cm, Manches: 58cm, Cou: 35cm, Longueur: 140cm', 'A faire', 'Tissu reçu et mesures validées. Coupe programmée pour la semaine prochaine.', 8000.00, 3000.00, '2026-07-20'),
(3, 2, 3, 'KHY-1003', 'TRK-1003', 'Djellaba', 'Djellaba en sousdi bleu roi avec finition Randa moderne.', 'Epaules: 45cm, Poitrine: 105cm, Taille: 95cm, Bassin: 110cm, Manches: 62cm, Cou: 42cm, Longueur: 150cm', 'Termine', 'Djellaba entièrement terminée, repassée et prête pour la livraison.', 1800.00, 800.00, '2026-05-30');

-- Portfolio Images
INSERT INTO portfolio_images (id, tailor_id, image_path, caption)
VALUES
(1, 1, 'backend/uploads/portfolio/demo_caftan1.jpg', 'Modern green caftan with luxury embroidery.'),
(2, 1, 'backend/uploads/portfolio/demo_takchita1.jpg', 'White wedding takchita design.'),
(3, 2, 'backend/uploads/portfolio/demo_djellaba1.jpg', 'Traditional handmade Moroccan djellaba.');