# Cleanup DB values which are preventing FOREIGN KEYs from being introduced.

# 1) relational n:m-tables where one of the foreign keys is either NULL or invalid
DELETE FROM einzelbeleg_hatamtweihe WHERE AmtWeiheID NOT IN (SELECT ID FROM selektion_amtweihe); /* 1885/23305 ~8,09%. Affects 10 values of AmtWeiheID that do not exist anymore in selektion_amtweihe. */
DELETE FROM quelle_inedition WHERE EditionID NOT IN (SELECT ID FROM edition); /* 7/2974 ~0,24% */
DELETE FROM einzelbeleg_hatperson WHERE EinzelbelegID NOT IN (SELECT ID FROM einzelbeleg); /* 2/59920 ~0,00% */
DELETE FROM einzelbeleg_hatstand WHERE EinzelbelegID NOT IN (SELECT ID FROM einzelbeleg); /* 2/8443 ~0,02% */
DELETE FROM handschrift_ueberlieferung WHERE HandschriftID NOT IN (SELECT ID FROM handschrift); /* 1/6069 ~0,02% */
DELETE FROM ueberlieferung_edition WHERE UeberlieferungID NOT IN (SELECT ID FROM handschrift_ueberlieferung); /* 99/6866 ~1,44% */
DELETE FROM einzelbeleg_hatnamenkommentar WHERE NamenkommentarID NOT IN (SELECT ID FROM namenkommentar); /* 16/60756 ~0,03% */
DELETE FROM einzelbeleg_hatperson WHERE PersonID NOT IN (SELECT ID FROM person); /* 41/59920 ~0,07% */
DELETE FROM person_verwandtmit WHERE PersonIDzu NOT IN (SELECT ID FROM person); /* 2/34179 ~0,01% */
DELETE FROM urkunde WHERE NOT EXISTS (SELECT * FROM quelle WHERE QuelleID = quelle.ID); /* 150/2683 */
DELETE FROM urkunde_betreff WHERE UrkundeID NOT IN (SELECT ID FROM urkunde); /* 3/1648 ~0,01% */
DELETE FROM urkunde_dorsalnotiz WHERE UrkundeID NOT IN (SELECT ID FROM urkunde); /* 3/406 */
DELETE FROM urkunde_hataussteller WHERE UrkundeID NOT IN (SELECT ID FROM urkunde); /* 3/1697 */
DELETE FROM urkunde_hatempfaenger WHERE UrkundeID NOT IN (SELECT ID FROM urkunde); /* 2/1632 */
DELETE FROM person_hatareal WHERE ArealID NOT IN (SELECT ID FROM selektion_areal); /* 1/18159 ~0,01% */
DELETE FROM edition_hateditor WHERE EditionID = 0; /* 1/704 ~0,14% */
UPDATE einzelbeleg_hatfunktion SET FunktionID = -1 WHERE FunktionID=57; /* 3088/27617 ~11% */
DELETE FROM einzelbeleg_hatstand WHERE StandID NOT IN (SELECT ID FROM selektion_stand); /* 338/8443 ~4%. Affects 25 values of StandID that do not exist anymore in selektion_stand. */
UPDATE einzelbeleg_textkritik SET HandschriftID = -1 WHERE HandschriftID != -1 AND HandschriftID NOT IN (SELECT ID FROM handschrift_ueberlieferung); /* 1253/69970, ~1,8% */
DELETE FROM einzelbeleg_textkritik WHERE EinzelbelegID NOT IN (SELECT ID FROM einzelbeleg); /* 1/69964 */
DELETE FROM namenkommentar_bearbeiter WHERE NOT EXISTS (SELECT * FROM namenkommentar WHERE NamenkommentarID = namenkommentar.ID); /* 28/6134 */
DELETE FROM person_hatstand WHERE StandID NOT IN (SELECT ID FROM selektion_stand); /* 1720/12141 ~14,17% Affects 3 values of StandID that do not exist anymore in selektion_stand. */
UPDATE person_hatamtstandweihe SET AmtWeiheID=-1 WHERE NOT EXISTS (SELECT * FROM selektion_amtweihe WHERE AmtWeiheID = selektion_amtweihe.ID); /* 373/5628 ~6,6%, necessary so we don't lose the comments. */

# 2) 1:n columns with invalid values
DELETE FROM einzelbeleg WHERE BearbeitungsstatusID IS NULL; /* 1/70668 ~0,00% => seems like a dummy value, just delete instead of update (selektion_bearbeitungsstatus) */
UPDATE einzelbeleg SET KasusID = -1 WHERE KasusID IS NULL; /* 316/70668 ~0,45% => -1 is "-", 1 would be "?" (selektion_kasus)*/
UPDATE einzelbeleg SET KasusID = -1 WHERE KasusID = 0; /* 467/70668 ~0,45% => -1 is "-", 1 would be "?" (selektion_kasus)*/

