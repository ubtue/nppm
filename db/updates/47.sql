UPDATE `datenbank_mapping`
SET `combinedFeldtypen` = 'textfield;search(einzelbeleg,Belegform,EinzelbelegID);link(einzelbeleg,EinzelbelegID,Belegform);date(einzelbeleg,EinzelbelegID, einzelbeleg_hatperson);list(amtweihe,EinzelbelegID);list(stand,EinzelbelegID);info(einzelbeleg,EinzelbelegID,Kontext)'
WHERE `Formular` = 'person' AND `Datenfeld` = 'Einzelbeleg';
