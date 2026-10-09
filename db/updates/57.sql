INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'PhilologischerKommentarID', 'Philologischer Kommentar ID ist nicht vorhanden.', 'Philological commentary ID is not available.', 'L\'ID du commentaire philologique n\'est pas disponible.', 'Commentatio philologica ID non adest.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'LemmaID', 'Lemma ID ist nicht vorhanden.', 'Lemma ID is not available.', 'L\'ID du Lemme n\'est pas disponible.', 'Lemma ID non adest.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'EinzelbelegID', 'Einzelbeleg ID ist nicht vorhanden.', 'Single Reference ID is not available.', 'L\'ID de la référence individuelle n\'est pas disponible.', 'Testimonium ID non adest.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'PersonID', 'Person ID ist nicht vorhanden.', 'Person ID is not available.', 'L\'ID de la personne n\'est pas disponible.', 'Persona ID non adest.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'QuellenID', 'Quellen ID ist nicht vorhanden.', 'Source ID is not available.', 'L\'ID de la source n\'est pas disponible.', 'Fons ID non adest.');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('error', 'EditionID', 'Edition ID ist nicht vorhanden.', 'Edition ID is not available.', 'L\'ID de l\'édition n\'est pas disponible.', 'Editio ID non adest.');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('handschrift', 'Bearbeitungsstatus', 'Bearbeitungsstatus', 'select', '0', 'handschrift_ueberlieferung', 'BearbeitungsstatusID', 'selektion_bearbeitungsstatus', 'handschrift', 'Processing status', 'Statut de traitement', 'Status tractandi');

INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('edition', 'Bearbeitungsstatus', 'Bearbeitungsstatus', 'select', '0', 'edition', 'BearbeitungsstatusID', 'selektion_bearbeitungsstatus', 'edition', 'Processing status', 'Statut de traitement', 'Status tractandi');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Testweise', 'Testweise gibt es hier eine für die Philologen Interessante Liste\n                        zu {Link} dieser Person.{end}', 'For philologists, there is an interesting list available here, related to {Link} this person.{end}', 'À titre d\'essai, voici une liste intéressante pour les philologues, concernant {Link} cette personne.{end}', 'Probationis causa hic est index philologis interesting, qui ad {Link} hanc personam pertinet.{end}');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Abbrechen', 'abbrechen', 'cancel', 'annuler', 'rescinde');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Suchen', 'suchen', 'search', 'rechercher', 'quaerere');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Folgt', 'folgt!', 'follows!', 'suit !', 'sequitur!');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche ', 'Belegform', 'Belegform', 'Form of Reference', 'Forme de la référence', 'Forma Testimonii');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Amt', 'Amt', 'Office', 'Fonction', 'Officium');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche ', 'Ausgabefelder', 'Ausgabefelder', 'Output fields', 'Champs de sortie', 'Agri exitus');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Zusatz', 'Zusatz', 'Addition', 'Ajout', 'Additamentum');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche ', 'DatumErsteNennung', 'Datum erste Nennung', 'Date of first mention', 'Date de la première mention', 'Dies primae mentionis');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'DatumLetzteNennung', 'Datum letzte Nennung', 'Date of last mention', 'Date de la dernière mention', 'Dies ultimae mentionis');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Handschrift', 'Handschrift', 'Handwriting', 'Écriture manuscrite', 'Scriptura manu');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Kurztitel', 'Kurztitel', 'Short title', 'Titre abrégé', 'Titulus brevis');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Zwischenlemma', 'Zwischenlemma', 'Intermediate lemma', 'Lemme intermédiaire', 'Lemma intermedium');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Namenelement', 'Namenelement', 'Name element', 'Élément du nom', 'Elementum nominis');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Link', 'Link', 'Link', 'Lien', 'Vinculum');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'Person', 'Person', 'Person', 'Personne', 'Persona');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('suche', 'SigleVariante', 'Sigle: Variante', 'Siglum: Variant', 'Sigle : Variante', 'Sigla: Varietas');

UPDATE `datenbank_texte` SET `gb` = 'Please truncate your search using the wildcard %, e.g., Karl%Great%. [Help]', `fr` = 'Veuillez tronquer votre recherche avec le caractère générique %, par ex. Karl%Grand%. [Aide]', `la` = 'Quaestionem tuam cum locum tenente % truncare, exempli gratia Karl%Magnus%. [Auxilium]' where Formular = "freie_suche" and Textfeld = "TruncateHint";

UPDATE `datenbank_mapping` SET `fr_beschriftung` = 'Commentaire philologique', `la_beschriftung` = 'Commentatio philologica' where Formular = "freie_suche" and Datenfeld = "Namenlemma";

