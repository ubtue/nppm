UPDATE selektion_areal SET Bezeichnung = 'D: Zarten, Baden-Württemberg, Landkr. Breisgau-Hochschwarzwald, Gem. Kirchzarten' WHERE ID = 2841;

UPDATE datenbank_mapping SET Datenfeld = "QuellenKommentar",  de_Beschriftung = "Quellenkommentar", Feldtyp = "select", Auswahlherkunft = "content", Auswahlherkunft_Filter = "context", Filter = "QUELLENKOMMENTAR", gb_beschriftung = "source commentary", fr_beschriftung = "commentaire sur les sources", la_beschriftung = "Commentarius Fontium" WHERE ID = 55;

UPDATE datenbank_mapping SET de_Beschriftung = "Überlieferungskommentar", Feldtyp = "select", Auswahlherkunft = "content", Auswahlherkunft_Filter = "context", Filter = "UEBERLIEFERUNGSKOMMENTAR", gb_beschriftung = "tradition commentary", fr_beschriftung = "commentaire traditionnel", la_beschriftung = "Traditio commentaria" WHERE ID = 56;

UPDATE datenbank_mapping SET gb_beschriftung = "filename", fr_beschriftung = "nom de fichier", la_beschriftung = "file nomen" WHERE ID = 300;

UPDATE selektion_editor SET Bezeichnung = "-" WHERE ID = 1;


