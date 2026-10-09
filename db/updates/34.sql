DELETE FROM selektion_ort WHERE ID BETWEEN 39 AND 60;

CREATE TABLE person_hatgruppeherkunftareal (
    ID int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
    PersonID int unsigned NOT NULL,
    ArealID int NOT NULL,
    CONSTRAINT person_hatgruppeherkunftareal_PersonID 
        FOREIGN KEY (PersonID) REFERENCES person(ID),
    CONSTRAINT person_hatgruppeherkunftareal_ArealID 
        FOREIGN KEY (ArealID) REFERENCES selektion_areal(ID)
    )
    ENGINE=InnoDB 
    DEFAULT CHARSET=utf8mb4
    COLLATE=utf8mb4_unicode_ci;

INSERT INTO datenbank_mapping (Formular, Datenfeld, de_Beschriftung, Feldtyp, Array, ZielTabelle, ZielAttribut, FormularAttribut, Auswahlherkunft, Seite, gb_beschriftung, fr_beschriftung, la_beschriftung) VALUES ("person", "GruppeHerkunft", "Gruppe Herkunft", "addselect", 1, "person_hatgruppeherkunftareal", "ArealID", "PersonID", "selektion_areal", "person", "Group origin", "Groupe Origine", "Gruppus Originis");

UPDATE `datenbank_mapping` SET `FormularAttribut` = 'NULL' WHERE Formular = 'person' and Datenfeld = 'GND';

UPDATE `datenbank_mapping` SET `FormularAttribut` = 'PersonID' WHERE Formular = 'person' and Datenfeld = 'Varianten';
	