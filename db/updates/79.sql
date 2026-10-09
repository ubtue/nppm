ALTER TABLE quelle ADD COLUMN Geschichtsquellen varchar(255) DEFAULT NULL;

CREATE INDEX Geschichtsquellen ON quelle (Geschichtsquellen);

INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, FormularAttribut, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung) VALUES ("quelle", "Geschichtsquellen", "Geschichtsquellen-ID", "textfield", 0, "quelle", "Geschichtsquellen", "QuelleID", "quelle", "Geschichtsquellen-ID", "Geschichtsquellen-ID", "Geschichtsquellen-ID");

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`) VALUES ('quelle', 'GeschichtsquellenLink', 'geschichtsquellenlink', '0', 'quelle', 'Geschichtsquellen');
