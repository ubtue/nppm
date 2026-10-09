UPDATE datenbank_mapping SET de_combinedAnzeigenamen = 'Philologischer Kommentar;;Link',gb_combinedAnzeigenamen = 'Philological commentary;;Link',fr_combinedAnzeigenamen = 'commentaire philologique;;Link',la_combinedAnzeigenamen = 'commentatio philologica;;Link' WHERE Formular = 'einzelbeleg' AND Datenfeld = 'Lemma';

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Philologischer Kommentar',`gb_Beschriftung` = 'Philological commentary',`fr_Beschriftung` = 'commentaire philologique',`la_Beschriftung` = 'commentatio philologica'
WHERE (Datenfeld = 'PLemma' AND Formular = 'namenkommentar')
OR (Datenfeld = 'LemmaRO' AND Formular = 'einzelbeleg')
OR (Datenfeld = 'Namenlemma' AND Formular = 'freie_suche')
OR (Datenfeld = 'Ausgabe_Namenlemma' AND Formular = 'freie_suche');

UPDATE `datenbank_mapping` SET `Feldtyp` = 'link(mgh_lemma tab,MGHLemmaID,MGHLemma,lemma)' WHERE (`Datenfeld` = 'MGHLemmaRO' AND Formular = 'einzelbeleg');
