INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('gast_freie_suche', 'BelegformSuchanfrage', 'Belegform des Namens, z.B. Robertus', 'Form of Reference of the name, e.g., Robertus', 'Forme de la référence du nom, p.ex. Robertus', 'Forma Testimonii nominis, e.g. Robertus');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `FormularAttribut`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('mgh_lemma', 'EinzelbelegRODistinct', 'Belegformen', 'link(einzelbeleg tab JOIN quelle q ON q.ID=tab.quelleID AND q.zuVeroeffentlichen=1,EinzelbelegID,Belegform,einzelbeleg)', '1', 'einzelbeleg_hatmghlemma', 'MGHLemmaID', 'mghlemma', 'Forms of Reference', 'Formes de référence', 'Formae testimonii');


