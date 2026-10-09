
CREATE TABLE IF NOT EXISTS `selektion_angabe` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Bezeichnung` VARCHAR(50) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE `unique_bezeichnung_selektion_angabe` (`Bezeichnung`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;	

/*Insert a default value*/
INSERT INTO `selektion_angabe` (ID,Bezeichnung) VALUES (-1,'-');
INSERT INTO `selektion_angabe` (ID,Bezeichnung) VALUES (1,'?');

CREATE TABLE einzelbeleg_hatangabe (
    ID int unsigned NOT NULL AUTO_INCREMENT,
    EinzelbelegID int unsigned NOT NULL,
    AngabeID int NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT einzelbeleg_hatangabe_EinzelbelegID 
        FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID),
    CONSTRAINT einzelbeleg_hatangabe_AngabeID 
        FOREIGN KEY (AngabeID) REFERENCES selektion_angabe(ID)
    )
    ENGINE=InnoDB 
    DEFAULT CHARSET=utf8mb4
    COLLATE=utf8mb4_unicode_ci;
 
INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `FormularAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `fr_combinedAnzeigenamen`, `la_beschriftung`) VALUES ('einzelbeleg', 'AngabenPerson', 'Angabe zur Person', 'addselect', '1', 'einzelbeleg_hatangabe', 'AngabeID', 'EinzelbelegID', 'selektion_angabe', 'einzelbeleg', 'Details about the person', 'Détails sur la personne', '', 'Particularia de persona');


INSERT INTO `datenbank_selektion` (`selektion`, `tabelle`, `spalte`) VALUES ('selektion_angabe', 'einzelbeleg_hatangabe', 'AngabeID');

