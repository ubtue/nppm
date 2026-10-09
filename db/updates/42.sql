/*Delete old DatenbankMapping Entry(not used)*/
DELETE FROM `datenbank_mapping` WHERE `Formular` = 'einzelbeleg' AND `Datenfeld` = "Areal";

/*New Datenbank Mapping Entry*/
INSERT INTO `datenbank_mapping`
(`Formular`,`Datenfeld`,`Feldtyp`,`Array`,`ZielTabelle`,`ZielAttribut`,`FormularAttribut`,`Auswahlherkunft`,`combinedFeldnamen`,`combinedFeldtypen`,`Seite`,`de_beschriftung`,`gb_beschriftung`,`fr_beschriftung`,`la_beschriftung`,`de_combinedAnzeigenamen`,`la_combinedAnzeigenamen`,`gb_combinedAnzeigenamen`,`fr_combinedAnzeigenamen`)
VALUES ('einzelbeleg','NewAreal','combined',1,'einzelbeleg_hatareal','ArealID;ArealTypID','EinzelbelegID','selektion_areal;selektion_arealtyp','Areal;ArealTyp','select;select','einzelbeleg','Areal;ArealTyp','Areal;ArealTyp','Zone;ZoneTyp','Area;AreaTyp','Areal;ArealTyp','Area;AreaTyp','Areal;ArealTyp','Zone;ZoneTyp');

CREATE TABLE `selektion_arealtyp` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provenance_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT('NeG'),
  `provenance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_bezeichnung` (`Bezeichnung`),
  UNIQUE KEY `unique_provenance_id` (`provenance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `selektion_arealtyp` (`ID`, `Bezeichnung`) VALUES (-1, '-');
INSERT INTO `selektion_arealtyp` (`ID`, `Bezeichnung`) VALUES (1, 'person');
INSERT INTO `selektion_arealtyp` (`ID`, `Bezeichnung`) VALUES (2, 'gruppe');
INSERT INTO `selektion_arealtyp` (`ID`, `Bezeichnung`) VALUES (3, 'relatio');

ALTER TABLE `einzelbeleg_hatareal` ADD COLUMN `ArealTypID` int DEFAULT -1;
ALTER TABLE `einzelbeleg_hatareal` ADD CONSTRAINT `einzelbeleg_hatareal_ArealTypID` FOREIGN KEY (`ArealTypID`) REFERENCES `selektion_arealtyp`(`ID`);
