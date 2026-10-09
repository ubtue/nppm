INSERT INTO `datenbank_texte` (`Formular`, `Textfeld`, `de`, `gb`, `fr`, `la`) VALUES ('person', 'Identifizierungsproblem', 'Kommentar', 'Comment', 'Commentaire', 'Commentarius');

ALTER TABLE einzelbeleg MODIFY COLUMN pal_abgrenzung varchar(255), MODIFY COLUMN inh_abgrenzung varchar(255), MODIFY COLUMN nr_in_strukt varchar(255), MODIFY COLUMN seite varchar(255), MODIFY COLUMN raster varchar(255), MODIFY COLUMN schreiber varchar(255);
