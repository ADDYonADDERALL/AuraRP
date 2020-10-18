USE `essentialmode`;

ALTER TABLE `users` ADD `insuranceDate` VARCHAR(12) NOT NULL DEFAULT '0' AFTER `is_dead`;