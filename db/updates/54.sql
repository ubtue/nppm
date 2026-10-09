INSERT INTO datenbank_mapping(Formular, Datenfeld, de_Beschriftung, Feldtyp, Auswahlherkunft, Array, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)  VALUES ("freie_suche", "ProvenanceEinzelbeleg", "Provenienz (Einzelbeleg)", "select","selektion_provenienz", 0, "freie_suche", "Provenance (Einzelbeleg)", "Provenance (Einzelbeleg)", "Provenance (Einzelbeleg)");
INSERT INTO datenbank_mapping(Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)  VALUES ("freie_suche", "Ausgabe_Provenance_Einzelbeleg", "Provenienz (Einzelbeleg)", "checkbox", 0, "freie_suche", "Provenance (Einzelbeleg)", "Provenance (Einzelbeleg)", "Provenance (Einzelbeleg)");

CREATE TABLE IF NOT EXISTS `selektion_provenienz` (
  `ID` INT NOT NULL,
  `Bezeichnung` VARCHAR(50) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE `unique_bezeichnung_selektion_provenienz` (`Bezeichnung`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*Insert values*/
INSERT INTO `selektion_provenienz` (`ID`,`Bezeichnung`) VALUES (-1,'-');
INSERT INTO `selektion_provenienz` (`ID`,`Bezeichnung`) VALUES (0,'NeG');
INSERT INTO `selektion_provenienz` (`ID`,`Bezeichnung`) VALUES (1,'DMP');
