CREATE DATABASE IF NOT EXISTS `home` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `home`;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS `user` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(45) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `token` VARCHAR(255) NOT NULL,
    `token_expiration` DATETIME NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `username_UNIQUE` (`username`)
);

-- Table des tâches
CREATE TABLE IF NOT EXISTS `task` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `priority_level` ENUM('Faible', 'Normal', 'Prioritaire') NOT NULL,
    `finish` BOOLEAN NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);

-- Table des notes
CREATE TABLE IF NOT EXISTS `notes` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `category` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `projects` (
    id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status VARCHAR(255) NOT NULL,
    deadline DATETIME NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(45) NOT NULL,              -- Nom d'utilisateur
    `email` VARCHAR(255) NOT NULL,                -- Email de l'utilisateur
    `password` VARCHAR(255) NOT NULL,             -- Mot de passe (haché)
    `token` VARCHAR(255) DEFAULT NULL,            -- Token pour la session (optionnel)
    `token_expiration` DATETIME DEFAULT NULL,     -- Date d'expiration du token (optionnel)
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Date de création du compte
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Date de dernière mise à jour
    PRIMARY KEY (`id`),
    UNIQUE INDEX `username_UNIQUE` (`username`),
    UNIQUE INDEX `email_UNIQUE` (`email`)         -- Email unique
);

CREATE TABLE IF NOT EXISTS `roles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,      -- Nom du rôle (ex: 'admin', 'user', 'editor')
    `description` VARCHAR(255) DEFAULT NULL, -- Description du rôle (optionnel)
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name`)  -- Le nom du rôle doit être unique
);

CREATE TABLE IF NOT EXISTS `permissions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,       -- Nom de la permission (ex: 'delete_user', 'edit_content')
    `description` VARCHAR(255) DEFAULT NULL, -- Description de la permission (optionnel)
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name`)  -- Le nom de la permission doit être unique
);

CREATE TABLE IF NOT EXISTS `user_roles` (
    `user_id` INT NOT NULL,              -- ID de l'utilisateur
    `role_id` INT NOT NULL,              -- ID du rôle
    PRIMARY KEY (`user_id`, `role_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `role_permissions` (
    `role_id` INT NOT NULL,              -- ID du rôle
    `permission_id` INT NOT NULL,        -- ID de la permission
    PRIMARY KEY (`role_id`, `permission_id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`id`) ON DELETE CASCADE
);

-- Ajouter un role 
INSERT INTO `roles` (`name`, `description`) VALUES
('admin', 'Rôle d\'administrateur, peut tout gérer'),
('editor', 'Rôle d\'éditeur, peut modifier le contenu'),
('user', 'Rôle d\'utilisateur normal, accès restreint');

-- ajouter des permissions 

INSERT INTO `permissions` (`name`, `description`) VALUES
('delete_user', 'Permet de supprimer un utilisateur'),
('edit_content', 'Permet de modifier du contenu'),
('view_content', 'Permet de voir du contenu');



-- Associer l'utilisateur 1 au rôle 'admin'
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1);  -- L'utilisateur 1 est un admin

-- Associer l'utilisateur 2 au rôle 'editor'
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(2, 2);  -- L'utilisateur 2 est un éditeur


-- Associer l'admin avec toutes les permissions
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),  -- admin peut supprimer un utilisateur
(1, 2),  -- admin peut éditer du contenu
(1, 3);  -- admin peut voir du contenu

-- Associer l'éditeur avec des permissions limitées
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(2, 2),  -- éditeur peut éditer du contenu
(2, 3);  -- éditeur peut voir du contenu

-- Verifier le role d'un utilisateur : 
SELECT p.name
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id
JOIN role_permissions rp ON r.id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id
WHERE u.username = 'username'
  AND p.name = 'delete_user';
