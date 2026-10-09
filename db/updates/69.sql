INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('pagination', 'Next', 'Weiter', 'Next', 'Suivant', 'Deinde');
INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('pagination', 'Prev', 'Zurück', 'Previous', 'Précédente', 'Praecedens');
INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('pagination', 'First', 'Anfang', 'First', 'D\'abord', 'Primus');
INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('pagination', 'Last', 'Ende', 'Last', 'Dernière', 'Ultimus');

#Bereits vorhandene Texte für pagination verallgemeinern, um sie in mehreren Formularen zu verwenden
UPDATE `datenbank_texte` SET `Formular`='pagination' WHERE `Formular`='stat' AND `Textfeld`='SortAZ';
UPDATE `datenbank_texte` SET `Formular`='pagination' WHERE `Formular`='stat' AND `Textfeld`='SortZA';
UPDATE `datenbank_texte` SET `Formular`='pagination' WHERE `Formular`='stat' AND `Textfeld`='SortUp';
UPDATE `datenbank_texte` SET `Formular`='pagination' WHERE `Formular`='stat' AND `Textfeld`='SortDown';
