CREATE TABLE IF NOT EXISTS `selektion_kritik` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(50) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE (`Bezeichnung`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*Insert a default value*/
INSERT INTO `selektion_kritik` (ID,Bezeichnung) VALUES (-1,'-');

/*Create the datamapping for the text kritik attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "KritikSelektion", "Textkritische Anmerkung", "select", 0, "einzelbeleg", "KritikID", "selektion_kritik", "einzelbeleg", "Text-critical note", "Note critique sur le texte", "Nota cum textu critico");

ALTER TABLE einzelbeleg ADD KritikID INT DEFAULT -1;

ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_KritikID FOREIGN KEY (KritikID) REFERENCES selektion_kritik(ID);
