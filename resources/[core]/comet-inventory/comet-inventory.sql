CREATE TABLE `user_inventory` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(500) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`item_id` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`quality` INT(11) NOT NULL DEFAULT '100',
	`information` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`slot` INT(11) NOT NULL,
	`dropped` TINYINT(4) NOT NULL DEFAULT '0',
	`creationDate` BIGINT(20) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;
