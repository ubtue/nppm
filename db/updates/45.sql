ALTER TABLE einzelbeleg_hattitelkritik ADD provenance_source VARCHAR (255) NOT NULL DEFAULT('NeG');
ALTER TABLE einzelbeleg_hattitelkritik ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);

ALTER TABLE person_hatgruppeherkunftareal ADD provenance_source VARCHAR (255) NOT NULL DEFAULT('NeG');
ALTER TABLE person_hatgruppeherkunftareal ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);

ALTER TABLE selektion_beziehung_gemeinschaft ADD provenance_source VARCHAR (255) NOT NULL DEFAULT('NeG');
ALTER TABLE selektion_beziehung_gemeinschaft ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);

ALTER TABLE selektion_kontext ADD provenance_source VARCHAR (255) NOT NULL DEFAULT('NeG');
ALTER TABLE selektion_kontext ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);

ALTER TABLE selektion_kritik ADD provenance_source VARCHAR (255) NOT NULL DEFAULT('NeG');
ALTER TABLE selektion_kritik ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);

#Add missing id column to bemerkung
ALTER TABLE bemerkung ADD provenance_id VARCHAR (255) DEFAULT NULL, ADD CONSTRAINT unique_provenance_id UNIQUE (provenance_id);
