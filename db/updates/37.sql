ALTER TABLE einzelbeleg
DROP FOREIGN KEY einzelbeleg_BeziehungGemeinschaftID;

ALTER TABLE einzelbeleg
ADD CONSTRAINT einzelbeleg_BeziehungGemeinschaftID FOREIGN KEY (`BeziehungGemeinschaftID`) REFERENCES `selektion_beziehung_gemeinschaft` (`ID`);


UPDATE `datenbank_mapping` SET `Feldtyp` = 'select' WHERE `Formular` = 'person' and `Datenfeld` = 'GruppeHerkunft';