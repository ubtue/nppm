INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'NummerSeite', 'Nr./Seite', 'Nr./S.', 'N°/P.', 'Nr./Pag.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche ', 'Raster', 'Rast.', 'Grid', 'Grille', 'Ret.');

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Edition', `fr_beschriftung` = 'Édition', `la_beschriftung` = 'Editio' WHERE Formular = "quelle" and Datenfeld = "Edition";

UPDATE `datenbank_mapping` SET `fr_beschriftung` = 'vivant/mort' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Lebend";

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'VonTag', 'von T.', 'from D.', 'du J.', 'a D.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'VonMonat', 'von M.', 'from M.', 'du M.', 'a M.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'VonJahr', 'von J.', 'from Y.', 'de l’A', 'a A.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'VonJahrhundert', 'von Jh.', 'from C.', 'du S.', 'a S.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche ', 'BisTag', 'bis T.', 'until D.', 'jusq. J.', 'usq. D.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'BisMonat', 'bis M.', 'until M.', 'jusq. M.', 'usq. M.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'BisJahr', 'bis J.', 'until Y.', 'jusq. A.', 'usq. A.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'BisJahrhundert', 'bis Jh.', 'until C.', 'jusq. S.', 'usq. S.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('freie_suche', 'Insgesamt', 'Insgesamt', 'A total of', 'Un total de', 'In summa');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('mgh_lemma', 'Lemmata', 'Lemmata', 'Lemmata', 'Lemmes', 'Lemmata');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('namenkommentar', 'Namenkommentar', 'Namenkommentar', 'Name comment', 'Commentaire de nom', 'Commentarius nominis');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('namenkommentar', 'Namenkommentare', 'Namenkommentare', 'Name comments', 'Commentaires de nom', 'Commentarii nominum');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('quelle', 'Quelle', 'Quelle', 'Source', 'Source', 'Fons');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('einzelbeleg', 'Einzelbeleg', 'Einzelbeleg', 'Reference', 'Référence', 'Testimonium');

UPDATE `datenbank_texte` SET `gb` = 'Single References', `fr` = 'Références individuelles' WHERE Formular = 'einzelbeleg' and Textfeld = 'Titel';

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('freie_suche', 'BitteSchritt2', ' Bitte wählen Sie mind. ein Ausgabefeld aus (Schritt 2).', 'Please select at least one output field (Step 2).', 'Veuillez sélectionner au moins un champ de sortie (Étape 2).', 'Placere eligas saltem unum campum outputum (Gradus 2).');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('freie_suche', 'KeinEintragVorhanden', ' Kein Eintrag vorhanden, der dem Suchkriterium entspricht.', 'No entry matching the search criteria.', 'Aucune entrée ne correspond aux critères de recherche.', 'Ingressus nullus inventus est qui criteriis quaestionibus aequet.');
