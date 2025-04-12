-- Création de la base de données
CREATE DATABASE IF NOT EXISTS `home` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `home`;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(45) NOT NULL,              
    `email` VARCHAR(255) NOT NULL,                
    `password` VARCHAR(255) NOT NULL,             
    `token` VARCHAR(255) DEFAULT NULL,            
    `token_expiration` DATETIME DEFAULT NULL,     
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    PRIMARY KEY (`id`),
    UNIQUE INDEX `username_UNIQUE` (`username`),
    UNIQUE INDEX `email_UNIQUE` (`email`)         
);

-- Table des rôles
CREATE TABLE IF NOT EXISTS `roles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name`)
);

-- Table des permissions
CREATE TABLE IF NOT EXISTS `permissions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name`)
);

-- Liaison utilisateur → rôle
CREATE TABLE IF NOT EXISTS `user_roles` (
    `user_id` INT NOT NULL,
    `role_id` INT NOT NULL,
    PRIMARY KEY (`user_id`, `role_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
);

-- Liaison rôle → permissions
CREATE TABLE IF NOT EXISTS `role_permissions` (
    `role_id` INT NOT NULL,
    `permission_id` INT NOT NULL,
    PRIMARY KEY (`role_id`, `permission_id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`id`) ON DELETE CASCADE
);

-- Table des tâches (ToDo)
CREATE TABLE IF NOT EXISTS `task` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `priority_level` ENUM('Faible', 'Normal', 'Prioritaire') NOT NULL,
    `finish` BOOLEAN NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Table des notes
CREATE TABLE IF NOT EXISTS `notes` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `category` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Table des projets
CREATE TABLE IF NOT EXISTS `projects` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `status` VARCHAR(255) NOT NULL,
    `deadline` DATETIME NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Table de l’agenda (événements)
CREATE TABLE IF NOT EXISTS `events` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `start_time` DATETIME NOT NULL,
    `end_time` DATETIME NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `user_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Ajout des rôles de base
INSERT INTO `roles` (`name`, `description`) VALUES
('admin', 'Rôle d\'administrateur, peut tout gérer'),
('editor', 'Rôle d\'éditeur, peut modifier le contenu'),
('user', 'Rôle d\'utilisateur normal, accès restreint');

-- Ajout des permissions de base
INSERT INTO `permissions` (`name`, `description`) VALUES
('delete_user', 'Permet de supprimer un utilisateur'),
('edit_content', 'Permet de modifier du contenu'),
('view_content', 'Permet de voir du contenu');

-- Association admin → toutes les permissions
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),  -- delete_user
(1, 2),  -- edit_content
(1, 3);  -- view_content

-- Association editor → permissions limitées
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(2, 2),  -- edit_content
(2, 3);  -- view_content

-- Exemple d’association de rôles à des utilisateurs
-- L’utilisateur 1 est admin
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (1, 1);

-- L’utilisateur 2 est éditeur
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (2, 2);

-- Exemple : Vérifier si un utilisateur a une permission donnée
-- (remplacer 'username' et 'permission_name' par les valeurs recherchées)
-- SELECT p.name
-- FROM users u
-- JOIN user_roles ur ON u.id = ur.user_id
-- JOIN roles r ON ur.role_id = r.id
-- JOIN role_permissions rp ON r.id = rp.role_id
-- JOIN permissions p ON rp.permission_id = p.id
-- WHERE u.username = 'username' AND p.name = 'delete_user';
