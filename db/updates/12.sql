#Clean up CM References
DELETE FROM datenbank_mapping WHERE Formular = "quelle" AND Datenfeld = "CMRef";
DELETE FROM datenbank_mapping WHERE Formular = "quelle" AND Datenfeld = "CMLink";
DELETE FROM datenbank_mapping WHERE Formular = "person" AND Datenfeld = "CMRef";
DELETE FROM datenbank_mapping WHERE Formular = "person" AND Datenfeld = "CMLink";

CREATE TABLE IF NOT EXISTS `selektion_konvent` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(50) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE (`Bezeichnung`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*Insert a default value*/
INSERT INTO `selektion_konvent` (ID,Bezeichnung) VALUES (-1,'-');

/*Create the datamapping for the konvent attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "Konvent", "Konvent", "select", 0, "einzelbeleg", "KonventID", "selektion_konvent", "einzelbeleg", "Convent", "Monastère", "Monasterium");

ALTER TABLE einzelbeleg ADD KonventID INT DEFAULT -1;

INSERT INTO datenbank_selektion (selektion, tabelle, spalte) VALUES ('selektion_konvent', 'einzelbeleg', 'KonventID');
