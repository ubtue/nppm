#Literatur
ALTER TABLE bemerkung DROP column LiteraturID;
DROP TABLE literatur;
DROP TABLE literatur_autor;
DROP TABLE literatur_herausgeber;
DROP TABLE literatur_sw_arealgens;
DROP TABLE literatur_sw_morphologie;
DROP TABLE literatur_sw_namenelemente;
DROP TABLE literatur_sw_phongraph;
DELETE FROM datenbank_selektion WHERE selektion = "selektion_literaturtyp";
DROP TABLE selektion_literaturtyp;
