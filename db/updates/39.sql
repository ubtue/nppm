INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Array, ZielTabelle, ZielAttribut, gb_beschriftung, fr_beschriftung, de_Beschriftung, la_beschriftung) VALUES ("einzelbeleg", "Kontext_vor", "textarea", 0, "einzelbeleg", "Kontext_vor","context before", "contexte avant", "Kontext vor", "ante context");

INSERT INTO datenbank_mapping (Formular, Datenfeld, Feldtyp, Array, ZielTabelle, ZielAttribut, gb_beschriftung, fr_beschriftung, de_Beschriftung, la_beschriftung) VALUES ("einzelbeleg", "Kontext_nach", "textarea", 0, "einzelbeleg", "Kontext_nach","context after", "contexte après", "Kontext nach", "postea context");

INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ("einzelbeleg", "Kontext", "Kontext", "Context", "Contexte", "Kontext");

ALTER TABLE einzelbeleg ADD Kontext_vor mediumtext DEFAULT NULL AFTER Belegnummer;

ALTER TABLE einzelbeleg ADD Kontext_nach mediumtext DEFAULT NULL AFTER Kontext;