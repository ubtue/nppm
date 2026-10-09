ALTER TABLE person ADD COLUMN Wikidata varchar(255) NULL AFTER GND, ADD INDEX idx_wikidata (Wikidata);

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('person', 'WikiData', 'WIKIDATA', 'textfield', '0', 'person', 'Wikidata', 'person', 'WIKIDATA', 'WIKIDATA', 'WIKIDATA');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`) VALUES ('person', 'WikidataLink', 'wikidatalink', '0', 'person', 'Wikidata');

UPDATE `datenbank_mapping` SET `Datenfeld` = 'IconLink' WHERE Formular = "person" and Datenfeld = "GNDLink";

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('freie_suche', 'Ausgabe_Einzelbeleg_AmtWeihe', 'Ämter und Weihegrade im Einzelbeleg', 'checkbox', '0', 'freie_suche', 'Offices and Degree of Ordination at single reference', 'Fonctions et degré d''ordination en référence individuelle', 'Officium et gradus ordinationis in testimonio');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`, `de_Tooltip`, `gb_Tooltip`, `fr_Tooltip`, `la_Tooltip`) VALUES ('gast_freie_suche', 'StandEinzelbeleg', 'Stand (Einzelbeleg)', 'select', '0', 'selektion_stand', 'freie_suche', 'status (Single Reference)', 'Statut (référence indivuelle)', 'Status (testimonium)', 'Wählen Sie aus der Ausklappliste', 'Select the status from the drop-down menu', 'Select the status from the drop-down menu', 'Select the status from the drop-down menu');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('freie_suche', 'Ausgabe_Stand_Einzelbeleg', 'Stand im Einzelbeleg', 'checkbox', '0', 'freie_suche', 'Status  at single reference', 'Statut en référence individuelle', 'Status in testimonio');

UPDATE `datenbank_mapping` SET `fr_beschriftung` = 'Fonction/Ordination (référence indivuelle)' WHERE Formular = "freie_suche" and Datenfeld = "AmtWeiheEinzelbeleg";

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Stand Person', `gb_beschriftung` = 'Status Person', `fr_beschriftung` = 'Statut Personne', `la_beschriftung` = 'Status Persona' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Stand";

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('freie_suche', 'OrderStandEinzelbeleg', 'Stand Einzelbeleg', 'Status (Single Reference)', 'Statut (référence indivuelle)', 'Status (testimonium)');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('freie_suche', 'OrderAmtWeiheEinzelbeleg', 'Amt/Weihe Einzelbeleg', 'Office/Consecration (Single Reference)', 'Fonction/Ordination (référence indivuelle)', 'Officium/Consecratio (testimonium)');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('statlemma', 'Titel', 'Statistik', 'Statistics', 'Statistiques', 'Statistica');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('statlemma', 'ListeDerLemmataAnzahl', 'Liste der Lemmata mit Anzahl der Belege', 'List of lemmata with the number of references', 'Liste des lemmes avec le nombre de références', 'Index lemmatum cum numero testimoniorum');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('statlemma', 'LemmaFilter', 'Lemma-Filter', 'Filter by lemma', 'Filtrer par lemme', 'Filtrum per lemmata');
