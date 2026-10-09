ALTER TABLE person ADD COLUMN GND varchar(255) DEFAULT NULL AFTER PKZ;

CREATE INDEX GND ON person (GND);

INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, FormularAttribut, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung) VALUES ("person", "GND", "GND-ID", "textfield", 0, "person", "GND", "PersonID", "person", "GND-ID", "GND-ID", "GND-ID");

INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Array, ZielTabelle, ZielAttribut) VALUES ("person", "GNDLink", "gndlink", 0, "person", "GND");