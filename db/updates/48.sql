-- Fremdschlüssel entfernen
ALTER TABLE edition_hateditor DROP FOREIGN KEY edition_hateditor_EditorID;
ALTER TABLE edition_hateditor DROP FOREIGN KEY edition_hateditor_EditionID;

-- Datentypen ändern
ALTER TABLE selektion_editor MODIFY ID int;
ALTER TABLE edition_hateditor MODIFY EditorID INT NOT NULL DEFAULT -1;

-- AUTO_INCREMENT hinzufügen
ALTER TABLE selektion_editor MODIFY ID INT NOT NULL AUTO_INCREMENT;

-- IDs aktualisieren
UPDATE selektion_editor
SET ID = -1
WHERE ID = 1;

DELETE FROM edition_hateditor
WHERE EditorID = 1;


-- Fremdschlüssel erneut hinzufügen
ALTER TABLE edition_hateditor
ADD CONSTRAINT edition_hateditor_EditorID FOREIGN KEY (EditorID) REFERENCES selektion_editor(ID);
ALTER TABLE edition_hateditor
ADD CONSTRAINT edition_hateditor_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
