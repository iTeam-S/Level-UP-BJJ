-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           10.3.30-MariaDB-0ubuntu0.20.04.1 - Ubuntu 20.04
-- SE du serveur:                debian-linux-gnu
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour BJJ
CREATE DATABASE IF NOT EXISTS `BJJ` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `BJJ`;

-- Listage de la structure de la table BJJ. Commentaire
CREATE TABLE IF NOT EXISTS `Commentaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_poste` datetime NOT NULL DEFAULT current_timestamp(),
  `text` text DEFAULT '\'\'',
  `user_id` int(11) NOT NULL,
  `video_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `FK_Commentaire_Utilisateur` FOREIGN KEY (`user_id`) REFERENCES `Utilisateur` (`id`),
  CONSTRAINT `FK_Commentaire_Video` FOREIGN KEY (`video_id`) REFERENCES `Video` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de la table BJJ. Module
CREATE TABLE IF NOT EXISTS `Module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Module_UN` (`nom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de la table BJJ. Utilisateur
CREATE TABLE IF NOT EXISTS `Utilisateur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Utilisateur_UN` (`mail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table pour les utilisateurs';

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de la table BJJ. Video
CREATE TABLE IF NOT EXISTS `Video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_upload` datetime NOT NULL DEFAULT current_timestamp(),
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Video_FK` (`module_id`),
  CONSTRAINT `Video_FK` FOREIGN KEY (`module_id`) REFERENCES `Module` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
