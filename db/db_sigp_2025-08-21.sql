
use db_dux;

CREATE TABLE `login_audit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` char(36) NOT NULL,
  `login_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ip_addr` varchar(45) DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `event_type` enum('LOGIN','LOGOUT') NOT NULL DEFAULT 'LOGIN',
  PRIMARY KEY (`id`),
  KEY `idx_audit_user_date` (`user_id`,`login_at`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


CREATE TABLE `media_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `media_categories` (`id`, `name`, `description`)
VALUES
	(1,'CAPACITACIÓN','Encontraras videos y archivos que te ayudan');

CREATE TABLE `media_file_category` (
  `media_id` char(36) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`media_id`,`category_id`),
  KEY `fk_mfc_category` (`category_id`),
  CONSTRAINT `fk_mfc_category` FOREIGN KEY (`category_id`) REFERENCES `media_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mfc_media` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `media_file_views` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `media_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `viewed_at` datetime DEFAULT current_timestamp(),
  `ip_addr` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mfv_media_date` (`media_id`,`viewed_at`),
  KEY `idx_mfv_user_date` (`user_id`,`viewed_at`),
  CONSTRAINT `fk_mfv_media` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mfv_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `media_files` (
  `id` char(36) NOT NULL,
  `uploader_id` char(36) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `storage_key` varchar(512) NOT NULL,
  `source_type` enum('FILE','LINK','VIDEO') NOT NULL DEFAULT 'FILE',
  `original_name` varchar(255) NOT NULL,
  `mime_type` varchar(150) NOT NULL,
  `size_bytes` bigint(20) unsigned DEFAULT NULL,
  `visibility` enum('PUBLIC','PRIVATE','ROLE','CUSTOM') NOT NULL DEFAULT 'PUBLIC',
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_media_uploader` (`uploader_id`),
  KEY `idx_media_visibility` (`visibility`),
  KEY `fk_media_role` (`role_id`),
  CONSTRAINT `fk_media_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_media_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` text DEFAULT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `notif_type` enum('INFO','ACTION','WARNING','ERROR') DEFAULT 'INFO',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notif_user_read` (`user_id`,`is_read`),
  KEY `idx_notif_created` (`created_at`),
  CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE `password_reset_tokens` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `fk_prt_user` (`user_id`),
  CONSTRAINT `fk_prt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


DROP TABLE IF EXISTS `permissions`;

CREATE TABLE `permissions` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO `permissions` (`id`, `name`, `description`)
VALUES
	('6884a27d-5ce5-11f0-ac73-0256b145af91','CREATE_USER','Crear nuevos usuarios'),
	('68858f4e-5ce5-11f0-ac73-0256b145af91','READ_USER','Ver información de usuarios'),
	('6886122a-5ce5-11f0-ac73-0256b145af91','UPDATE_USER','Actualizar información de usuarios'),
	('688612c2-5ce5-11f0-ac73-0256b145af91','DELETE_USER','Eliminar usuarios'),
	('688612f8-5ce5-11f0-ac73-0256b145af91','CREATE_ROLE','Crear nuevos roles'),
	('6886132a-5ce5-11f0-ac73-0256b145af91','READ_ROLE','Ver información de roles'),
	('68861355-5ce5-11f0-ac73-0256b145af91','UPDATE_ROLE','Actualizar roles'),
	('6886139b-5ce5-11f0-ac73-0256b145af91','DELETE_ROLE','Eliminar roles'),
	('688613cc-5ce5-11f0-ac73-0256b145af91','ADMIN_PANEL','Acceso al panel de administración'),
	('688613f5-5ce5-11f0-ac73-0256b145af91','VIEW_REPORTS','Ver reportes del sistema'),
	('68861420-5ce5-11f0-ac73-0256b145af91','MANAGE_PERMISSIONS','Gestionar permisos del sistema'),
	('6ab72087-1241-4f97-9ea8-65466465c0e9','media_view',NULL),
	('6ce3b79f-10a4-4ffb-a983-7734f44db336','panel_view',NULL),
	('71f0f440-df35-45c3-8674-f1f2fdec5c11','media_admin',NULL),
	('95510f5f-5dcc-11f0-ac73-0256b145af91','CREATE_NOTIFICATIONS',NULL),
	('95515cd5-5dcc-11f0-ac73-0256b145af91','READ_NOTIFICATIONS',NULL),
	('95516f3c-5dcc-11f0-ac73-0256b145af91','UPDATE_NOTIFICATIONS',NULL),
	('95516fcd-5dcc-11f0-ac73-0256b145af91','DELETE_NOTIFICATIONS',NULL),
	('9d5f7801-cce5-4056-be5e-301be10d5d5f','dashboard_view',NULL),
	('aadc8dbe-64fa-11f0-ac73-0256b145af91','view_dashboard_directive',NULL),
	('acbf2b46-59ec-4e49-b9ad-77e7549444cc','notifications_view',NULL),
	('b2c07df5-5d16-11f0-ac73-0256b145af91','CREATE_STATE_USER',NULL),
	('b2c0805d-5d16-11f0-ac73-0256b145af91','READ_STATE_USER',NULL),
	('b2c080ab-5d16-11f0-ac73-0256b145af91','UPDATE_STATE_USER',NULL),
	('b2c080e2-5d16-11f0-ac73-0256b145af91','DELETE_STATE_USER',NULL),
	('dbfd09c0-5db7-11f0-ac73-0256b145af91','CREATE_MEDIA',NULL),
	('dbfd4d59-5db7-11f0-ac73-0256b145af91','READ_MEDIA',NULL),
	('dbfd4f28-5db7-11f0-ac73-0256b145af91','UPDATE_MEDIA',NULL),
	('dbfd4f6e-5db7-11f0-ac73-0256b145af91','DELETE_MEDIA',NULL),
	('fa1ec890-f451-4de2-8e44-0b9c9c94e85c','dashboard_directive_admin',NULL),
	;


DROP TABLE IF EXISTS `role_permissions`;

CREATE TABLE `role_permissions` (
  `role_id` char(36) NOT NULL,
  `permission_id` char(36) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_perm` (`permission_id`),
  CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


INSERT INTO `role_permissions` (`role_id`, `permission_id`)
VALUES
	('550e8400-e29b-41d4-a716-446655440001','0b93f834-6289-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','0b941ee6-6289-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','0b941f2c-6289-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','0dd982b1-fd56-413f-877f-3edacc802374'),
	('550e8400-e29b-41d4-a716-446655440001','243a19f2-95ce-4c4c-8f46-691f3c017a3e'),
	('550e8400-e29b-41d4-a716-446655440001','2465d8ec-d01e-4d20-aae9-330aa626590f'),
	('550e8400-e29b-41d4-a716-446655440001','2cab1863-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','2cab1b25-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','2cab1b6f-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','2cab1ba0-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','362d7ae4-5dec-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','362dd681-5dec-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','362dd721-5dec-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','362dd75b-5dec-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','388eddb2-31f9-421c-9206-a0a0c4b9c8ae'),
	('550e8400-e29b-41d4-a716-446655440001','3fd67297-5d1f-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','3fd693ce-5d1f-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','3fd6946e-5d1f-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','3fd694a7-5d1f-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','51f0462c-5f48-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','5d3f61d9-c0c2-4349-9c14-8105a7746ea5'),
	('550e8400-e29b-41d4-a716-446655440001','6884a27d-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','68858f4e-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6886122a-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','688612c2-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','688612f8-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6886132a-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','68861355-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6886139b-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','688613cc-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','688613f5-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','68861420-5ce5-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6ab72087-1241-4f97-9ea8-65466465c0e9'),
	('550e8400-e29b-41d4-a716-446655440001','6dcf68ad-5d18-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6dcf6aea-5d18-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6dcf6b31-5d18-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6dcf6b60-5d18-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','6fbda269-c955-4e23-b2de-e774a5392910'),
	('550e8400-e29b-41d4-a716-446655440001','70833684-5cfb-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','70835bf0-5cfb-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','70835c83-5cfb-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','70835d9c-5cfb-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','71f0f440-df35-45c3-8674-f1f2fdec5c11'),
	('550e8400-e29b-41d4-a716-446655440001','73ae3387-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','73ae35d4-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','73ae361f-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','73ae3653-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','93ab12d7-5f50-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','95510f5f-5dcc-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','95515cd5-5dcc-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','95516f3c-5dcc-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','95516fcd-5dcc-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','9d5f7801-cce5-4056-be5e-301be10d5d5f'),
	('550e8400-e29b-41d4-a716-446655440001','a608ce43-3967-4926-9ac3-46dfbd5bc81a'),
	('550e8400-e29b-41d4-a716-446655440001','a7bc000f-fa28-4384-b8ce-52a49f1a4ab8'),
	('550e8400-e29b-41d4-a716-446655440001','aadc8dbe-64fa-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b10fa693-5d15-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b11049be-5d15-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b1104abc-5d15-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b1104bdd-5d15-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b14cf38e-75d2-4286-a6b5-43fad197cece'),
	('550e8400-e29b-41d4-a716-446655440001','b2c07df5-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b2c0805d-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b2c080ab-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','b2c080e2-5d16-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','c24b3177-ce88-4575-8ce7-77834898c194'),
	('550e8400-e29b-41d4-a716-446655440001','c37bb338-0731-47e8-a211-4de0fa73d0c4'),
	('550e8400-e29b-41d4-a716-446655440001','d07de01b-5d98-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','d07de293-5d98-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','d07de2e1-5d98-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','d07de314-5d98-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','d43ec2f4-5f04-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','dbfd09c0-5db7-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','dbfd4d59-5db7-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','dbfd4f28-5db7-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','dbfd4f6e-5db7-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','eb711c49-34fe-41b5-b778-214cb51cd9da'),
	('550e8400-e29b-41d4-a716-446655440001','f5c044f5-5fdf-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','fa0af813-5d97-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','fa0c2fd5-5d97-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','fa0c324b-5d97-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','fa0c3294-5d97-11f0-ac73-0256b145af91'),
	('550e8400-e29b-41d4-a716-446655440001','fc037a57-a534-496f-9250-4d57e43e63f4'),
	('550e8400-e29b-41d4-a716-446655440001','fe3c0b7a-6e3b-4b66-8865-0cf20130fa81');

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` char(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`)
VALUES
	('550e8400-e29b-41d4-a716-446655440001','ADMIN','Administrador del sistema con todos los permisos','2025-07-09 16:54:41','2025-07-09 16:54:41'),
	('5e6e517e-584b-42be-a7a3-564ee14e8723','Staff','usuario Prescriptor','2025-07-10 14:23:12','2025-07-10 14:23:12'),
	('95ccbed7-5731-4068-80f1-9f88ec598974','Jugador','no se si no esta de mas este rol','2025-07-14 12:14:16','2025-07-14 12:14:16'),
	('deeba0da-d383-4f87-aae7-4f449814a4bc','Médico','usuario Médico','2025-07-13 11:46:30','2025-07-13 11:46:30');


DROP TABLE IF EXISTS `state_user`;

CREATE TABLE `state_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


INSERT INTO `state_user` (`id`, `name`)
VALUES
	(2,'ACTIVO'),
	(1,'INACTIVO'),
	(3,'SUSPENDIDO');


DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` char(36) NOT NULL,
  `state_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `cellular` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_role` (`role_id`),
  KEY `fk_user_state` (`state_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_user_state` FOREIGN KEY (`state_id`) REFERENCES `state_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


INSERT INTO `users` (`id`, `email`, `password_hash`, `role_id`, `state_id`, `created_at`, `updated_at`, `name`, `lastname`, `cellular`)
VALUES
	('695267f6-5ce5-11f0-ac73-0256b145af91','lucas.bracamonte@sportsdatacampus.com','98c4619b57bf727d375cffeb6aca579d527c4f544f1770ecbb869984e64859a6','550e8400-e29b-41d4-a716-446655440001',2,'2025-07-09 16:54:42','2025-07-21 20:07:56','Lucas','Bracamonte','+543416960613');


CREATE VIEW `vw_login_audit`
AS SELECT
   `la`.`id` AS `audit_id`,
   `la`.`user_id` AS `user_id`,
   `u`.`name` AS `name`,
   `u`.`lastname` AS `lastname`,
   `u`.`email` AS `email`,coalesce(`r`.`name`,'Sin rol') AS `rol`,
   `la`.`login_at` AS `login_at`,
   `la`.`ip_addr` AS `ip_addr`,
   `la`.`event_type` AS `event_type`,
   `la`.`success` AS `success`
FROM ((`login_audit` `la` left join `users` `u` on(`u`.`id` = `la`.`user_id`)) left join `roles` `r` on(`r`.`id` = `u`.`role_id`));


CREATE VIEW `vw_all_users_roles_and_statuses`
AS SELECT
   `u`.`id` AS `id`,
   `u`.`email` AS `email`,
   `u`.`name` AS `name`,
   `u`.`lastname` AS `lastname`,
   `r`.`name` AS `role_name`,
   `s`.`name` AS `state_name`,
   `u`.`created_at` AS `created_at`
FROM ((`users` `u` join `roles` `r` on(`u`.`role_id` = `r`.`id`)) join `state_user` `s` on(`u`.`state_id` = `s`.`id`)) order by `u`.`created_at`;


CREATE  VIEW `vw_count_users_by_rol`
AS SELECT
   `r`.`name` AS `rol`,count(`u`.`id`) AS `cantidad_usuarios`
FROM (`roles` `r` left join `users` `u` on(`r`.`id` = `u`.`role_id`)) group by `r`.`id`,`r`.`name` order by `r`.`name`;


CREATE VIEW `vw_count_users_by_state`
AS SELECT
   `s`.`name` AS `estado`,count(`u`.`id`) AS `cantidad_usuarios`
FROM (`state_user` `s` left join `users` `u` on(`s`.`id` = `u`.`state_id`)) group by `s`.`id`,`s`.`name` order by `s`.`id`;


CREATE  VIEW `vw_permissions_by_role`
AS SELECT
   `r`.`name` AS `role_name`,
   `p`.`name` AS `permission_name`,
   `p`.`description` AS `description`
FROM ((`roles` `r` join `role_permissions` `rp` on(`r`.`id` = `rp`.`role_id`)) join `permissions` `p` on(`rp`.`permission_id` = `p`.`id`)) order by `r`.`name`,`p`.`name`;



