
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour BJJ
DROP DATABASE IF EXISTS `BJJ`;
CREATE DATABASE IF NOT EXISTS `BJJ` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `BJJ`;

-- Listage de la structure de table BJJ. Actualite
CREATE TABLE IF NOT EXISTS `Actualite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text DEFAULT NULL,
  `contenue` smallint(6) NOT NULL DEFAULT 0,
  `id_user` int(11) NOT NULL DEFAULT 0,
  `date_pub` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `FK__Utilisateur` FOREIGN KEY (`id_user`) REFERENCES `Utilisateur` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Commentaire
CREATE TABLE IF NOT EXISTS `Commentaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_poste` datetime NOT NULL DEFAULT current_timestamp(),
  `text` text DEFAULT '\'\'',
  `user_id` int(11) NOT NULL,
  `video_id` int(11) NOT NULL,
  `notif` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `FK_Commentaire_Utilisateur` FOREIGN KEY (`user_id`) REFERENCES `Utilisateur` (`id`),
  CONSTRAINT `FK_Commentaire_Video` FOREIGN KEY (`video_id`) REFERENCES `Video` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Module
CREATE TABLE IF NOT EXISTS `Module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp(),
  `couverture` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Module_UN` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Payement
CREATE TABLE IF NOT EXISTS `Payement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(50) NOT NULL,
  `id_user` int(11),
  `date_payement` datetime DEFAULT current_timestamp(),
  `motif` varchar(255) DEFAULT NULL,
  `qte` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_Payement_Utilisateur` (`id_user`),
  CONSTRAINT `fk_Payement_Utilisateur` FOREIGN KEY (`id_user`) REFERENCES `Utilisateur` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Sondage
CREATE TABLE IF NOT EXISTS `Sondage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `actualite_id` int(11) DEFAULT NULL,
  `choix` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `actualite_id` (`actualite_id`),
  CONSTRAINT `FKactu` FOREIGN KEY (`actualite_id`) REFERENCES `Actualite` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Sondage_utilisateur
CREATE TABLE IF NOT EXISTS `Sondage_utilisateur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `sondage_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user` (`user_id`),
  KEY `FK_sondage` (`sondage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Utilisateur
CREATE TABLE IF NOT EXISTS `Utilisateur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Utilisateur_UN` (`mail`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table pour les utilisateurs';

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table BJJ. Video
CREATE TABLE IF NOT EXISTS `Video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_upload` datetime NOT NULL DEFAULT current_timestamp(),
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module_id` int(11) NOT NULL,
  `niveau` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `Video_FK` (`module_id`),
  CONSTRAINT `Video_FK` FOREIGN KEY (`module_id`) REFERENCES `Module` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
