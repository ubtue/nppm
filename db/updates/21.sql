ALTER TABLE selektion_stand ADD COLUMN parentId INT DEFAULT NULL;
ALTER TABLE selektion_stand ADD CONSTRAINT `selektion_stand_parentId` FOREIGN KEY (`parentId`) REFERENCES selektion_stand(`ID`);

ALTER VIEW `gastselektion_stand` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung`,`s`.`parentId` AS `parentId` from (`selektion_stand` `s` join `person_hatstand` `phs`) where ((`phs`.`StandID` = `s`.`ID`) and `phs`.`PersonID` in (select `einzelbeleg_hatperson`.`PersonID` AS `PersonID` from `einzelbeleg_hatperson` where `einzelbeleg_hatperson`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1)))));
