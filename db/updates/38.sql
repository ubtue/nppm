UPDATE `datenbank_texte` SET `de` = 'Lemma', `gb` = 'lemma', `fr` = 'lemme', `la` = 'lemma'
WHERE (textfeld = 'Titel' AND Formular = 'mgh_lemma')
OR (Textfeld = 'OrderMGH' AND Formular = 'freie_suche');

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Lemma',`gb_Beschriftung` = 'Lemma',`fr_Beschriftung` = 'Lemme',`la_Beschriftung` = 'Lemma'
WHERE (Datenfeld = 'MGHLemma' AND Formular = 'mgh_lemma')
OR (Datenfeld = 'MGHLemma' AND Formular = 'freie_suche')
OR (Datenfeld = 'Ausgabe_MGHLemma' AND Formular = 'freie_suche')
OR (Datenfeld = 'MGHLemmaRO' AND Formular = 'einzelbeleg');

UPDATE datenbank_mapping SET de_combinedAnzeigenamen = 'Lemma;;Link',gb_combinedAnzeigenamen = 'Lemma;;Link',fr_combinedAnzeigenamen = 'Lemme;;Link',la_combinedAnzeigenamen = 'Lemma;;Link' WHERE Formular = 'einzelbeleg' AND Datenfeld = 'MGHLemma';
UPDATE datenbank_mapping SET de_combinedAnzeigenamen = 'Philologisches Lemma;;Link',gb_combinedAnzeigenamen = 'Philological Lemma;;Link',fr_combinedAnzeigenamen = 'Lemme Philologique;;Link',la_combinedAnzeigenamen = 'Lemma Philologicum;;Link' WHERE Formular = 'einzelbeleg' AND Datenfeld = 'Lemma';

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Philologisches Lemma',`gb_Beschriftung` = 'Philological lemma',`fr_Beschriftung` = 'Lemme philologique',`la_Beschriftung` = 'Lemma philologicum'
WHERE (Datenfeld = 'PLemma' AND Formular = 'namenkommentar')
OR (Datenfeld = 'LemmaRO' AND Formular = 'einzelbeleg')
OR (Datenfeld = 'Namenlemma' AND Formular = 'freie_suche')
OR (Datenfeld = 'Ausgabe_Namenlemma' AND Formular = 'freie_suche');
