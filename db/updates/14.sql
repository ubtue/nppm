INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('tinyMce', 'Titel', 'TinyMCE', 'TinyMCE', 'TinyMCE', 'TinyMCE');

INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('fileManagement', 'Titel', 'Inhalt', 'Content', 'Contenu', 'Contenta');

ALTER TABLE tinyMce_content CHANGE COLUMN name Bezeichnung VARCHAR(255);

ALTER TABLE tinyMce_content MODIFY contentType VARCHAR(255);

ALTER TABLE tinyMce_content ADD COLUMN context VARCHAR(255) NOT NULL;

UPDATE tinyMce_content SET context = 'HILFE';

RENAME TABLE tinyMce_content TO content;

ALTER TABLE datenbank_mapping ADD COLUMN Auswahlherkunft_Filter VARCHAR(255) AFTER Auswahlherkunft;

ALTER TABLE datenbank_mapping ADD COLUMN Filter VARCHAR(255) AFTER Auswahlherkunft_Filter;

INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, Auswahlherkunft, Auswahlherkunft_Filter, Filter, Seite)
VALUES ('namenkommentar', 'DateinameX', 'Dateiname', 'select', 0, 'namenkommentar', 'Dateiname', 'content', 'context', 'NAMENKOMMENTAR', 'namenkommentar');
