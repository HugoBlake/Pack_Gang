INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_bloods','Bloods',1),
	('property_black_money_bloods', 'Argent Sale Bloods', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_bloods','Bloods',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_bloods', 'Bloods', 1)
;

INSERT INTO `jobs3` (`name`, `label`, `whitelisted`) VALUES
	('bloods', 'Bloods', 1)
;

INSERT INTO `job3_grades` (`job3_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('bloods', 0, 'soldato', 'Dealer', 200, 'null', 'null'),
	('bloods', 1, 'capo', 'Braqueur', 400, 'null', 'null'),
	('bloods', 2, 'consigliere', 'Bandit', 600, 'null', 'null'),
	('bloods', 3, 'boss', 'Chef du Gang', 1000, 'null', 'null')
;

CREATE TABLE `racket_organisation` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  
  PRIMARY KEY (`id`)
);

INSERT INTO `racket_organisation` (label, amount, category) VALUES 
	('Raket',3000,0),
	('Raket',5000,0),
	('Raket',10000,1),
	('Raket',20000,1),
	('Raket',50000,2),
	('Raket',150000,3),
	('Raket',350000,3)
;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('licbloods', 'Formulaire cession bloods', 1, 0, 1)
;