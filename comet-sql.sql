-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.25-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for cometrp
CREATE DATABASE IF NOT EXISTS `cometrp` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `cometrp`;

-- Dumping structure for table cometrp.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL DEFAULT 'John',
  `last_name` varchar(50) NOT NULL DEFAULT 'Doe',
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dob` varchar(50) DEFAULT 'NULL',
  `cash` int(9) DEFAULT 500,
  `bank` int(9) NOT NULL DEFAULT 5000,
  `phone_number` longtext NOT NULL,
  `story` text NOT NULL,
  `new` int(1) NOT NULL DEFAULT 1,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `gender` int(1) NOT NULL DEFAULT 0,
  `jail_time` int(11) NOT NULL DEFAULT 0,
  `stress_level` int(11) DEFAULT 0,
  `metaData` varchar(1520) DEFAULT '{}',
  `bones` mediumtext DEFAULT '{}',
  `emotes` varchar(4160) DEFAULT '{}',
  `paycheck` int(11) DEFAULT 0,
  `meta` text DEFAULT 'move_m@casual@d',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.characters: ~2 rows (approximately)
INSERT IGNORE INTO `characters` (`id`, `owner`, `first_name`, `last_name`, `date_created`, `dob`, `cash`, `bank`, `phone_number`, `story`, `new`, `deleted`, `gender`, `jail_time`, `stress_level`, `metaData`, `bones`, `emotes`, `paycheck`, `meta`) VALUES
	(7, 'steam:11000013ef17842', 'Angus', 'Beef', '2023-07-23 13:23:27', '2000-01-01', 575927, 98194999, '5693054199', 'Default story - new char system', 1, 0, 0, 0, 0, '{"thirst":81,"health":186,"hunger":80,"armour":0}', '[{"hitcount":0,"offset2":0.35,"boneIndex":11816,"part":"Pelvis","maxhit":false,"zone":0,"injuryType":4,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.8,"boneIndex":58271,"part":"Left Thigh","maxhit":false,"zone":4,"injuryType":4,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.35,"boneIndex":47495,"part":"Mouth","maxhit":false,"zone":1,"injuryType":1,"offset1":0.45,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":14201,"part":"Left Foot","maxhit":true,"zone":4,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.55,"boneIndex":46078,"part":"Left Knee","maxhit":false,"zone":4,"injuryType":4,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.8,"boneIndex":51826,"part":"Right Thigh","maxhit":false,"zone":5,"injuryType":4,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.35,"boneIndex":24816,"part":"Spine Lower","maxhit":false,"zone":0,"injuryType":5,"offset1":0.25,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":52301,"part":"Right Foot","maxhit":true,"zone":5,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.55,"boneIndex":16335,"part":"Right Knee","maxhit":false,"zone":5,"injuryType":4,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.55,"boneIndex":24817,"part":"Spine Mid","maxhit":false,"zone":0,"injuryType":5,"offset1":0.25,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":60309,"part":"Left Hand","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":22711,"part":"Left Elbow","maxhit":false,"zone":2,"injuryType":3,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":57005,"part":"Right Hand","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":2992,"part":"Right Elbow","maxhit":false,"zone":3,"injuryType":3,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.95,"boneIndex":39317,"part":"Neck","maxhit":false,"zone":0,"injuryType":5,"offset1":0.25,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":31086,"part":"Head","maxhit":false,"zone":1,"injuryType":2,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.85,"boneIndex":24818,"part":"Spine High","maxhit":false,"zone":0,"injuryType":5,"offset1":0.25,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":64729,"part":"Left Clavicle","maxhit":false,"zone":0,"injuryType":3,"offset1":0.15,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":26610,"part":"Left Finger Pinky","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":26611,"part":"Left Finger Index","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":26612,"part":"Left Finger Middle","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":26613,"part":"Left Finger Ring","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":26614,"part":"Left Finger Thumb","maxhit":true,"zone":2,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":10706,"part":"Right Clavicle","maxhit":false,"zone":0,"injuryType":3,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":58866,"part":"Right Finger Pinky","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":58867,"part":"Right Finger Index","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":58868,"part":"Right Finger Middle","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":58869,"part":"Right Finger Ring","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.2,"boneIndex":58870,"part":"Right Finger Thumb","maxhit":true,"zone":3,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.45,"boneIndex":21550,"part":"Face Left CheekBone","maxhit":false,"zone":1,"injuryType":1,"offset1":0.55,"timer":0,"applied":false},{"hitcount":0,"offset2":0.45,"boneIndex":19336,"part":"Face Right CheekBone","maxhit":false,"zone":1,"injuryType":1,"offset1":0.35,"timer":0,"applied":false},{"hitcount":0,"offset2":0.75,"boneIndex":37193,"part":"Forehead","maxhit":false,"zone":1,"injuryType":2,"offset1":0.45,"timer":0,"applied":false},{"hitcount":0,"offset2":0.35,"boneIndex":61839,"part":"Face UpperLip","maxhit":true,"zone":1,"injuryType":1,"offset1":0.45,"timer":0,"applied":false},{"hitcount":0,"offset2":0.35,"boneIndex":20623,"part":"Face LowerLip","maxhit":true,"zone":1,"injuryType":1,"offset1":0.45,"timer":0,"applied":false}]', '{}', 13171, 'move_m@casual@d'),
	(8, 'steam:110000148a4042d', 'Austin', 'Rinehart', '2023-07-20 09:05:41', '1999-01-01', 29200, 99904999, '25939941', 'Default story - new char system', 1, 0, 0, 0, 0, '{"hunger":29,"armour":0,"thirst":27,"health":182}', '{}', '{}', 609, 'move_m@casual@d');

-- Dumping structure for table cometrp.characters_cars
CREATE TABLE IF NOT EXISTS `characters_cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `purchase_price` float DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `vehicle_state` longtext DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `name` varchar(50) DEFAULT NULL,
  `engine_damage` bigint(19) unsigned DEFAULT 1000,
  `body_damage` bigint(20) DEFAULT 1000,
  `degredation` longtext DEFAULT '100,100,100,100,100,100,100,100',
  `current_garage` varchar(50) DEFAULT 'T',
  `financed` int(11) DEFAULT 0,
  `finance_time` int(11) DEFAULT 0,
  `last_payment` int(11) DEFAULT 0,
  `coords` longtext DEFAULT NULL,
  `license_plate` varchar(255) NOT NULL DEFAULT '',
  `payments_left` int(3) DEFAULT 0,
  `server_number` int(11) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `repoed` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.characters_cars: ~18 rows (approximately)
