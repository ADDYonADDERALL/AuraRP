CREATE TABLE `expsystem` (
  `identifier` varchar(55) NOT NULL AUTO_INCREMENT,
  `kurierlvl` int(55) NOT NULL
  `kurierexp` int(55) NOT NULL
  `nick` varchar(55) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	('paczkadoj', 'Paczka (DOJ)', 20),
	('paczkahumane', 'Paczka (HUMANE)', 20),
	('paczkapacific', 'Paczka (BANK)', 20),
	('paczkacoffee', 'Paczka (RESTAURACJA)', 20),
	('paczkalsc', 'Paczka (LSC)', 20),
	('paczkaems', 'Paczka (EMS)', 20),
	('paczkapolice', 'Paczka (LSPD)', 20),
;

INSERT INTO `jobs` (name, label) VALUES
	('deliverer', 'Kurier')
;

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(NULL, 'deliverer', 0, 'kurier', 'Kurier', 250, '{}', '{}')
;