INSERT INTO selektion_ethnienerhalt (ID, Bezeichnung) VALUES (5, 'per Quelle'); /* 12310/13353 ~92,19% (person_hatethnie) */
UPDATE person SET Geschlecht = -1 WHERE Geschlecht IS NULL; /* 6844/30413 ~22,50% => -1 would be "--", 3 would be '?' (selektion_geschlecht) */
UPDATE person SET Fiktiv = -1 WHERE Fiktiv IS NULL; /* 2645/30413 ~8,70% => -1 would be "--",  2 would be '?' (selektion_janein) */
UPDATE edition SET BearbeitungsstatusID = 2 WHERE NOT EXISTS (SELECT * FROM selektion_bearbeitungsstatus WHERE BearbeitungsstatusID = selektion_bearbeitungsstatus.ID);
UPDATE edition SET ReiheID = -1 WHERE NOT EXISTS (SELECT * FROM selektion_reihe WHERE ReiheID = selektion_reihe.ID);
UPDATE einzelbeleg SET GrammatikGeschlechtID = 3 WHERE NOT EXISTS (SELECT * FROM selektion_grammatikgeschlecht WHERE GrammatikGeschlechtID = selektion_grammatikgeschlecht.ID);
UPDATE einzelbeleg SET LebendVerstorbenID = 2 WHERE NOT EXISTS (SELECT * FROM selektion_lebendverstorben WHERE LebendVerstorbenID = selektion_lebendverstorben.ID);
UPDATE einzelbeleg SET EditionID = NULL WHERE NOT EXISTS (SELECT * FROM edition WHERE EditionID = edition.ID);
UPDATE mgh_lemma SET BearbeitungsstatusID = 2 WHERE NOT EXISTS (SELECT * FROM selektion_bearbeitungsstatus WHERE BearbeitungsstatusID = selektion_bearbeitungsstatus.ID );
UPDATE namenkommentar SET BearbeitungsstatusID = 2 WHERE NOT EXISTS (SELECT * FROM selektion_bearbeitungsstatus WHERE BearbeitungsstatusID = selektion_bearbeitungsstatus.ID);

# replace missing user with a valid (149 = "nppm-team")
UPDATE einzelbeleg SET LetzteAenderungVon = 149,ErstelltVon=149,GehoertGruppe=4 WHERE NOT EXISTS (SELECT * FROM benutzer WHERE LetzteAenderungVon = benutzer.ID ) OR NOT EXISTS (SELECT * FROM benutzer WHERE ErstelltVon = benutzer.ID ) OR NOT EXISTS (SELECT * FROM benutzer WHERE GehoertGruppe = benutzer.ID);

DELETE FROM bemerkung WHERE EinzelbelegID IS NOT NULL AND NOT EXISTS (SELECT * FROM einzelbeleg WHERE bemerkung.EinzelbelegID = einzelbeleg.ID);
DELETE FROM bemerkung WHERE PersonID IS NOT NULL AND NOT EXISTS (SELECT * FROM person WHERE bemerkung.PersonID = person.ID);
DELETE FROM bemerkung WHERE QuelleID IS NOT NULL AND NOT EXISTS (SELECT * FROM quelle WHERE bemerkung.QuelleID = quelle.ID);
DELETE FROM bemerkung WHERE EditionID IS NOT NULL AND NOT EXISTS (SELECT * FROM edition WHERE bemerkung.EditionID = edition.ID);
DELETE FROM bemerkung WHERE HandschriftID IS NOT NULL AND NOT EXISTS (SELECT * FROM handschrift WHERE bemerkung.HandschriftID = handschrift.ID);
DELETE FROM bemerkung WHERE NamenkommentarID IS NOT NULL AND NOT EXISTS (SELECT * FROM namenkommentar WHERE bemerkung.NamenkommentarID = namenkommentar.ID);
DELETE FROM bemerkung WHERE MGHLemmaID IS NOT NULL AND NOT EXISTS (SELECT * FROM mgh_lemma WHERE bemerkung.MGHLemmaID = mgh_lemma.ID);
DELETE FROM bemerkung WHERE GruppeID IS NOT NULL AND NOT EXISTS (SELECT * FROM benutzer_gruppe WHERE bemerkung.GruppeID = benutzer_gruppe.ID);
DELETE FROM bemerkung WHERE BenutzerID IS NOT NULL AND NOT EXISTS (SELECT * FROM benutzer WHERE bemerkung.BenutzerID = benutzer.ID);
