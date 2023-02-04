CREATE TABLE IF NOT EXISTS `users` (
  `iban` varchar(50) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `banklog` (
  `identifier` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `money` varchar(50) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;
