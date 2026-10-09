INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('fields', 'On', 'Alle Felder', 'Show all fields', 'Tous les champs', 'Omnia campos');

INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('fields', 'Off', 'Ausgefüllte Felder', 'Hide fields', 'Masquer les champs', 'Celare campos');

UPDATE `selektion_geschlecht` SET `Bezeichnung` = '-' WHERE (`ID` = '-1');

UPDATE `selektion_janein` SET `Bezeichnung` = '-' WHERE (`ID` = '-1');
