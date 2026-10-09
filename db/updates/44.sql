UPDATE einzelbeleg_hatfunktion SET FunktionID = 1209 WHERE FunktionID=1210;
DELETE FROM selektion_funktion WHERE ID=1210;

ALTER TABLE selektion_funktion ADD CONSTRAINT selektion_funktion_Bezeichnung UNIQUE (Bezeichnung);
