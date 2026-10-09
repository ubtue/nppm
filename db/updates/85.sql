UPDATE `datenbank_mapping` SET `Feldtyp` = 'array.selektion.multiselect', `ZielTabelle` = '', `ZielAttribut` = '' WHERE (`Datenfeld` = 'Quellenliste' AND `Formular` = 'gast_freie_suche');
DELETE FROM datenbank_mapping WHERE Formular = "einzelbeleg" AND Datenfeld = "Quellengattung";
