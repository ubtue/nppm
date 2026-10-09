INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Eintraege', 'Einträge', 'Entries', 'Entrées', 'Inscripta');

UPDATE `datenbank_texte` SET `gb` = 'Office/Consecration (person)', `fr` = 'Fonction/Ordination (personne)', `la` = 'Officium/Consecratio (persona)' WHERE Formular = 'freie_suche' and Textfeld = 'OrderAmtWeihe';

UPDATE `datenbank_mapping` SET `la_beschriftung` = 'Officium/Consecratio (persona)' WHERE Formular = "gast_freie_suche" and Datenfeld = "AmtWeihePerson";

UPDATE `datenbank_mapping` SET `la_beschriftung` = 'Officium/Consecratio (persona)' where Formular = "freie_suche" and Datenfeld = "AmtWeihePerson";

UPDATE `datenbank_texte` SET `gb` = 'References', `fr` = 'Références', `la` = 'Testimonia' WHERE Formular = "freie_suche" and Textfeld = 'OrderBelege';

UPDATE `datenbank_texte` SET `gb` = 'Dating Single Reference', `fr` = 'Datation Référence individuelle', `la` = 'Datatio Testimonium' WHERE Formular = "freie_suche" and Textfeld = 'OrderDatEinzelbeleg';

UPDATE `datenbank_texte` SET `gb` = 'Dating Source', `fr` = 'Datation Source', `la` = 'Datatio Fonte' WHERE Formular = "freie_suche" and Textfeld = 'OrderDatQuelle';

UPDATE `datenbank_texte` SET `gb` = 'First part', `fr` = 'Première partie', `la` = 'Prima pars' WHERE Formular = "freie_suche" and Textfeld = 'OrderErstglied';

UPDATE `datenbank_texte` SET `gb` = 'Ethnicity (Person)', `fr` = 'Ethnie (personne)', `la` = 'Gens (persona) ' WHERE Formular = "freie_suche" and Textfeld = 'OrderEthnie';

UPDATE `datenbank_texte` SET `gb` = 'Sex', `fr` = 'Sexe', `la` = 'Sexus' WHERE Formular = "freie_suche" and Textfeld = 'OrderGeschlecht';

UPDATE `datenbank_texte` SET `gb` = 'Lemma', `fr` = 'Lemme', `la` = 'Lemma' WHERE Formular = "freie_suche" and Textfeld = 'OrderMGH';

UPDATE `datenbank_texte` SET `gb` = 'Names', `fr` = 'Noms', `la` = 'Nomina' WHERE Formular = "freie_suche" and Textfeld = 'OrderNamen';

UPDATE `datenbank_texte` SET `gb` = 'Persons', `fr` = 'Personnes', `la` = 'Personae' WHERE Formular = "freie_suche" and Textfeld = 'OrderPersonen';

UPDATE `datenbank_texte` SET `gb` = 'Sources', `fr` = 'Sources', `la` = 'Fontes' WHERE Formular = "freie_suche" and Textfeld = 'OrderQuellen';

UPDATE `datenbank_texte` SET `gb` = 'Type of source', `fr` = 'Genre de sources', `la` = 'Genus fontis' WHERE Formular = "freie_suche" and Textfeld = 'OrderQuellengattung';

UPDATE `datenbank_texte` SET `gb` = 'Status (Person)', `fr` = 'Statut (personne)', `la` = 'Status (persona)' WHERE Formular = "freie_suche" and Textfeld = 'OrderStand';

UPDATE `datenbank_texte` SET `gb` = 'Variants', `fr` = 'Variantes', `la` = 'Variationes' WHERE Formular = "freie_suche" and Textfeld = 'OrderVariante';

UPDATE `datenbank_texte` SET `gb` = 'Second part', `fr` = 'Deuxième partie', `la` = 'Secunda pars' WHERE Formular = "freie_suche" and Textfeld = 'OrderZweitglied';

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Cap', 'C.', 'Ch.', 'Ch.', 'C.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Pag', 'S.', 'p.', 'p.', 'p.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Bitte3Zeichen', 'Bitte geben Sie mindestens 3 Zeichen als Suchtext an.', 'Please enter at least 3 characters as search text.', 'Veuillez saisir au moins 3 caractères comme texte de recherche.', 'Inseras saltem tres litteras ad quaerendum.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'KeinErgebnis', 'Für Ihre Suchanfrage wurden keine Ergebnisse gefunden.', 'No results were found for your search query.', 'Aucun résultat n’a été trouvé pour votre requête de recherche.', 'Nullum eventum pro tua quaestione inventum est.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'QvJ', 'Q von J.', 'S from Y', 'S de A.', 'F. a. ');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'QvJh', 'Q von Jh.', 'S from C.', 'S du s. ', 'F. s.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'QbJ', 'Q bis J.', 'S until Y', 'S jusqu’à A.', 'F. usq. a. ');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'QbJh', 'Q bis Jh.', 'S until C.', 'S jusqu’à s.', 'F. usq. s.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'EBvJ', 'EB von J.', 'SR from Y', 'RI de l’A.', 'T. a. ');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'EBvJh', 'EB von Jh.', 'SR from C.', 'RI du s.', 'T. s.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'EBbJ', 'EB bis J.', 'SR until Y', 'RI jusqu’à A.', 'T. usq. a.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'EBbJh', 'EB bis Jh.', 'SR until C.', 'RI jusqu’à s.', 'T. usq. s.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'QJahr', 'Q Jahr', 'S Year ', 'S année', 'F. a.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Signatur', 'Sig.', 'Call no.', 'Cote', 'Sig.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'TZvJ', 'TZ v. J.', 'TW fr. Y.', 'Tém. de année', 'Test. ex a. anno');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'TZbJ', 'TZ b. J.', 'TW till Y.', 'Tém. de [année]', 'Test. ex a. anno');
