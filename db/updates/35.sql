ALTER TABLE datenbank_mapping ADD COLUMN `schema_org_property` VARCHAR(255) DEFAULT NULL AFTER `default`;
UPDATE datenbank_mapping SET `schema_org_property` = 'sameAs' WHERE Datenfeld='GNDLink' AND Formular='person';
UPDATE datenbank_mapping SET `schema_org_property` = 'name' WHERE Datenfeld = 'Standardname' AND Formular='person';
UPDATE datenbank_mapping SET `schema_org_property` = 'alternateName' WHERE Datenfeld = 'Varianten' AND Formular='person';
