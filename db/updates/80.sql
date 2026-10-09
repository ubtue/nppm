INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('suche', 'gesamteTreffer', 'Gesamte Treffer:', 'Total hits:', 'Nombre total de visites:', 'Summa ictuum:');
INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('suche', 'schritt2', 'Bitte wählen Sie mind. ein Ausgabefeld aus (Schritt 2).', 'Please select at least one output field (step 2).', 'Veuillez sélectionner au moins un champ de sortie (étape 2).', 'Quaeso, unum saltem campum exitus elige (gradus 2).');
INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('suche', 'treffer', 'Treffer', 'Hits', 'Coups', 'Ictus');
INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('suche', 'insgesamt', 'insgesamt', 'in total', 'en tout', 'in summa');
INSERT INTO datenbank_texte (Formular, Textfeld, de, gb, fr, la) VALUES ('suche', 'pzuordnung', 'ohne Personenzuordnung', 'without personal assignment', 'sans affectation personnelle', 'sine assignatione personali');
UPDATE datenbank_texte SET gb = 'Simple Search' WHERE (Formular = 'gast_freie_suche' AND Textfeld = 'EinfacheSuche');
