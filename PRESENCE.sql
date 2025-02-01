-- phpMyAdmin SQL Dump
-- version 5.2.1deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 30, 2025 at 02:48 PM
-- Server version: 10.11.6-MariaDB-0+deb12u1
-- PHP Version: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PRESENCE`
--

-- --------------------------------------------------------

--
-- Table structure for table `ALERTE`
--

CREATE TABLE `ALERTE` (
  `idAlerte` int(11) NOT NULL,
  `Type_Alerte` enum('BADGE_INCONNU','PRESENCE_NON_CONFIRMEE','PRESENCE_NON_VALIDEE','ABSENCE_POTENTIELLE','BADGES_MULTIPLES') DEFAULT NULL,
  `macBLE` varchar(50) DEFAULT NULL,
  `idBadge` int(11) DEFAULT NULL,
  `Horodatage` datetime DEFAULT NULL,
  `Details` text DEFAULT NULL,
  `Resolue` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `BADGE`
--

CREATE TABLE `BADGE` (
  `idBadge` int(11) NOT NULL,
  `idSTRI` varchar(50) NOT NULL,
  `macBLE` varchar(50) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BADGE`
--

INSERT INTO `BADGE` (`idBadge`, `idSTRI`, `macBLE`, `nom`, `prenom`) VALUES
(2, '2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1', '00:1A:2B:3C:4D:5F', 'TEST', 'test'),
(16, '2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1', '3D:97:6D:92:92:34', 'Dupont', 'Jean '),

-- --------------------------------------------------------

--
-- Table structure for table `COURS`
--

