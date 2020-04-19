INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_mafia','Mafia',1),
	('property_black_money_mafia', 'Argent Sale Mafia', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_mafia','Mafia',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_mafia', 'Mafia', 1)
;

INSERT INTO `jobs3` (`name`, `label`, `whitelisted`) VALUES
	('mafia', 'Mafia', 1)
;

INSERT INTO `job3_grades` (`job3_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('mafia', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
	('mafia', 1, 'capo', 'Capo', 1800, '{}', '{}'),
	('mafia', 2, 'consigliere', 'Consigliere', 2100, '{}', '{}'),
	('mafia', 3, 'boss', 'Parain', 2700, '{}', '{}')
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
	('licmafia', 'Formulaire cession mafia', 1, 0, 1)
;