INSERT IGNORE INTO `characters_cars` (`id`, `owner`, `cid`, `purchase_price`, `model`, `vehicle_state`, `fuel`, `name`, `engine_damage`, `body_damage`, `degredation`, `current_garage`, `financed`, `finance_time`, `last_payment`, `coords`, `license_plate`, `payments_left`, `server_number`, `data`, `repoed`) VALUES
	(1, 'steam:11000013ef17842', 7, 5000, 'taco', 'In', 65, 'TACO', 1000, 1000, '100,100,100,100,100,100,100,100', 'T', 0, 0, 0, NULL, 'DZYD7241', 0, NULL, NULL, 0),
	(2, 'steam:11000013ef17842', 7, 55200, 'tropos', 'In', 60, 'TROPOS', 1000, 1000, '100,100,100,100,100,100,99,100', 'T', 0, 0, 0, NULL, 'VJGH6452', 0, NULL, NULL, 0),
	(3, 'steam:11000013ef17842', 7, 51750, 'dubsta2', 'In', 0, 'DUBSTA', 998, 998, '93,98,91,89,86,88,93,94', 'T', 0, 0, 0, NULL, 'QSXZ2068', 0, NULL, NULL, 0),
	(4, 'steam:11000013ef17842', 7, 86250, 'verlierer2', 'In', 65, 'VERLIER', 860, 920, '98,98,99,98,98,100,99,99', 'T', 0, 0, 0, NULL, 'CINJ9486', 0, NULL, NULL, 0),
	(5, 'steam:11000013ef17842', 7, 41400, 'kuruma', 'In', 0, 'KURUMA', 969, 893, '78,72,78,82,79,90,82,82', 'T', 0, 0, 0, '{"x":1266.8685302734376,"y":-2562.527099609375,"z":42.5800552368164}', 'GCAM5101', 0, NULL, '{"plateIndex":3,"neon":{"1":false,"2":false,"3":false,"0":false},"extras":[0,0,0,0,0,0,0,0,0,0,0,0],"mods":{"1":-1,"2":-1,"3":-1,"4":-1,"5":-1,"6":-1,"7":-1,"8":-1,"9":-1,"10":-1,"11":-1,"12":-1,"13":-1,"14":-1,"15":-1,"16":-1,"17":false,"18":false,"19":false,"20":false,"21":false,"22":false,"23":-1,"24":-1,"25":-1,"26":-1,"27":-1,"28":-1,"29":-1,"30":-1,"31":-1,"32":-1,"33":-1,"34":-1,"35":-1,"36":-1,"37":-1,"38":-1,"39":-1,"40":-1,"41":-1,"42":-1,"43":-1,"44":-1,"45":-1,"46":-1,"47":-1,"48":8,"0":0},"wheeltype":0,"platestyle":3,"oldLiveries":-1,"lights":[255,0,255],"colors":[0,0],"extracolors":[0,0],"xenonColor":255,"dashColour":0,"interColour":0,"smokecolor":[255,255,255],"tint":1}', 0),
	(6, 'steam:11000013ef17842', 7, 63250, 'contender', 'In', 0, 'CONTENDER', 705, 514, '99,99,99,99,97,99,96,97', 'T', 0, 0, 0, NULL, 'ZXUS5096', 0, NULL, NULL, 0),
	(7, 'steam:11000013ef17842', 7, 0, 'pdcharger', 'In', 0, 'pdcharger', 888, 537, '93,96,99,92,99,96,96,96', 'T', 0, 0, 0, NULL, '89NOV481', 0, NULL, 'null', 0),
	(8, 'steam:11000013ef17842', 7, 0, 'dirtbike', 'In', 65, 'dirtbike', 1000, 1000, '100,100,100,100,100,100,100,100', 'T', 0, 0, 0, NULL, '85HEA492', 0, NULL, 'null', 0),
	(9, 'steam:11000013ef17842', 7, 0, 'pdcharger', 'In', 100, 'pdcharger', 1000, 1000, '100,100,100,100,100,100,100,100', 'Police Department', 0, 0, 0, NULL, '69NEO748', 0, NULL, 'null', 0),
	(10, 'steam:11000013ef17842', 7, 0, 'pdmustang', 'In', 0, 'pdmustang', 1000, 1000, '100,97,99,99,100,100,98,100', 'Police Department', 0, 0, 0, NULL, '83ZAB028', 0, NULL, 'null', 0),
	(11, 'steam:11000013ef17842', 7, 95450, 'dominator', 'In', 0, 'DOMINATO', 1000, 1000, '100,100,100,100,98,99,97,96', 'T', 0, 0, 0, NULL, 'EQTU6108', 0, NULL, NULL, 0),
	(12, 'steam:11000013ef17842', 7, 0, 'polraptor', 'In', 100, 'polraptor', 1000, 1000, '100,100,100,100,100,100,100,100', 'Police Department', 0, 0, 0, NULL, '66RWA132', 0, NULL, 'null', 0),
	(13, 'steam:11000013ef17842', 7, 0, 'pdcorvette', 'In', 100, 'pdcorvette', 1000, 1000, '100,100,100,100,100,100,100,100', 'Police Department', 0, 0, 0, NULL, '64RTV868', 0, NULL, 'null', 0),
	(14, 'steam:110000148a4042d', 8, 71300, 'ruiner3', 'In', 0, 'RUINER', 998, 977, '99,99,100,99,100,100,100,100', 'T', 0, 0, 0, NULL, 'JXZW8686', 0, NULL, NULL, 0),
	(15, 'steam:11000013ef17842', 7, 74750, 'clique', 'In', 0, 'CLIQUE', 951, 773, '99,99,100,97,100,100,100,100', 'T', 0, 0, 0, NULL, 'AFPS2999', 0, NULL, NULL, 0),
	(16, 'steam:11000013ef17842', 7, 35650, 'streiter', 'In', 100, 'STREITER', 1000, 1000, '100,100,100,100,100,100,100,100', 'T', 0, 0, 0, NULL, 'URJD2083', 0, NULL, NULL, 0),
	(17, 'steam:11000013ef17842', 7, 57500, 'dubsta3', 'In', 80, 'DUBSTA3', 1000, 1000, '100,100,100,100,100,100,100,100', 'T', 0, 0, 0, NULL, 'MZKR6522', 0, NULL, NULL, 0),
	(18, 'steam:11000013ef17842', 7, 47150, 'baller3', 'In', 0, 'BALLER3', 983, 950, '100,100,100,100,100,99,100,100', 'T', 0, 0, 0, NULL, 'XULU3683', 0, NULL, NULL, 0),
	(19, 'steam:11000013ef17842', 7, 0, 'pdchallenger', 'In', 0, 'pdchallenger', 1000, 1000, '100,100,100,100,100,100,100,100', 'Police Department', 0, 0, 0, NULL, '00DSD994', 0, NULL, 'null', 0);

