-- Einträge einfügen
INSERT INTO selektion_kritik (ID, Bezeichnung) VALUES (1, '?');

INSERT INTO datenbank_mapping (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `FormularAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('einzelbeleg', 'TitelKritik', 'TitelKritik', 'select', '1', 'einzelbeleg_hattitelkritik', 'TitelKritikID', 'EinzelbelegID', 'selektion_kritik', 'einzelbeleg', 'Title critique', 'Critique de titre', 'Titulus Critica');

ALTER TABLE einzelbeleg ADD COLUMN TitelText varchar(255) DEFAULT NULL AFTER KontextID;

INSERT INTO datenbank_mapping (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('einzelbeleg', 'TitelText', 'Titel Text', 'textfield', '0', 'einzelbeleg', 'titelText', 'einzelbeleg', 'Title text', 'Texte du titre', 'Titulus textus');

CREATE TABLE einzelbeleg_hattitelkritik (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    EinzelbelegID INT UNSIGNED NOT NULL,
    TitelkritikID INT NOT NULL,
    CONSTRAINT einzelbeleg_hattitelkritik_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID),
    CONSTRAINT einzelbeleg_hattitelkritik_TitelkritikID FOREIGN KEY (TitelkritikID) REFERENCES selektion_kritik(ID)
);

ALTER TABLE handschrift_ueberlieferung
ADD COLUMN Schriftherkunft varchar(255) DEFAULT NULL AFTER Schriftheimat;

UPDATE `datenbank_mapping` SET `ZielAttribut` = 'QuelleID;;;Sigle;Schriftherkunft;Schriftheimat;Bibliotheksheimat;', `Auswahlherkunft` = ';;;;;selektion_ort;selektion_ort;', `combinedFeldnamen` = 'QuelleID;;;Sigle;Schriftherkunft;Schriftheimat;Bibliotheksheimat; ;', `combinedFeldtypen` = 'textfield;search(quelle,Bezeichnung,QuelleID);link(quelle,QuelleID,Bezeichnung);subtable;textfield;addselect;addselect;dateinfo', `de_combinedAnzeigenamen` = 'Quelle;;Link;Edition/Sigle;Schriftherkunft;Schriftheimat;Biblio.heimat;Datierung', `gb_combinedAnzeigenamen` = 'Source;;Link;Edition/Sigle;Origin of script;Origin of writing;Library origin;Dating', `fr_combinedAnzeigenamen` = 'source;;lien;édition/sigle;Origine de l\'écriture;lieu de création de l\'écriture;origine bibliothèque;datati', `la_combinedAnzeigenamen` = 'fons;;conexus;editio/sigla;Origo scripturae;origo libri;orig' WHERE Datenfeld = "Ueberlieferung";
