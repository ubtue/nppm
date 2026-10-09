ALTER TABLE selektion_quellengattung ADD COLUMN parentId INT DEFAULT NULL;
ALTER TABLE selektion_quellengattung ADD CONSTRAINT `selektion_quellengattung_parentId` FOREIGN KEY (`parentId`) REFERENCES selektion_quellengattung(`ID`);

ALTER VIEW gastselektion_quellengattung AS SELECT DISTINCT `selektion_quellengattung`.`ID` AS `ID`,`selektion_quellengattung`.`Bezeichnung` AS `Bezeichnung`, `selektion_quellengattung`.`parentId` AS `parentId` FROM ((`einzelbeleg` LEFT JOIN `quelle` ON ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`))) LEFT JOIN `selektion_quellengattung` ON ((`einzelbeleg`.`QuelleGattungID` = `selektion_quellengattung`.`ID`))) WHERE (`quelle`.`ZuVeroeffentlichen` = 1);