-- Dumping structure for table cometrp.characters_weapons
CREATE TABLE IF NOT EXISTS `characters_weapons` (
  `id` int(11) NOT NULL DEFAULT 0,
  `type` varchar(255) DEFAULT NULL,
  `ammo` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.characters_weapons: ~2 rows (approximately)
INSERT IGNORE INTO `characters_weapons` (`id`, `type`, `ammo`) VALUES
	(7, '218444191', 150),
	(7, '1950175060', 150);

-- Dumping structure for table cometrp.character_current
CREATE TABLE IF NOT EXISTS `character_current` (
  `cid` int(11) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `drawables` mediumtext DEFAULT NULL,
  `props` mediumtext DEFAULT NULL,
  `drawtextures` mediumtext DEFAULT NULL,
  `proptextures` mediumtext DEFAULT NULL,
  `assExists` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.character_current: ~2 rows (approximately)
INSERT IGNORE INTO `character_current` (`cid`, `model`, `drawables`, `props`, `drawtextures`, `proptextures`, `assExists`) VALUES
	(7, '1885233650', '{"1":["masks",0],"2":["hair",35],"3":["torsos",11],"4":["legs",30],"5":["bags",10],"6":["shoes",35],"7":["neck",78],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",112],"0":["face",0]}', '{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}', '[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]', '[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]', NULL),
	(8, '1885233650', '{"1":["masks",0],"2":["hair",4],"3":["torsos",179],"4":["legs",111],"5":["bags",0],"6":["shoes",25],"7":["neck",0],"8":["undershirts",44],"9":["vest",0],"10":["decals",-1],"11":["jackets",248],"0":["face",0]}', '{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}', '[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]', '[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]', NULL);

-- Dumping structure for table cometrp.character_face
CREATE TABLE IF NOT EXISTS `character_face` (
  `cid` int(11) DEFAULT NULL,
  `hairColor` mediumtext DEFAULT NULL,
  `headBlend` mediumtext DEFAULT NULL,
  `headOverlay` mediumtext DEFAULT NULL,
  `headStructure` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.character_face: ~2 rows (approximately)
INSERT IGNORE INTO `character_face` (`cid`, `hairColor`, `headBlend`, `headOverlay`, `headStructure`) VALUES
	(7, '[1,1]', '{"shapeSecond":2,"shapeFirst":44,"shapeThird":0,"skinSecond":4,"skinThird":0,"thirdMix":0.0,"shapeMix":0.50999999046325,"hasParent":false,"skinMix":1.0,"skinFirst":15}', '[{"firstColour":0,"overlayValue":255,"name":"Blemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"FacialHair","colourType":1,"overlayOpacity":0.0,"secondColour":0},{"firstColour":0,"overlayValue":30,"name":"Eyebrows","colourType":1,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Ageing","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Makeup","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Blush","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Complexion","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"SunDamage","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Lipstick","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"MolesFreckles","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"ChestHair","colourType":1,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"BodyBlemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"AddBodyBlemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0}]', '[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]'),
	(8, '[1,1]', '{"shapeSecond":0,"skinSecond":0,"shapeThird":0,"shapeMix":0.0,"skinThird":0,"thirdMix":0.0,"shapeFirst":0,"hasParent":false,"skinMix":1.0,"skinFirst":15}', '[{"firstColour":0,"overlayValue":255,"name":"Blemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"FacialHair","colourType":1,"overlayOpacity":0.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Eyebrows","colourType":1,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Ageing","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Makeup","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Blush","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Complexion","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"SunDamage","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"Lipstick","colourType":2,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"MolesFreckles","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"ChestHair","colourType":1,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"BodyBlemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0},{"firstColour":0,"overlayValue":255,"name":"AddBodyBlemishes","colourType":0,"overlayOpacity":1.0,"secondColour":0}]', '[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]');

-- Dumping structure for table cometrp.character_outfits
CREATE TABLE IF NOT EXISTS `character_outfits` (
  `cid` int(11) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `name` text DEFAULT NULL,
  `slot` int(11) DEFAULT NULL,
  `drawables` text DEFAULT '{}',
  `props` text DEFAULT '{}',
  `drawtextures` text DEFAULT '{}',
  `proptextures` text DEFAULT '{}',
  `hairColor` text DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.character_outfits: ~0 rows (approximately)

-- Dumping structure for table cometrp.character_passes
CREATE TABLE IF NOT EXISTS `character_passes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 1,
  `name` text NOT NULL,
  `giver` text NOT NULL,
  `pass_type` text NOT NULL,
  `business_name` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.character_passes: ~0 rows (approximately)

-- Dumping structure for table cometrp.cl_spawnselector
CREATE TABLE IF NOT EXISTS `cl_spawnselector` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.cl_spawnselector: ~5 rows (approximately)
INSERT IGNORE INTO `cl_spawnselector` (`id`, `location_data`) VALUES
	(1, '{"locationText":"Hospital","iconColor":"rgb(51, 51, 51)","iconName":"fas fa-hospital","screenPosition":{"left":510,"resolution":{"height":1080,"width":1920},"top":571},"backgroundColor":"rgb(253, 92, 99)"}'),
	(2, '{"locationText":"Legion Square","iconColor":"rgb(51, 51, 51)","iconName":"fas fa-tree","screenPosition":{"left":477,"resolution":{"height":1080,"width":1920},"top":546},"backgroundColor":"#c3f2cb"}'),
	(3, '{"locationText":"Airport","iconColor":"rgb(51, 51, 51)","iconName":"fas fa-cart-flatbed-suitcase","screenPosition":{"left":167,"resolution":{"height":1080,"width":1920},"top":391},"backgroundColor":"rgb(200, 237, 253)"}'),
	(4, '{"locationText":"Mount Chiliad","iconColor":"rgb(51, 51, 51)","iconName":"fas fa-person-hiking","screenPosition":{"left":1520,"resolution":{"height":1080,"width":1920},"top":595},"backgroundColor":"rgb(129, 104, 2)"}'),
	(5, '{"locationText":"MRPD","iconColor":"rgb(51, 51, 51)","iconName":"fas fa-shield","screenPosition":{"left":454,"resolution":{"height":1080,"width":1920},"top":587},"backgroundColor":"rgb(124, 185, 232)"}');

-- Dumping structure for table cometrp.containers
CREATE TABLE IF NOT EXISTS `containers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(50) DEFAULT NULL,
  `x` int(11) DEFAULT 0,
  `y` int(11) DEFAULT 0,
  `z` int(11) DEFAULT 0,
  `heading` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.containers: ~0 rows (approximately)

-- Dumping structure for table cometrp.delivery_job
CREATE TABLE IF NOT EXISTS `delivery_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` float DEFAULT NULL,
  `jobType` varchar(50) DEFAULT NULL,
  `dropAmount` int(2) DEFAULT NULL,
  `pickup` varchar(255) DEFAULT NULL,
  `drop` varchar(255) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table cometrp.delivery_job: ~0 rows (approximately)

-- Dumping structure for table cometrp.exploiters
CREATE TABLE IF NOT EXISTS `exploiters` (
  `type` text DEFAULT NULL,
  `log` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.exploiters: ~0 rows (approximately)

-- Dumping structure for table cometrp.fine_types
CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `jailtime` int(11) DEFAULT 0,
  `category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table cometrp.fine_types: ~143 rows (approximately)
INSERT IGNORE INTO `fine_types` (`id`, `label`, `amount`, `jailtime`, `category`) VALUES
	(1, 'Failure to use signal', 30, 2, 0),
	(2, 'Illegal Passing', 30, 2, 0),
	(3, 'Excessive vehicle noise', 30, 2, 0),
	(4, 'Failing to stop at a Stop Sign ', 50, 3, 0),
	(5, 'Failing to stop at a Red Light', 50, 3, 0),
	(6, 'Following to closely', 50, 3, 0),
	(7, 'Failure to yield', 100, 3, 0),
	(8, 'Illegal Parking', 100, 3, 0),
	(9, 'Illegal Turn', 100, 3, 0),
	(10, 'Illegal Passing', 100, 3, 0),
	(11, 'Impeding traffic flow', 120, 3, 0),
	(12, 'Illegal U-Turn', 140, 3, 0),
	(13, 'Traveling Wrong Way', 150, 4, 0),
	(14, 'Hit and Run', 300, 6, 0),
	(15, 'Negligent Driving', 400, 6, 0),
	(16, 'Driving an illegal Vehicle', 500, 10, 0),
	(17, 'Operation of a Non-Street Legal Vehicle', 500, 10, 0),
	(18, 'Driving without a License', 700, 10, 0),
	(19, 'Reckless Driving', 800, 10, 0),
	(20, 'Felony Speeding', 800, 10, 0),
	(21, 'Exceeding Speeds Over < 5 mph', 30, 2, 0),
	(22, 'Exceeding Speeds Over 5-15 mph', 80, 3, 0),
	(23, 'Exceeding Speeds Over 15-30 mph', 175, 6, 0),
	(24, 'Exceeding Speeds Over > 30 mph', 250, 10, 0),
	(25, 'Improvised Armoured Vehicle', 800, 15, 0),
	(26, 'Driving with a suspended license', 820, 10, 0),
	(27, 'Vehicle Tampering', 800, 6, 0),
	(28, 'Vehicle Theft', 1000, 15, 0),
	(29, 'Possession of a stolen vehicle', 1000, 15, 0),
	(30, 'Grand Theft Auto', 1200, 15, 0),
	(31, 'Hit and Run', 1500, 15, 0),
	(32, 'Driving Under the Influence / Driving While Intoxicated (DUI / DWI, 0),', 1500, 20, 0),
	(33, 'Felony Evasion', 2000, 20, 0),
	(34, 'Misuse of 911', 400, 2, 0),
	(35, 'Loitering', 420, 2, 0),
	(36, 'Public Intoxication', 450, 2, 0),
	(37, 'Idecent Exposure', 500, 3, 0),
	(38, 'Vandalism', 500, 3, 0),
	(39, 'Trespassing', 500, 3, 0),
	(40, 'Harassment', 500, 3, 0),
	(41, 'Possession without a permit', 700, 5, 0),
	(42, 'Possession of a Handgun in public', 700, 5, 0),
	(43, 'Failure to Inform', 735, 5, 0),
	(44, 'Failure to Identify', 740, 5, 0),
	(45, 'Stalking', 750, 5, 0),
	(46, 'Possession of a Shotgun in public', 800, 7, 0),
	(47, 'Disturbing the Peace', 800, 8, 0),
	(48, 'Theft', 1000, 10, 0),
	(49, 'Battery', 1200, 10, 0),
	(50, 'Destruction of Physical Evidence', 1500, 15, 0),
	(51, 'Criminal Threats', 1500, 10, 0),
	(52, 'Brandishing a Firearm', 1500, 10, 0),
	(53, 'Failure to comply with a lawful order', 1530, 10, 0),
	(54, 'Vandalism of Goverment Property', 1600, 15, 0),
	(55, 'Possession of a Rifle in public', 2000, 15, 0),
	(56, 'Assault', 2000, 15, 0),
	(57, 'Unlawful Discharge of a Firearm', 2200, 15, 0),
	(58, 'Brandishing a Deadly Weapon', 2250, 15, 0),
	(59, 'Resisting Arrest', 2500, 12, 0),
	(60, 'Obstruction of Justice', 2500, 12, 0),
	(61, 'Reckless Endangerment', 2600, 12, 0),
	(62, 'Bribery', 1000, 10, 0),
	(64, 'Drive-By Shooting', 1500, 15, 0),
	(65, 'Maintaining a Place for the Purpose of Distribution', 1500, 15, 0),
	(66, 'Possesion of a Controlled Substance inside residence', 1550, 15, 0),
	(67, 'Felon in Possession of Ammunition', 1600, 15, 0),
	(68, 'Felon in Possession of a Firearm', 1650, 17, 0),
	(69, 'Possesion of a Controlled Substance with Intent to sell', 2000, 15, 0),
	(70, 'Distribution of Firearms', 2200, 18, 0),
	(71, 'Transporting Illegal Firearms', 2300, 20, 0),
	(72, 'Money Laundering', 2500, 20, 0),
	(73, 'Sale of a Controlled Substance', 2700, 17, 0),
	(74, 'Extortion', 2700, 20, 0),
	(75, 'Drug Trafficking', 2800, 20, 0),
	(76, 'Possession of Explosives', 3000, 25, 0),
	(77, 'Possession of Illegal Firearm', 3000, 20, 0),
	(78, 'Distribution of Illegal Firearms', 3200, 25, 0),
	(79, 'Manufacture of a Controlled Substance', 3500, 20, 0),
	(80, 'Racketeering / RICO', 50000, 99999999, 0),
	(81, 'Terroristic Threat', 600, 15, 0),
	(82, 'False Imprisonment', 600, 10, 0),
	(83, 'Felony Battery', 750, 12, 0),
	(84, 'Attempted Armed Roberry', 1000, 15, 0),
	(85, 'Kidnapping', 1000, 15, 0),
	(86, 'Terroristic Acts', 1000, 15, 0),
	(87, 'Armed Robbery', 2000, 20, 0),
	(88, 'Assault with Deadly Firearm', 2000, 20, 0),
	(89, 'Vehicular Manslaughter', 2500, 20, 0),
	(90, 'Battery on a Peace Officer', 3000, 25, 0),
	(91, 'Attempted Murder', 3500, 25, 0),
	(92, 'Bank Robbery', 3500, 20, 0),
	(93, 'Second Degree Murder', 4000, 25, 0),
	(94, 'Manslaughter', 4500, 28, 0),
	(95, 'Arson', 4500, 25, 0),
	(96, 'First Degree Murder', 5000, 30, 0),
	(97, 'Attempted Murder of a Peace Officer', 6000, 30, 0),
	(98, 'Organ Harvesting', 1500, 35, 0),
	(99, 'Possession of Class 1 Weapon', 250, 3, 0),
	(100, 'Possession of Class 2 Weapon', 1000, 6, 0),
	(101, 'Possession of Government Equipment', 1000, 10, 0),
	(102, 'Possession of Class 3 Firearm', 2500, 15, 0),
	(103, 'Possession of Explosives', 1500, 10, 0),
	(104, 'Drug Cultivation and Manufacturing', 500, 10, 0),
	(105, 'Drug Distribution/Intent to Distrubute - Class 1', 500, 5, 0),
	(106, 'Drug Distribution/Intent to Distrubute - Class 2', 1000, 10, 0),
	(107, 'Possession of Class 1 Narcotics', 200, 5, 0),
	(108, 'Sexual Harassment', 1500, 20, 0),
	(109, 'Aiding & Abetting of a Felony', 1000, 10, 0),
	(110, 'Escaping Custody', 750, 12, 0),
	(111, 'Jail Break', 1500, 15, 0),
	(112, 'Joy Riding', 200, 8, 0),
	(113, 'Fleeing & Eluding', 600, 8, 0),
	(114, 'Burglary', 500, 10, 0),
	(115, 'Impersonation of a Government Official', 750, 12, 0),
	(116, 'Destruction of Property', 0, 8, 0),
	(117, 'Destruction of Government Property', 500, 10, 0),
	(118, 'Possession of Weapon Attachment', 2000, 15, 0),
	(119, 'Possession of Contraband', 150, 8, 0),
	(120, 'Disorderly Conduct', 400, 5, 0),
	(121, 'Poaching', 2000, 10, 0),
	(122, 'Forgery', 500, 10, 0),
	(123, 'Drug Paraphernalia', 150, 5, 0),
	(124, 'Petty Theft', 500, 5, 0),
	(125, 'Possession of Stolen Goods', 1000, 8, 0),
	(126, 'Corruption', 0, 15, 0),
	(127, 'Human Trafficking', 2500, 30, 0),
	(128, 'Operation of a Aircraft', 1500, 10, 0),
	(129, 'Violation of a No Fly Zone', 2000, 15, 0),
	(130, 'Operation of Non-Street Legal Vehicle', 1500, 10, 0),
	(131, 'Perjury', 1000, 18, 0),
	(132, 'Obstruction of Justice', 2000, 20, 0),
	(133, 'Contempt of Court', 2500, 15, 0),
	(134, 'Breaking and Entering', 150, 10, 0),
	(135, 'False Report', 100, 5, 0),
	(136, 'Conspiracy', 500, 10, 0),
	(137, 'Solicitation', 75, 6, 0),
	(138, 'Attempted Commission of a Crime', 500, 10, 0),
	(139, 'Illegal Window Tint', 250, 0, 0),
	(140, 'Possession Of A PD Weapon', 15000, 25, 0),
	(143, 'Possesion of Explosives', 20000, 40, 0),
	(144, 'Armed Robbery of the Union Depository', 10000, 30, 0),
	(145, 'Armed Robbery Of The Vault', 8000, 30, 0),
	(146, 'Usage Of A AirCraft without proper license', 5000, 30, 0);

-- Dumping structure for table cometrp.gangs
CREATE TABLE IF NOT EXISTS `gangs` (
  `cid` int(11) NOT NULL DEFAULT 0,
  `gang_name` mediumtext NOT NULL,
  `reputation` int(11) NOT NULL DEFAULT 0,
  `leader` mediumtext NOT NULL DEFAULT '0',
  `ingang` mediumtext NOT NULL DEFAULT '0',
  `grove` int(11) NOT NULL DEFAULT 0,
  `covenant` int(11) NOT NULL DEFAULT 0,
  `brouge` int(11) NOT NULL DEFAULT 0,
  `forum` int(11) NOT NULL DEFAULT 0,
  `jamestown` int(11) NOT NULL DEFAULT 0,
  `mirrorpark` int(11) NOT NULL DEFAULT 0,
  `fudge` int(11) NOT NULL DEFAULT 0,
  `vespucci` int(11) NOT NULL DEFAULT 0,
  `cougar` int(11) NOT NULL DEFAULT 0,
  `harmony` int(11) unsigned NOT NULL DEFAULT 0,
  `mainstreet` int(11) unsigned NOT NULL DEFAULT 0,
  `mission1` int(11) unsigned NOT NULL DEFAULT 0,
  `mission2` int(11) unsigned NOT NULL DEFAULT 0,
  `mission3` int(11) unsigned NOT NULL DEFAULT 0,
  `mission4` int(11) unsigned NOT NULL DEFAULT 0,
  `mission5` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.gangs: ~12 rows (approximately)
INSERT IGNORE INTO `gangs` (`cid`, `gang_name`, `reputation`, `leader`, `ingang`, `grove`, `covenant`, `brouge`, `forum`, `jamestown`, `mirrorpark`, `fudge`, `vespucci`, `cougar`, `harmony`, `mainstreet`, `mission1`, `mission2`, `mission3`, `mission4`, `mission5`) VALUES
	(71, 'Grove Street Families', -7, '1', '1', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
	(85, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(102, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(175, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
	(177, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
	(252, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(360, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(370, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(378, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(381, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(386, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(662, 'Grove Street Families', -7, '0', '1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Dumping structure for table cometrp.group_banking
CREATE TABLE IF NOT EXISTS `group_banking` (
  `group_type` mediumtext DEFAULT NULL,
  `bank` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.group_banking: ~11 rows (approximately)
INSERT IGNORE INTO `group_banking` (`group_type`, `bank`) VALUES
	('burger_shot', 0),
	('police', 196552),
	('ems', 0),
	('car_shop', 0),
	('tuner_shop', 0),
	('best_buds', 0),
	('bean_machine', 0),
	('vanilla_unicorn', 0),
	('auto_bodies', 0),
	('drift_school', 0),
	('paleto_mech', 0);

-- Dumping structure for table cometrp.jobs_whitelist
CREATE TABLE IF NOT EXISTS `jobs_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `job` varchar(50) DEFAULT 'unemployed',
  `rank` int(11) DEFAULT 0,
  `callsign` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.jobs_whitelist: ~0 rows (approximately)
INSERT IGNORE INTO `jobs_whitelist` (`id`, `owner`, `cid`, `job`, `rank`, `callsign`) VALUES
	(1, 'steam:11000013ef17842', 7, 'police', 4, '420'),
	(2, 'steam:110000148a4042d', 8, 'police', 4, '421');

-- Dumping structure for table cometrp.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `type` text DEFAULT NULL,
  `log` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.logs: ~0 rows (approximately)

-- Dumping structure for table cometrp.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `incident` longtext DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `jailtime` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.mdt_reports: ~0 rows (approximately)

-- Dumping structure for table cometrp.mdt_warrants
CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `report_title` varchar(255) DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `expire` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.mdt_warrants: ~0 rows (approximately)

-- Dumping structure for table cometrp.mech_materials
CREATE TABLE IF NOT EXISTS `mech_materials` (
  `Shop` mediumtext NOT NULL,
  `rubber` int(11) NOT NULL DEFAULT 0,
  `aluminium` int(11) NOT NULL DEFAULT 0,
  `scrapmetal` int(11) NOT NULL DEFAULT 0,
  `plastic` int(11) NOT NULL DEFAULT 0,
  `copper` int(11) NOT NULL DEFAULT 0,
  `steel` int(11) NOT NULL DEFAULT 0,
  `glass` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table cometrp.mech_materials: ~4 rows (approximately)
INSERT IGNORE INTO `mech_materials` (`Shop`, `rubber`, `aluminium`, `scrapmetal`, `plastic`, `copper`, `steel`, `glass`) VALUES
	('auto_exotics', 40, 40, 43, 40, 60, 60, 50),
	('tuner_shop', 0, 0, 0, 0, 0, 0, 0),
	('auto_bodies', 0, 0, 0, 0, 0, 0, 0),
	('paleto_mech', 0, 0, 0, 0, 0, 0, 0);

-- Dumping structure for table cometrp.modded_cars
CREATE TABLE IF NOT EXISTS `modded_cars` (
  `id` int(11) DEFAULT NULL,
  `license_plate` varchar(255) DEFAULT NULL,
  `Extractors` varchar(255) DEFAULT '{}',
  `Filter` varchar(255) DEFAULT '{}',
  `Suspension` varchar(255) DEFAULT '{}',
  `Rollbars` varchar(255) DEFAULT '{}',
  `Bored` varchar(255) DEFAULT '{}',
  `Carbon` varchar(255) DEFAULT '{}',
  `LFront` varchar(255) DEFAULT '{}',
  `RFront` varchar(255) DEFAULT '{}',
  `LBack` varchar(255) DEFAULT '{}',
  `RBack` varchar(255) DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.modded_cars: ~0 rows (approximately)

-- Dumping structure for table cometrp.phone_yp
CREATE TABLE IF NOT EXISTS `phone_yp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `job` varchar(500) DEFAULT NULL,
  `phonenumber` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.phone_yp: ~0 rows (approximately)

-- Dumping structure for table cometrp.playerstattoos
CREATE TABLE IF NOT EXISTS `playerstattoos` (
  `identifier` int(11) DEFAULT NULL,
  `tattoos` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.playerstattoos: ~0 rows (approximately)
INSERT IGNORE INTO `playerstattoos` (`identifier`, `tattoos`) VALUES
	(1, '[]'),
	(7, '[]');

-- Dumping structure for table cometrp.racing_tracks
CREATE TABLE IF NOT EXISTS `racing_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checkPoints` text DEFAULT NULL,
  `track_names` text DEFAULT NULL,
  `creator` text DEFAULT NULL,
  `distance` text DEFAULT NULL,
  `races` text DEFAULT NULL,
  `fastest_car` text DEFAULT NULL,
  `fastest_name` text DEFAULT NULL,
  `fastest_lap` int(11) DEFAULT NULL,
  `fastest_sprint` int(11) DEFAULT NULL,
  `fastest_sprint_name` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.racing_tracks: ~0 rows (approximately)

-- Dumping structure for table cometrp.transaction_history
CREATE TABLE IF NOT EXISTS `transaction_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` text NOT NULL,
  `trans_id` int(11) NOT NULL,
  `account` text NOT NULL,
  `amount` int(11) NOT NULL,
  `trans_type` text NOT NULL,
  `receiver` text NOT NULL,
  `message` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.transaction_history: ~4 rows (approximately)
INSERT IGNORE INTO `transaction_history` (`id`, `identifier`, `trans_id`, `account`, `amount`, `trans_type`, `receiver`, `message`, `date`) VALUES
	(1, '7', 62368, 'personal', -10000, 'withdraw', 'N/A', 'Withdrew $10,000 cash.', '2023-07-16 06:26:35'),
	(2, '7', 72320, 'personal', -1000000, 'withdraw', 'N/A', 'Withdrew $1,000,000 cash.', '2023-07-16 06:26:43'),
	(3, '8', 49717, 'personal', -100000, 'withdraw', 'N/A', 'Withdrew $100,000 cash.', '2023-07-20 08:51:23'),
	(4, '7', 95444, 'personal', -800000, 'withdraw', 'N/A', 'Withdrew $800,000 cash.', '2023-07-20 09:08:43');

-- Dumping structure for table cometrp.traphouses
CREATE TABLE IF NOT EXISTS `traphouses` (
  `bands` int(11) NOT NULL DEFAULT 0,
  `pending` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.traphouses: ~0 rows (approximately)

-- Dumping structure for table cometrp.tweets
CREATE TABLE IF NOT EXISTS `tweets` (
  `handle` longtext NOT NULL,
  `message` varchar(500) NOT NULL,
  `time` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.tweets: ~0 rows (approximately)

-- Dumping structure for table cometrp.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hex_id` varchar(100) DEFAULT NULL,
  `steam_id` varchar(50) DEFAULT NULL,
  `community_id` varchar(100) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'Uknown',
  `ip` varchar(50) NOT NULL DEFAULT 'Uknown',
  `rank` varchar(50) NOT NULL DEFAULT 'user',
  `date_created` timestamp NULL DEFAULT current_timestamp(),
  `controls` text DEFAULT '{}',
  `settings` text DEFAULT '{}',
  `inventory_settings` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.users: ~2 rows (approximately)
INSERT IGNORE INTO `users` (`id`, `hex_id`, `steam_id`, `community_id`, `license`, `name`, `ip`, `rank`, `date_created`, `controls`, `settings`, `inventory_settings`) VALUES
	(2, 'steam:11000013ef17842', 'STEAM_0:0:528006177', '76561199016278080', 'license:c2cc031f5ae90062435c5b60555b32c5393bd4a1', 'Jay', 'Uknown', 'user', '2023-07-11 14:34:03', '{"newsTools":"H","generalChat":"T","movementCrawl":"Z","generalInventory":"K","vehicleCruise":"X","switchRadioEmergency":"9","radiotoggle":",","generalPhone":"P","vehicleDoors":"L","newsNormal":"E","tokoToggle":"LEFTCTRL","handheld":"LEFTSHIFT+P","vehicleSnavigate":"R","vehicleSlights":"Q","helispotlight":"G","generalUseSecondary":"ENTER","devmarker":"F6","generalUseSecondaryWorld":"F","showDispatchLog":"z","distanceChange":"G","housingMain":"H","actionBar":"TAB","movementCrouch":"X","helivision":"INPUTAIM","helilockon":"SPACE","vehicleHotwire":"H","housingSecondary":"G","vehicleSearch":"G","generalEscapeMenu":"ESC","carStereo":"LEFTALT+P","generalUse":"E","heliCam":"E","tokoptt":"CAPS","devnoclip":"F2","generalProp":"7","generalScoreboard":"U","radiovolumeup":"]","devmenu":"F5","vehicleBelt":"B","helirappel":"X","devcloak":"F3","loudSpeaker":"-","radiovolumedown":"[","vehicleSsound":"LEFTALT","generalTackle":"LEFTALT","generalMenu":"F1","newsMovie":"M","generalUseThird":"G"}', '{}', NULL),
	(3, 'steam:110000148a4042d', 'STEAM_0:1:609354262', '76561199178974260', 'license:8f1aa453620f9c72d4e3a6505cb5b112e2084927', 'Rinehart', 'Uknown', 'user', '2023-07-20 07:02:14', '{"tokoToggle":"LEFTCTRL","helivision":"INPUTAIM","generalUseSecondary":"ENTER","devmenu":"F5","loudSpeaker":"-","helilockon":"SPACE","handheld":"LEFTSHIFT+P","vehicleSlights":"Q","generalEscapeMenu":"ESC","housingSecondary":"G","generalTackle":"LEFTALT","movementCrawl":"Z","generalUse":"E","distanceChange":"G","newsNormal":"E","vehicleSnavigate":"R","tokoptt":"CAPS","switchRadioEmergency":"9","newsMovie":"M","generalUseSecondaryWorld":"F","devnoclip":"F2","radiovolumeup":"]","radiotoggle":",","actionBar":"TAB","vehicleSsound":"LEFTALT","generalPhone":"P","generalInventory":"K","heliCam":"E","vehicleDoors":"L","generalProp":"7","generalScoreboard":"U","vehicleHotwire":"H","showDispatchLog":"z","generalMenu":"F1","devcloak":"F3","radiovolumedown":"[","carStereo":"LEFTALT+P","devmarker":"F6","movementCrouch":"X","helispotlight":"G","helirappel":"X","generalUseThird":"G","generalChat":"T","vehicleCruise":"X","vehicleBelt":"B","newsTools":"H","housingMain":"H","vehicleSearch":"G"}', '{}', NULL);

-- Dumping structure for table cometrp.user_bans
CREATE TABLE IF NOT EXISTS `user_bans` (
  `steam_id` longtext NOT NULL DEFAULT '',
  `discord_id` longtext NOT NULL DEFAULT '',
  `steam_name` longtext NOT NULL DEFAULT '',
  `reason` longtext NOT NULL DEFAULT '',
  `details` longtext NOT NULL,
  `date_banned` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_bans: ~0 rows (approximately)

-- Dumping structure for table cometrp.user_contacts
CREATE TABLE IF NOT EXISTS `user_contacts` (
  `identifier` varchar(40) NOT NULL,
  `name` longtext NOT NULL,
  `number` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_contacts: ~0 rows (approximately)

-- Dumping structure for table cometrp.user_convictions
CREATE TABLE IF NOT EXISTS `user_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `offense` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_convictions: ~0 rows (approximately)

-- Dumping structure for table cometrp.user_emails
CREATE TABLE IF NOT EXISTS `user_emails` (
  `identifier` varchar(40) NOT NULL,
  `name` longtext NOT NULL,
  `context` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_emails: ~0 rows (approximately)

-- Dumping structure for table cometrp.user_inventory
CREATE TABLE IF NOT EXISTS `user_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `item_id` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `quality` int(11) NOT NULL DEFAULT 100,
  `information` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `slot` int(11) NOT NULL,
  `dropped` tinyint(4) NOT NULL DEFAULT 0,
  `creationDate` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=latin1;

-- Dumping data for table cometrp.user_inventory: ~127 rows (approximately)
INSERT IGNORE INTO `user_inventory` (`id`, `name`, `item_id`, `quality`, `information`, `slot`, `dropped`, `creationDate`) VALUES
	(5, 'ply-1', 'mobilephone', 100, '{}', 6, 0, 1689087378039),
	(6, 'ply-1', 'radio', 100, '{}', 2, 0, 1689087378039),
	(7, 'ply-1', 'idcard', 100, '{"identifier":"1","Name":"test","Surname":"test","Sex":0,"DOB":"2000-01-01"}', 3, 0, 1689087378039),
	(8, 'ply-1', 'sandwich', 100, '{}', 10, 0, 1689087378040),
	(9, 'ply-1', 'sandwich', 100, '{}', 10, 0, 1689087378040),
	(10, 'ply-1', 'water', 100, '{}', 9, 0, 1689087378040),
	(11, 'ply-1', 'water', 100, '{}', 9, 0, 1689087378040),
	(12, 'ply-1', '-1074790547', 100, '{}', 1, 0, 1689088571266),
	(14, 'ply-7', 'mobilephone', 100, '{}', 12, 0, 1689500105546),
	(15, 'ply-7', 'radio', 100, '{}', 14, 0, 1689500105546),
	(20, 'ply-7', 'idcard', 100, '{"identifier":"7","Name":"Angus","Surname":"Beef","Sex":0,"DOB":"2000-01-01"}', 15, 0, 1689500105547),
	(21, 'ply-7', '-1074790547', 100, '{}', 1, 0, 1689500162066),
	(31, 'ply-7', 'rifleammo', 100, '{}', 22, 0, 1689500174170),
	(32, 'ply-7', '-538741184', 100, '{}', 11, 0, 1689507025312),
	(47, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(48, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(49, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(50, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(51, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(52, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(53, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754038003),
	(54, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754038003),
	(55, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754038003),
	(56, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(57, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(58, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(59, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(60, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(61, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754055364),
	(62, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754055364),
	(63, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754055364),
	(64, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(65, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(66, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(67, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(68, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(69, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754075462),
	(70, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689754075463),
	(71, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689754075463),
	(72, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689754075463),
	(73, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689754075463),
	(74, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754075462),
	(75, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754075462),
	(76, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754162667),
	(77, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754162667),
	(78, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754162667),
	(79, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689754162667),
	(80, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754162668),
	(81, 'Trunk3-QSXZ2068', 'stolen10ctchain', 100, '{}', 11, 0, 1689754162668),
	(83, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689755036779),
	(84, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689755036779),
	(85, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689755036779),
	(86, 'Trunk3-QSXZ2068', 'rolexwatch', 100, '{}', 12, 0, 1689755036779),
	(87, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(88, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(89, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(90, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(91, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(92, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(93, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(94, 'Trunk3-QSXZ2068', 'goldcoin', 100, '{}', 13, 0, 1689755036780),
	(115, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(116, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(117, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(118, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(119, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(120, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(121, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(122, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(123, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(124, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(125, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(126, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(127, 'ply-7', 'joint', 100, '{}', 17, 0, 1689762181541),
	(130, 'ply-7', 'water', 100, '{}', 17, 0, 1689764302960),
	(136, 'ply-7', 'advlockpick', 100, '{}', 8, 0, 1689781512932),
	(137, 'ply-7', 'advlockpick', 100, '{}', 8, 0, 1689781512932),
	(140, 'ply-7', 'lockpick', 100, '{}', 13, 0, 1689837480956),
	(148, 'ply-7', 'water', 100, '{}', 17, 0, 1689840873862),
	(149, 'ply-7', 'water', 100, '{}', 17, 0, 1689840873862),
	(150, 'ply-7', 'water', 100, '{}', 17, 0, 1689840878265),
	(151, 'ply-7', 'water', 100, '{}', 17, 0, 1689840878265),
	(157, 'ply-8', 'wtint', 100, '{}', 2, 0, 1689841276112),
	(163, 'ply-8', 'mobilephone', 100, '{}', 6, 0, 1689842043359),
	(164, 'ply-8', 'radio', 100, '{}', 7, 0, 1689842043360),
	(165, 'ply-8', 'water', 100, '{}', 4, 0, 1689842043361),
	(166, 'ply-8', 'water', 100, '{}', 4, 0, 1689842043361),
	(167, 'ply-8', 'sandwich', 100, '{}', 5, 0, 1689842043361),
	(168, 'ply-8', 'sandwich', 100, '{}', 5, 0, 1689842043361),
	(169, 'ply-8', 'idcard', 100, '{"identifier":"8","Name":"Austin","Surname":"Rinehart","Sex":0,"DOB":"1999-01-01"}', 3, 0, 1689842043360),
	(170, 'Trunk3-QSXZ2068', 'wtint', 100, '{}', 18, 0, 1689842195047),
	(171, 'ply-8', '-1074790547', 100, '{}', 15, 0, 1689842883332),
	(172, 'Glovebox-QSXZ2068', '-1074790547', 100, '{}', 1, 0, 1689842908994),
	(189, 'ply-7', '-771403250', 100, '{}', 2, 0, 1689843558695),
	(190, 'ply-8', '-771403250', 100, '{}', 1, 0, 1689843574153),
	(193, 'ply-8', 'pistolammo', 100, '{}', 8, 0, 1689843637189),
	(194, 'ply-8', 'pistolammo', 100, '{}', 8, 0, 1689843638460),
	(195, 'ply-8', 'pistolammo', 100, '{}', 8, 0, 1689843639427),
	(204, 'ply-7', 'pistolammo', 100, '{}', 10, 0, 1689939299123),
	(205, 'ply-7', 'pistolammo', 100, '{}', 10, 0, 1689939299123),
	(206, 'ply-7', 'pistolammo', 100, '{}', 10, 0, 1689939299123),
	(217, 'ply-7', 'mobilephone', 100, '{}', 12, 0, 1689942751615),
	(218, 'Trunk3-QSXZ2068', 'zinc', 100, '{}', 6, 0, 1690036553603),
	(219, 'Trunk3-QSXZ2068', 'zinc', 100, '{}', 6, 0, 1690036553603),
	(220, 'Trunk3-QSXZ2068', 'zinc', 100, '{}', 6, 0, 1690036553603),
	(221, 'Trunk3-QSXZ2068', 'gemstoneamethyst', 100, '{}', 2, 0, 1690036553651),
	(222, 'Trunk3-QSXZ2068', 'gemstoneamethyst', 100, '{}', 2, 0, 1690036553651),
	(223, 'Trunk3-QSXZ2068', 'zinc', 100, '{}', 6, 0, 1690036558326),
	(224, 'Trunk3-QSXZ2068', 'gemstoneamethyst', 100, '{}', 2, 0, 1690036558326),
	(225, 'Trunk3-QSXZ2068', 'iron', 100, '{}', 1, 0, 1690036571143),
	(226, 'Trunk3-QSXZ2068', 'iron', 100, '{}', 1, 0, 1690036571143),
	(227, 'Trunk3-QSXZ2068', 'iron', 100, '{}', 1, 0, 1690036571143),
	(228, 'Trunk3-QSXZ2068', 'iron', 100, '{}', 1, 0, 1690036601731),
	(229, 'Trunk3-QSXZ2068', 'copperore', 100, '{}', 7, 0, 1690036604931),
	(230, 'Trunk3-QSXZ2068', 'copperore', 100, '{}', 7, 0, 1690036604931),
	(231, 'Trunk3-QSXZ2068', 'copperore', 100, '{}', 7, 0, 1690036604931),
	(232, 'Trunk3-QSXZ2068', 'iron', 100, '{}', 1, 0, 1690036612754),
	(233, 'ply-7', 'fishingrod', 100, '{}', 6, 0, 1690037562213),
	(308, 'ply-7', 'ironingot', 100, '{}', 3, 0, 1690039298221),
	(320, 'ply-7', 'goldbar', 100, '{}', 5, 0, 1690039389596),
	(322, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041013147),
	(323, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041265714),
	(324, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041293680),
	(325, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041293680),
	(326, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041293680),
	(327, 'ply-7', 'recyclablematerial', 100, '{}', 7, 0, 1690041321903),
	(328, 'ply-7', 'electronics', 100, '{}', 9, 0, 1690041359716);

-- Dumping structure for table cometrp.user_licenses
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `owner` longtext NOT NULL,
  `type` longtext NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_licenses: ~24 rows (approximately)
INSERT IGNORE INTO `user_licenses` (`owner`, `type`, `status`) VALUES
	('1', 'Firearm', 0),
	('1', 'Driver', 1),
	('1', 'Fishing', 0),
	('1', 'Hunting', 0),
	('1', 'Firearm', 0),
	('1', 'Driver', 1),
	('1', 'Hunting', 0),
	('1', 'Fishing', 0),
	('1', 'Firearm', 0),
	('1', 'Driver', 1),
	('1', 'Hunting', 0),
	('1', 'Fishing', 0),
	('1', 'Firearm', 0),
	('1', 'Driver', 1),
	('1', 'Hunting', 0),
	('1', 'Fishing', 0),
	('7', 'Firearm', 0),
	('7', 'Driver', 1),
	('7', 'Hunting', 0),
	('7', 'Fishing', 0),
	('8', 'Driver', 1),
	('8', 'Firearm', 0),
	('8', 'Hunting', 0),
	('8', 'Fishing', 0);

-- Dumping structure for table cometrp.user_mdt
CREATE TABLE IF NOT EXISTS `user_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `mugshot_url` varchar(255) DEFAULT NULL,
  `bail` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.user_mdt: ~0 rows (approximately)

-- Dumping structure for table cometrp.user_messages
CREATE TABLE IF NOT EXISTS `user_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table cometrp.user_messages: 0 rows
/*!40000 ALTER TABLE `user_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_messages` ENABLE KEYS */;

-- Dumping structure for table cometrp.vehicle_display
CREATE TABLE IF NOT EXISTS `vehicle_display` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(60) COLLATE utf8mb4_turkish_ci NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_turkish_ci NOT NULL,
  `commission` int(11) NOT NULL DEFAULT 10,
  `baseprice` int(11) NOT NULL DEFAULT 25,
  `price` int(11) DEFAULT 25000,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

-- Dumping data for table cometrp.vehicle_display: ~9 rows (approximately)
INSERT IGNORE INTO `vehicle_display` (`id`, `model`, `name`, `commission`, `baseprice`, `price`) VALUES
	(1, 'gauntlet', 'Gauntlet', 15, 100000, 100000),
	(2, 'dubsta3', 'Dubsta3', 15, 100000, 100000),
	(3, 'landstalker', 'landstalker', 15, 100000, 100000),
	(4, 'bobcatxl', 'bobcatxl', 15, 100000, 100000),
	(5, 'surfer', 'surfer', 15, 100000, 100000),
	(6, 'glendale', 'glendale', 15, 100000, 100000),
	(7, 'washington', 'washington', 15, 100000, 100000),
	(8, 'fixter', 'Fixter (velo)', 10, 100000, 100000),
	(9, 'trophytruck', 'Trophy Truck', 10, 100000, 100000);

-- Dumping structure for table cometrp.vehicle_mdt
CREATE TABLE IF NOT EXISTS `vehicle_mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) DEFAULT NULL,
  `stolen` bit(1) DEFAULT b'0',
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.vehicle_mdt: ~0 rows (approximately)

-- Dumping structure for table cometrp.weapon_serials
CREATE TABLE IF NOT EXISTS `weapon_serials` (
  `owner` text NOT NULL,
  `serial` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.weapon_serials: ~2 rows (approximately)
INSERT IGNORE INTO `weapon_serials` (`owner`, `serial`) VALUES
	('Angus Beef', 'fYq-892'),
	('Austin Rinehart', 'EQx-42');

-- Dumping structure for table cometrp.weed
CREATE TABLE IF NOT EXISTS `weed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) DEFAULT 0,
  `y` int(11) DEFAULT 0,
  `z` int(11) DEFAULT 0,
  `growth` int(11) DEFAULT 0,
  `type` varchar(50) DEFAULT NULL,
  `time` longtext DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table cometrp.weed: ~0 rows (approximately)

-- Dumping structure for table cometrp.__banking_logs
CREATE TABLE IF NOT EXISTS `__banking_logs` (
  `cid` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `reason` longtext NOT NULL,
  `withdraw` int(11) DEFAULT NULL,
  `business` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.__banking_logs: ~0 rows (approximately)

-- Dumping structure for table cometrp.__blueprints
CREATE TABLE IF NOT EXISTS `__blueprints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `type` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table cometrp.__blueprints: ~4 rows (approximately)
INSERT IGNORE INTO `__blueprints` (`id`, `cid`, `type`) VALUES
	(2, 7, 'UZI_BP'),
	(3, 7, 'TEC9_BP'),
	(4, 8, 'HPISTOL_BP'),
	(5, 7, 'HPISTOL_BP');

-- Dumping structure for table cometrp.__housedata
CREATE TABLE IF NOT EXISTS `__housedata` (
  `cid` int(11) DEFAULT NULL,
  `house_id` int(11) DEFAULT NULL,
  `house_model` int(11) DEFAULT NULL,
  `data` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `upfront` int(11) DEFAULT NULL,
  `housename` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `garages` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `furniture` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `status` mediumtext COLLATE utf8mb4_bin NOT NULL DEFAULT 'locked',
  `force_locked` mediumtext COLLATE utf8mb4_bin NOT NULL DEFAULT 'unlocked',
  `due` int(11) DEFAULT NULL,
  `overall` int(11) DEFAULT NULL,
  `payments` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `can_pay` mediumtext COLLATE utf8mb4_bin NOT NULL DEFAULT 'true'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table cometrp.__housedata: ~0 rows (approximately)

-- Dumping structure for table cometrp.__housekeys
CREATE TABLE IF NOT EXISTS `__housekeys` (
  `cid` int(11) DEFAULT NULL,
  `house_id` int(11) DEFAULT NULL,
  `house_model` int(11) DEFAULT NULL,
  `housename` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `name` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `garages` longtext COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Dumping data for table cometrp.__housekeys: ~0 rows (approximately)

-- Dumping structure for table cometrp.__motels
CREATE TABLE IF NOT EXISTS `__motels` (
  `cid` int(11) DEFAULT NULL,
  `roomType` int(11) DEFAULT NULL,
  `roomNumber` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table cometrp.__motels: ~0 rows (approximately)

-- Dumping structure for table cometrp.__whitelist
CREATE TABLE IF NOT EXISTS `__whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` text DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `steam` (`steam`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=896 DEFAULT CHARSET=latin1;

-- Dumping data for table cometrp.__whitelist: ~1 rows (approximately)
INSERT IGNORE INTO `__whitelist` (`id`, `steam`, `priority`) VALUES
	(1, 'steam:11000013ef17842', 100);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