CREATE TABLE `COURS` (
  `idCours` int(11) NOT NULL,
  `Libelle` varchar(200) NOT NULL,
  `DateInit` datetime NOT NULL,
  `DateFin` datetime NOT NULL,
  `idSalle` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `COURS`
--

INSERT INTO `COURS` (`idCours`, `Libelle`, `DateInit`, `DateFin`, `idSalle`) VALUES
(1, 'IoT - C (FC)', '2025-01-09 13:30:00', '2025-01-09 15:30:00', 2),
(2, 'IoT - TP (FC)', '2025-01-09 15:45:00', '2025-01-09 17:45:00', 2),
(3, 'IoT - Projet présentation sujet (FC)', '2025-01-14 13:30:00', '2025-01-13 15:30:00', 2),
(4, 'IoT - Encadrement Projet (FC)', '2025-01-16 13:30:00', '2025-01-16 15:30:00', 2),
(5, 'IoT - Encadrement Projet (FC)', '2025-01-23 13:30:00', '2025-01-23 15:30:00', 1),
(6, 'IoT - Restitution Projet (FC)', '2025-01-30 13:30:00', '2025-01-30 15:30:00', 3),
(9, 'test', '2025-01-31 10:59:27', '2025-01-31 19:59:27', 2),
(10, 'test2', '2025-01-31 22:23:00', '2025-01-31 22:18:23', 1),
(100, '[TEST] IoT - Session de Test', '2025-01-30 08:22:25', '2025-01-30 13:22:25', 2);

-- --------------------------------------------------------

--
-- Table structure for table `DETECTEUR`
--

CREATE TABLE `DETECTEUR` (
  `idDetecteur` int(11) NOT NULL,
  `macBLE` varchar(50) NOT NULL,
  `macWIFI` varchar(50) NOT NULL,
  `Type` enum('Porte','Présence') NOT NULL,
  `idSalle` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `DETECTEUR`
--

INSERT INTO `DETECTEUR` (`idDetecteur`, `macBLE`, `macWIFI`, `Type`, `idSalle`) VALUES
(1, '00:1A:2B:3C:4D:10', '00:1A:2B:3C:4D:11', 'Porte', 1),
(2, '00:1A:2B:3C:4D:12', '00:1A:2B:3C:4D:13', 'Présence', 1),
(3, '00:1A:2B:3C:4D:14', '00:1A:2B:3C:4D:15', 'Porte', 2),
(4, '00:1A:2B:3C:4D:16', '00:1A:2B:3C:4D:17', 'Présence', 2),
(5, '00:1A:2B:3C:4D:18', '00:1A:2B:3C:4D:19', 'Porte', 3),
(6, '00:1A:2B:3C:4D:1A', '00:1A:2B:3C:4D:1B', 'Présence', 3),
(7, 'C8:C9:A3:C7:4B:FE', 'C8:C9:A3:C7:4B:FC', 'Porte', 3),
(8, 'C8:C9:A3:CC:1B:C6', 'C8:C9:A3:CC:1B:C4', 'Présence', 3);

-- --------------------------------------------------------

--
-- Table structure for table `PRESENCE`
--

CREATE TABLE `PRESENCE` (
  `idPresence` int(11) NOT NULL,
  `idCours` int(11) NOT NULL,
  `idBadge` int(11) NOT NULL,
  `derniereDetectionPresence` datetime DEFAULT NULL,
  `derniereDetectionPorte` datetime DEFAULT NULL,
  `Present` tinyint(1) NOT NULL DEFAULT 0,
  `Heure_Entree` datetime DEFAULT NULL,
  `Heure_Sortie` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `PRESENCE`
--

INSERT INTO `PRESENCE` (`idPresence`, `idCours`, `idBadge`, `derniereDetectionPresence`, `derniereDetectionPorte`, `Present`, `Heure_Entree`, `Heure_Sortie`) VALUES
(1, 1, 1, '2025-01-29 21:24:07', '2025-01-29 21:24:20', 1, NULL, NULL),
(2, 1, 2, '2025-01-29 10:26:57', NULL, 1, NULL, NULL),
(3, 1, 3, NULL, NULL, 0, NULL, NULL),
(4, 1, 4, NULL, NULL, 1, NULL, NULL),
(5, 1, 5, NULL, NULL, 0, NULL, NULL),
(6, 1, 6, NULL, NULL, 0, NULL, NULL),
(7, 1, 7, NULL, NULL, 0, NULL, NULL),
(8, 1, 8, NULL, NULL, 0, NULL, NULL),
(9, 1, 9, NULL, NULL, 0, NULL, NULL),
(10, 1, 10, NULL, NULL, 0, NULL, NULL),
(11, 1, 11, NULL, NULL, 0, NULL, NULL),
(12, 1, 12, NULL, NULL, 0, NULL, NULL),
(13, 1, 13, NULL, NULL, 0, NULL, NULL),
(14, 2, 1, NULL, NULL, 0, NULL, NULL),
(15, 2, 2, NULL, NULL, 0, NULL, NULL),
(16, 2, 3, NULL, NULL, 0, NULL, NULL),
(17, 2, 4, NULL, NULL, 0, NULL, NULL),
(18, 2, 5, NULL, NULL, 0, NULL, NULL),
(19, 2, 6, NULL, NULL, 0, NULL, NULL),
(20, 2, 7, NULL, NULL, 0, NULL, NULL),
(21, 2, 8, NULL, NULL, 0, NULL, NULL),
(22, 2, 9, NULL, NULL, 0, NULL, NULL),
(23, 2, 10, NULL, NULL, 0, NULL, NULL),
(24, 2, 11, NULL, NULL, 0, NULL, NULL),
(25, 2, 12, NULL, NULL, 0, NULL, NULL),
(26, 2, 13, NULL, NULL, 0, NULL, NULL),
(27, 3, 1, NULL, NULL, 0, NULL, NULL),
(28, 3, 2, NULL, NULL, 0, NULL, NULL),
(29, 3, 3, NULL, NULL, 0, NULL, NULL),
(30, 3, 4, NULL, NULL, 0, NULL, NULL),
(31, 3, 5, NULL, NULL, 0, NULL, NULL),
(32, 3, 6, NULL, NULL, 0, NULL, NULL),
(33, 3, 7, NULL, NULL, 0, NULL, NULL),
(34, 3, 8, NULL, NULL, 0, NULL, NULL),
(35, 3, 9, NULL, NULL, 0, NULL, NULL),
(36, 3, 10, NULL, NULL, 0, NULL, NULL),
(37, 3, 11, NULL, NULL, 0, NULL, NULL),
(38, 3, 12, NULL, NULL, 0, NULL, NULL),
(39, 3, 13, NULL, NULL, 0, NULL, NULL),
(40, 4, 1, NULL, NULL, 0, NULL, NULL),
(41, 4, 2, NULL, NULL, 0, NULL, NULL),
(42, 4, 3, NULL, NULL, 0, NULL, NULL),
(43, 4, 4, NULL, NULL, 0, NULL, NULL),
(44, 4, 5, NULL, NULL, 0, NULL, NULL),
(45, 4, 6, NULL, NULL, 0, NULL, NULL),
(46, 4, 7, NULL, NULL, 0, NULL, NULL),
(47, 4, 8, NULL, NULL, 0, NULL, NULL),
(48, 4, 9, NULL, NULL, 0, NULL, NULL),
(49, 4, 10, NULL, NULL, 0, NULL, NULL),
(50, 4, 11, NULL, NULL, 0, NULL, NULL),
(51, 4, 12, NULL, NULL, 0, NULL, NULL),
(52, 4, 13, NULL, NULL, 0, NULL, NULL),
(53, 5, 1, NULL, NULL, 0, NULL, NULL),
(54, 5, 2, NULL, NULL, 0, NULL, NULL),
(55, 5, 3, NULL, NULL, 0, NULL, NULL),
(56, 5, 4, NULL, NULL, 0, NULL, NULL),
(57, 5, 5, NULL, NULL, 0, NULL, NULL),
(58, 5, 6, NULL, NULL, 0, NULL, NULL),
(59, 5, 7, NULL, NULL, 0, NULL, NULL),
(60, 5, 8, NULL, NULL, 0, NULL, NULL),
(61, 5, 9, NULL, NULL, 0, NULL, NULL),
(62, 5, 10, NULL, NULL, 0, NULL, NULL),
(63, 5, 11, NULL, NULL, 0, NULL, NULL),
(64, 5, 12, NULL, NULL, 0, NULL, NULL),
(65, 5, 13, NULL, NULL, 0, NULL, NULL),
(66, 6, 1, NULL, NULL, 0, NULL, NULL),
(67, 6, 2, '2025-01-30 14:02:57', NULL, 1, NULL, NULL),
(68, 6, 3, NULL, NULL, 0, NULL, NULL),
(69, 6, 4, NULL, NULL, 0, NULL, NULL),
(70, 6, 5, NULL, NULL, 0, NULL, NULL),
(71, 6, 6, NULL, NULL, 0, NULL, NULL),
(72, 6, 7, NULL, NULL, 0, NULL, NULL),
(73, 6, 8, NULL, NULL, 0, NULL, NULL),
(74, 6, 9, NULL, NULL, 0, NULL, NULL),
(75, 6, 10, NULL, NULL, 0, NULL, NULL),
(76, 6, 11, NULL, NULL, 0, NULL, NULL),
(77, 6, 12, NULL, NULL, 0, NULL, NULL),
(78, 6, 13, NULL, NULL, 0, NULL, NULL),
(79, 9, 1, NULL, NULL, 0, NULL, NULL),
(80, 10, 1, NULL, NULL, 0, NULL, NULL),
(1001, 100, 1002, '2025-01-30 12:37:22', '2025-01-30 12:29:48', 0, NULL, NULL),
(1002, 100, 222, '2025-01-30 12:34:55', '2025-01-30 12:53:20', 0, NULL, NULL),
(1003, 6, 16, '2025-01-30 14:02:57', '2025-01-30 14:16:40', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `SALLE`
--

CREATE TABLE `SALLE` (
  `idSalle` int(11) NOT NULL,
  `nomSalle` varchar(100) NOT NULL,
  `numeroSalle` varchar(50) NOT NULL,
  `Etage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `SALLE`
--

INSERT INTO `SALLE` (`idSalle`, `nomSalle`, `numeroSalle`, `Etage`) VALUES
(1, '306', '306', 3),
(2, '307', '307', 3),
(3, '308', '308', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ALERTE`
--
ALTER TABLE `ALERTE`
  ADD PRIMARY KEY (`idAlerte`);

--
-- Indexes for table `BADGE`
--
ALTER TABLE `BADGE`
  ADD PRIMARY KEY (`idBadge`);

--
-- Indexes for table `COURS`
--
ALTER TABLE `COURS`
  ADD PRIMARY KEY (`idCours`),
  ADD KEY `idSalle` (`idSalle`);

--
-- Indexes for table `DETECTEUR`
--
ALTER TABLE `DETECTEUR`
  ADD PRIMARY KEY (`idDetecteur`),
  ADD KEY `idSalle` (`idSalle`);

--
-- Indexes for table `PRESENCE`
--
ALTER TABLE `PRESENCE`
  ADD PRIMARY KEY (`idPresence`),
  ADD KEY `idCours` (`idCours`),
  ADD KEY `idBadge` (`idBadge`);

--
-- Indexes for table `SALLE`
--
ALTER TABLE `SALLE`
  ADD PRIMARY KEY (`idSalle`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `BADGE`
--
ALTER TABLE `BADGE`
  MODIFY `idBadge` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1009;

--
-- AUTO_INCREMENT for table `COURS`
--
ALTER TABLE `COURS`
  MODIFY `idCours` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `DETECTEUR`
--
ALTER TABLE `DETECTEUR`
  MODIFY `idDetecteur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `PRESENCE`
--
ALTER TABLE `PRESENCE`
  MODIFY `idPresence` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1004;

--
-- AUTO_INCREMENT for table `SALLE`
--
ALTER TABLE `SALLE`
  MODIFY `idSalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `COURS`
--
ALTER TABLE `COURS`
  ADD CONSTRAINT `COURS_ibfk_1` FOREIGN KEY (`idSalle`) REFERENCES `SALLE` (`idSalle`) ON DELETE CASCADE;

--
-- Constraints for table `DETECTEUR`
--
ALTER TABLE `DETECTEUR`
  ADD CONSTRAINT `DETECTEUR_ibfk_1` FOREIGN KEY (`idSalle`) REFERENCES `SALLE` (`idSalle`) ON DELETE CASCADE;

--
-- Constraints for table `PRESENCE`
--
ALTER TABLE `PRESENCE`
  ADD CONSTRAINT `PRESENCE_ibfk_1` FOREIGN KEY (`idCours`) REFERENCES `COURS` (`idCours`),
  ADD CONSTRAINT `PRESENCE_ibfk_2` FOREIGN KEY (`idBadge`) REFERENCES `BADGE` (`idBadge`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
