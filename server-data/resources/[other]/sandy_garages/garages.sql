CREATE TABLE `owned_vehicles` (
  `id` int(55) NOT NULL AUTO_INCREMENT,
  `owner` varchar(22) COLLATE utf8mb4_bin NOT NULL,
  `vehicle` longtext COLLATE utf8mb4_bin NULL,
  `owner_type` int(2) DEFAULT 1 NOT NULL,
  `state` int(4)  DEFAULT 0 NOT NULL,
  `plate` varchar(12) COLLATE utf8mb4_bin NOT NULL,
  `vehicleid` int(11) DEFAULT NULL,
  `model` varchar(22) COLLATE utf8mb4_bin NOT NULL,
  `zlom` varchar(22) COLLATE utf8mb4_bin NOT NULL,
  `zlomed` varchar(22) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;