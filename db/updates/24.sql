INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('handschrift', 'Bearbeitungsstatus', 'Bearbeitungsstatus', 'select', '0', 'handschrift_ueberlieferung', 'BearbeitungsstatusID', 'selektion_bearbeitungsstatus', 'handschrift', 'processing status', 'statut de traitement', 'status tractandi');
								
								
INSERT INTO `datenbank_mapping` (`Formular`, `Datenfeld`, `de_Beschriftung`, `Feldtyp`, `Array`, `ZielTabelle`, `ZielAttribut`, `Auswahlherkunft`, `Seite`, `gb_beschriftung`, `fr_beschriftung`, `la_beschriftung`) VALUES ('edition', 'Bearbeitungsstatus', 'Bearbeitungsstatus', 'select', '0', 'edition', 'BearbeitungsstatusID', 'selektion_bearbeitungsstatus', 'edition', 'processing status', 'statut de traitement', 'status tractandi');								
								
								
UPDATE namenkommentar SET Dateiname = null WHERE Dateiname = '';
