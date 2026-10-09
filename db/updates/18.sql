DELETE FROM datenbank_texte WHERE ID IN (SELECT MAX(ID) FROM (SELECT * FROM datenbank_texte AS datenbank_texte_temp) AS max_ids GROUP BY Formular, Textfeld HAVING COUNT(*) > 1);
ALTER TABLE datenbank_texte ADD CONSTRAINT datenbank_texte_Formular_Textfeld UNIQUE (Formular, Textfeld);
