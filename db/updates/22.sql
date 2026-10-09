-- remove FK
ALTER TABLE einzelbeleg DROP FOREIGN KEY einzelbeleg_QuelleGattungID;
ALTER TABLE selektion_quellengattung DROP FOREIGN KEY selektion_quellengattung_parentId;

-- this is necessary because the id column contains 0 values. Otherwise an error appears
SET SESSION sql_mode = CONCAT(@@SQL_MODE, ',NO_AUTO_VALUE_ON_ZERO');
-- Change ID Column
ALTER TABLE selektion_quellengattung MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;
-- restore sql mode
SET SESSION sql_mode=default;

-- Add FK
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_QuelleGattungID FOREIGN KEY (QuelleGattungID) REFERENCES selektion_quellengattung(ID) ON UPDATE CASCADE;

ALTER TABLE selektion_quellengattung ADD CONSTRAINT selektion_quellengattung_parentId FOREIGN KEY (parentId) REFERENCES selektion_quellengattung(ID) ON UPDATE CASCADE;
