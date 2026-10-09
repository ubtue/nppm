INSERT INTO datenbank_mapping(Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung)  VALUES ("freie_suche", "Seite", "Seite", "textfield", 0, "freie_suche", "page", "page", "pagina");

UPDATE datenbank_mapping SET de_Tooltip = 'Die NeG-ID besteht aus einem Buchstaben für die Art des Datensatzes (B=Einzelbeleg, E=Edition, M=MGH-Lemma, N=NamenLemma, P=Person, Q=Quelle) + laufender Nummer (z. b. P 7404 = Karl der Große). Geben Sie hier eine vollständige ID ein. Die ID finden Sie oben rechts in jedem Datensatz-Eintrag' WHERE ID = 276;

ALTER TABLE ueberlieferung_edition
	DROP FOREIGN KEY ueberlieferung_edition_EditionID;	
     

ALTER TABLE ueberlieferung_edition    
ADD CONSTRAINT ueberlieferung_edition_EditionID FOREIGN KEY (EditionID) REFERENCES edition (ID) ON DELETE CASCADE;  

ALTER TABLE ueberlieferung_edition
	DROP FOREIGN KEY ueberlieferung_edition_UeberlieferungID;

ALTER TABLE ueberlieferung_edition	    
     	ADD CONSTRAINT ueberlieferung_edition_UeberlieferungID FOREIGN KEY (UeberlieferungID) REFERENCES handschrift_ueberlieferung (ID) ON DELETE CASCADE; 


UPDATE datenbank_mapping SET Seite = "einzelbeleg"  WHERE ID = 293;

ALTER TABLE  einzelbeleg_textkritik DROP FOREIGN KEY einzelbeleg_textkritik_HandschriftID;

ALTER TABLE einzelbeleg_textkritik	    
     	ADD CONSTRAINT einzelbeleg_textkritik_HandschriftID FOREIGN KEY (HandschriftID) REFERENCES handschrift_ueberlieferung (ID) ON DELETE SET NULL;