UPDATE `datenbank_mapping` SET `fr_beschriftung` = 'Commentaire philologique', `la_beschriftung` = 'Commentatio philologica' where Formular = "freie_suche" and Datenfeld = "Ausgabe_Namenlemma";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'First element only', `fr_beschriftung` = 'Seulement le premier membre', `la_beschriftung` = 'Solum membrum primum' where Formular = "freie_suche" and Datenfeld = "Erstglied";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Second element only', `fr_beschriftung` = 'Seulement le deuxième membre', `la_beschriftung` = 'Solum membrum secundum' where Formular = "freie_suche" and Datenfeld = "Zweitglied";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Function (Single Reference)', `fr_beschriftung` = 'Fonction (réference individuelle)', `la_beschriftung` = 'Functio (testimonium)' where Formular = "freie_suche" and Datenfeld = "Funktion";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Degree of kinship', `fr_beschriftung` = 'Degré de parenté', `la_beschriftung` = 'Gradus consanguinitatis' where Formular = "freie_suche" and Datenfeld = "Verwandtschaftsgrad";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Provenance (Single Reference)', `fr_beschriftung` = 'Provenance (Référence individuelle)', `la_beschriftung` = 'Provenientiae (Testimonia)' where Formular = "freie_suche" and Datenfeld = "ProvenanceEinzelbeleg";

UPDATE `datenbank_texte` SET `gb` = 'Format', `fr` = 'Format', `la` = 'Forma' where Formular = "freie_suche" and Textfeld = "Datumsformat";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'First part', `fr_beschriftung` = 'Première partie', `la_beschriftung` = 'Prima pars' where Formular = "freie_suche" and Datenfeld = "Ausgabe_Erstglied";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = ' Second part', `fr_beschriftung` = 'Deuxième partie ', `la_beschriftung` = 'Secunda pars' where Formular = "freie_suche" and Datenfeld = "Ausgabe_Zweitglied";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Relatives', `fr_beschriftung` = 'Parents', `la_beschriftung` = 'Propinqui' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Person_Verwandte";

UPDATE `datenbank_texte` SET `la` = 'Propinqui' where Formular = "person" and Textfeld = "TabVerwandte";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Area', `fr_beschriftung` = 'Région', `la_beschriftung` = 'Regio' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Person_Areal";

UPDATE `datenbank_mapping` SET `fr_beschriftung` = 'Région' WHERE Formular = "person" and Datenfeld = "Areal";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Area;Area-Typ', `fr_beschriftung` = 'Région;Région-Typ', `fr_combinedAnzeigenamen` = 'Région;Type de région', `la_beschriftung` = 'Regio;Regio-Typ', `la_combinedAnzeigenamen` = 'Regio;Typus regionis' WHERE Formular = "einzelbeleg" and Datenfeld = "NewAreal";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Function', `fr_beschriftung` = 'Fonction', `la_beschriftung` = 'Functio' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Funktion";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Text Witnesses', `fr_beschriftung` = 'Témoins textuels', `la_beschriftung` = 'Testimonia textus' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Textzeuge";

UPDATE `datenbank_texte` SET `gb` = 'Text Witnesses', `fr` = 'Témoins textuels' WHERE Formular = "handschrift" and Textfeld = "Titel";

UPDATE `datenbank_texte` SET `gb` = 'Text Witnesses', `fr` = 'Témoins textuels', `la` = 'Testimonia textus' WHERE Formular = "freie_suche" and Textfeld = "!OrderTextzeugen";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Date of text witness', `fr_beschriftung` = 'Datation du témoin', `la_beschriftung` = 'Datatio testimoniorum' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Textzeuge_Datierung";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Writing provenance of the text witness', `fr_beschriftung` = 'Provenance scripturaire du témoin textuel', `la_beschriftung` = 'Origo testis scripturae' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Library origin of the text witness', `fr_beschriftung` = 'Provenance bibliothécaire du témoin textuel', `la_beschriftung` = 'Origo bibliothecae testis' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Einzelbeleg_Textzeuge_Bibliotheksheimat";

UPDATE `datenbank_mapping` SET `gb_beschriftung` = 'Provenance (Single Reference)', `fr_beschriftung` = 'Provenance (Référence individuelle)', `la_beschriftung` = 'Provenientiae (Testimonia)' WHERE Formular = "freie_suche" and Datenfeld = "Ausgabe_Provenance_Einzelbeleg";

UPDATE `datenbank_texte` SET `gb` = 'Currently out of service', `fr` = 'Actuellement non fonctionnel', `la` = 'Nunc sine functione' WHERE Formular = "freie_suche" and Textfeld = "KeineFunktion";

UPDATE `datenbank_texte` SET `gb` = 'Fourth Step', `fr` = 'Quatrième étape', `la` = 'Gradus IV' WHERE Formular = "freie_suche" and Textfeld = "Tab4";

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('logo ', 'NPPM', 'Namen, Personen und Personengruppen des Mittelalters (NPPM)', 'Names, Persons, and Groups of People of the Middle Ages (NPPM)', 'Noms, personnes et groupes de personnes du Moyen Âge (NPPM)', 'Nomina, Personae et Coetus Hominum Medii Aevi (NPPM)');

UPDATE `datenbank_texte` SET `de` = 'Springe zu NPPM-ID:', `gb` = 'Jump to NPPM-ID:', `fr` = 'Aller à NPPM-ID:', `la` = 'Salta ad NPPM-ID:' WHERE Formular = "jump" and Textfeld = "JumpTo";
