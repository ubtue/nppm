CREATE TABLE IF NOT EXISTS `selektion_kontext` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(50) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE (`Bezeichnung`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*Insert a default value*/
INSERT INTO `selektion_kontext` (ID,Bezeichnung) VALUES (-1,'-');

/*Create the datamapping for the kontext attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "KontextSelektion", "Kontext Klassifikation", "select", 0, "einzelbeleg", "KontextID", "selektion_kontext", "einzelbeleg", "Context Classification", "Classification Du Contexte", "Context Genus");

ALTER TABLE einzelbeleg ADD KontextID INT DEFAULT -1;

/*Rename existing kontext Beschriftung*/
UPDATE datenbank_mapping SET de_Beschriftung = 'Kontext Beschreibung', gb_beschriftung = 'Context Description', fr_beschriftung = 'Description Du Contexte', la_beschriftung = 'Contextus Description' WHERE Datenfeld = 'Kontext' AND Feldtyp = 'textarea' AND Formular = 'einzelbeleg';
