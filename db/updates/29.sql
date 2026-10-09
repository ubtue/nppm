/*
FELD: pal_abgrenzung
*/
ALTER TABLE einzelbeleg ADD pal_abgrenzung VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the pal_abgrenzung attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "PalAbgrenzung", "Pal Abgrenzung", "textfield", 0, "einzelbeleg", "pal_abgrenzung", "", "einzelbeleg", "Pal Demarcation", "Pal Démarcation", "Pal Signatio");

/*
FELD: inh_abgrenzung
*/
ALTER TABLE einzelbeleg ADD inh_abgrenzung VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the inh_abgrenzung attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "InhAbgrenzung", "Inh Abgrenzung", "textfield", 0, "einzelbeleg", "inh_abgrenzung", "", "einzelbeleg", "Inh Demarcation", "Inh Démarcation", "Inh Signatio");

/*
FELD: nr_in_strukt
*/
ALTER TABLE einzelbeleg ADD nr_in_strukt VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the nr_in_strukt attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "NrInStrukt", "Nummer in Struktur", "textfield", 0, "einzelbeleg", "nr_in_strukt", "", "einzelbeleg", "Number in structure", "Nombre dans la structure", "Numerus in structuram");

/*
FELD: seite
*/
ALTER TABLE einzelbeleg ADD seite VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the seite attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "Seite", "Seite", "textfield", 0, "einzelbeleg", "seite", "", "einzelbeleg", "Site", "Page", "Page");

/*
FELD: raster
*/
ALTER TABLE einzelbeleg ADD raster VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the raster attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "Raster", "Raster", "textfield", 0, "einzelbeleg", "raster", "", "einzelbeleg", "Grid", "Grille", "Eget");

/*
FELD: schreiber
*/
ALTER TABLE einzelbeleg ADD schreiber VARCHAR(10) DEFAULT NULL;

/*Create the datamapping for the schreiber attribute of the einzelbeleg form*/
INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)
VALUES ("einzelbeleg", "Schreiber", "Schreiber", "textfield", 0, "einzelbeleg", "schreiber", "", "einzelbeleg", "Writer", "Scribe", "Scribae");

/*Insert Group Label*/
INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('einzelbeleg', 'Grid', 'Raster', 'Grid', 'Grille', 'Eget');
