CREATE TABLE `selektion_sprachherkunft` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provenance_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT('NPPM'),
  `provenance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_bezeichnung` (`Bezeichnung`),
  UNIQUE KEY `unique_provenance_id` (`provenance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO selektion_sprachherkunft (ID, Bezeichnung) VALUES (-1, '-');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung) VALUES (0, '?');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung, provenance_id) VALUES (1, 'germanisch', 'germ');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung, provenance_id) VALUES (2, 'griechisch', 'grie');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung, provenance_id) VALUES (3, 'lateinisch', 'late');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung, provenance_id) VALUES (4, 'semitisch', 'semi');
INSERT INTO selektion_sprachherkunft (ID, Bezeichnung, provenance_id) VALUES (5, 'slawisch', 'slaw');

ALTER TABLE mgh_lemma ADD COLUMN SprachherkunftID int NOT NULL DEFAULT -1 AFTER MGHLemma;
ALTER TABLE mgh_lemma ADD CONSTRAINT `mgh_lemma_SprachherkunftID` FOREIGN KEY (`SprachherkunftID`) REFERENCES `selektion_sprachherkunft` (`ID`);

INSERT INTO datenbank_selektion (selektion, tabelle, spalte) VALUES ('selektion_sprachherkunft', 'mgh_lemma', 'SprachherkunftID');

INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Array, Auswahlherkunft, Seite, ZielTabelle, ZielAttribut, de_Beschriftung, gb_Beschriftung, fr_beschriftung, la_beschriftung)
VALUES ('mgh_lemma', 'Sprachherkunft', 'select', 0, 'selektion_sprachherkunft', 'mghlemma', 'mgh_lemma', 'SprachherkunftID', 'Sprachherkunft', 'Linguistic origin', 'Origine linguistique', 'Origo linguistica');

INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Array, Auswahlherkunft, Seite, ZielTabelle, ZielAttribut, de_Beschriftung, gb_Beschriftung, fr_beschriftung, la_beschriftung)
VALUES ('freie_suche', 'Sprachherkunft', 'select', 0, 'selektion_sprachherkunft', 'freie_suche', 'mgh_lemma', 'SprachherkunftID', 'Sprachherkunft', 'Linguistic origin', 'Origine linguistique', 'Origo linguistica');

INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Seite, de_Beschriftung, gb_Beschriftung, fr_beschriftung, la_beschriftung)
VALUES ('freie_suche', 'Ausgabe_Sprachherkunft', 'checkbox', 'freie_suche', 'Sprachherkunft', 'Linguistic origin', 'Origine linguistique', 'Origo linguistica');

INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('freie_suche', 'OrderSprachherkunft', 'Sprachherkunft', 'Linguistic origin', 'Origine linguistique', 'Origo linguistica');
