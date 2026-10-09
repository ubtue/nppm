INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `FormularAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`, `de_Tooltip`, `gb_Tooltip`, `fr_Tooltip`, `la_Tooltip`)
VALUES ('freie_suche', 'ErstGliedSelect', 'Erstglied', 'select', '0', 'mgh_lemma', 'MGHLemma', 'MGHLemma', 'mgh_lemma', 'freie_suche', 'First part', 'Première partie', 'Prima pars',
'Die verschiedenen Schreibweisen eines Namens sind unter einem sprachwissenschaftlichen Namenlemma zusammengefasst.
 Im oberen Fenster wählen Sie den ersten Teil eines Lemmas, im zweiten den zweiten Teil.',
 'The different spellings of a name are summarized under a linguistic lemma.
 In the upper window, select the first part of a lemma, and in the second window, select the second part.',
 'Les différentes orthographes d\'un nom sont résumées sous un lemme linguistique.
 Dans la fenêtre supérieure, sélectionnez la première partie d\'un lemme, et dans la deuxième fenêtre, sélectionnez la deuxième partie.',
 'Varias scripturas nominis sub lemma linguistico concluduntur. In fenestra superiore primum partem lemmatis selige, in secunda vero fenestra secundam partem.');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `FormularAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`)
VALUES ('freie_suche', 'ZweitGliedSelect', 'Zweitglied', 'select', '0', 'mgh_lemma', 'MGHLemma', 'MGHLemma', 'mgh_lemma', 'freie_suche', 'Second part', 'Deuxième partie', 'Secunda pars');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`)
 VALUES ('freie_suche', 'ErstZweitGlied', 'Erst-/ ZweitGlied', 'First/ Second part', 'Première/ Deuxième partie', 'Prima/ Secunda pars');


-- The selektion_kritik was still missing in the administration area.
INSERT INTO `datenbank_selektion` (`selektion`, `tabelle`, `spalte`) VALUES ('selektion_kritik', 'einzelbeleg_hattitelkritik', 'TitelKritikID');
