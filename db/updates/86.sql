DELETE FROM datenbank_texte WHERE formular = 'tagungen';
DELETE FROM content WHERE bezeichnung = 'tagungen';

UPDATE datenbank_texte SET Formular = 'aktuelles', de = 'Aktuelles', gb = 'News', fr = 'Nouvelles', la = 'Novitates' WHERE Formular = 'ziele' AND Textfeld = 'Titel';
UPDATE content SET bezeichnung = 'aktuelles.html' WHERE bezeichnung = 'ziele.html';

UPDATE datenbank_texte SET Formular = 'kooperationen', de = 'Kooperationen', gb = 'Cooperation', fr = 'Coopérations', la = 'Cooperationes' WHERE Formular = 'projekte' AND Textfeld = 'Titel';
UPDATE content SET bezeichnung = 'kooperationen.html' WHERE bezeichnung = 'projekte.html';
