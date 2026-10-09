# InnoDB: Introduce foreign keys (+ normalize primary key / foreign key columns)
#
# Each block in this file is grouped by primary key of a table and consists of the following parts:
# - Normalize the primary key's column
# - Update the foreign key's column values to avoid losing data (e.g. 0 => NULL and so on).
#   sometimes we need to allow NULL in the column before doing this.
# - Normalize the foreign key's column datatype
# - Add the foreign key
#
# (Sometimes a block consits of only 1 line, especially if there are no foreign keys to this primary key.)
# (Existing MyISAM index keys will be kept for performance reasons.)
#
# Notes on datatypes:
#   - Keys with AUTO INCREMENT should always be INT UNSIGNED.
#   - For selektion_... tables this is pretty individual, since some have defaults like (-1, 0, or NULL).
#     try to use INT UNSIGNED whenever there is no -1 value in the table.
#   - Use explicit names for FOREIGN KEYs so we can better manipulate them in later db updates
#   - FOREIGN KEY columns on to selektion_tables:
#     - If they are in a n:m table, they should be NOT NULL without default
#     - If they are in a column, they should be NOT NULL with default -1 or the corresponding default value matching "-" or "--" (NOT "?"!)
#   - So far we will NOT set any key to use ON DELETE CASCADE or ON DELETE UPDATE. This might be done at a later point if needed.
ALTER TABLE bemerkung MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE benutzer MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN BenutzerID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_BenutzerID FOREIGN KEY (BenutzerID) REFERENCES benutzer(ID);
ALTER TABLE edition MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE edition ADD CONSTRAINT edition_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE edition MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE edition ADD CONSTRAINT edition_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE handschrift MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE handschrift ADD CONSTRAINT handschrift_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE handschrift MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE handschrift ADD CONSTRAINT handschrift_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE mgh_lemma MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE mgh_lemma ADD CONSTRAINT mgh_lemma_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE mgh_lemma MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE mgh_lemma ADD CONSTRAINT mgh_lemma_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE mgh_lemma_bearbeiter MODIFY COLUMN BenutzerID INT UNSIGNED;
ALTER TABLE mgh_lemma_bearbeiter ADD CONSTRAINT mgh_lemma_bearbeiter_BenutzerID FOREIGN KEY (BenutzerID) REFERENCES benutzer(ID);
ALTER TABLE mgh_lemma_korrektor MODIFY COLUMN BenutzerID INT UNSIGNED;
ALTER TABLE mgh_lemma_korrektor ADD CONSTRAINT mgh_lemma_korrektor_BenutzerID FOREIGN KEY (BenutzerID) REFERENCES benutzer(ID);
ALTER TABLE namenkommentar MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE namenkommentar ADD CONSTRAINT namenkommentar_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE namenkommentar MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE namenkommentar ADD CONSTRAINT namenkommentar_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE namenkommentar_bearbeiter MODIFY COLUMN BenutzerID INT UNSIGNED;
ALTER TABLE namenkommentar_bearbeiter ADD CONSTRAINT namenkommentar_bearbeiter_BenutzerID FOREIGN KEY (BenutzerID) REFERENCES benutzer(ID);
ALTER TABLE namenkommentar_korrektor MODIFY COLUMN BenutzerID INT UNSIGNED;
ALTER TABLE namenkommentar_korrektor ADD CONSTRAINT namenkommentar_korrektor_BenutzerID FOREIGN KEY (BenutzerID) REFERENCES benutzer(ID);
ALTER TABLE person MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE person ADD CONSTRAINT person_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE person MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE person ADD CONSTRAINT person_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);
ALTER TABLE quelle MODIFY COLUMN ErstelltVon INT UNSIGNED;
ALTER TABLE quelle ADD CONSTRAINT quelle_ErstelltVon FOREIGN KEY (ErstelltVon) REFERENCES benutzer(ID);
ALTER TABLE quelle MODIFY COLUMN LetzteAenderungVon INT UNSIGNED;
ALTER TABLE quelle ADD CONSTRAINT quelle_LetzteAenderungVon FOREIGN KEY (LetzteAenderungVon) REFERENCES benutzer(ID);

ALTER TABLE benutzer_gruppe MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN GruppeID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_GruppeID FOREIGN KEY (GruppeID) REFERENCES benutzer_gruppe(ID);
ALTER TABLE benutzer MODIFY COLUMN GruppeID INT UNSIGNED NOT NULL;
ALTER TABLE benutzer ADD CONSTRAINT benutzer_GruppeID FOREIGN KEY (GruppeID) REFERENCES benutzer_gruppe(ID);
ALTER TABLE edition MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE edition ADD CONSTRAINT edition_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE handschrift MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE handschrift ADD CONSTRAINT handschrift_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE mgh_lemma MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE mgh_lemma ADD CONSTRAINT mgh_lemma_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE namenkommentar MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE namenkommentar ADD CONSTRAINT namenkommentar_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE person MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE person ADD CONSTRAINT person_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);
ALTER TABLE quelle MODIFY COLUMN GehoertGruppe INT UNSIGNED;
ALTER TABLE quelle ADD CONSTRAINT quelle_GehoertGruppe FOREIGN KEY (GehoertGruppe) REFERENCES benutzer_gruppe(ID);

ALTER TABLE datenbank_filter MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE datenbank_mapping MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE datenbank_selektion MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE datenbank_sprachen MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE datenbank_texte MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE edition MODIFY COLUMN ID INT AUTO_INCREMENT; /* there is an edition with ID -2 so we cant go to INT UNSIGNED. */
ALTER TABLE bemerkung MODIFY COLUMN EditionID INT DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE edition_band MODIFY COLUMN EditionID INT NOT NULL;
ALTER TABLE edition_band ADD CONSTRAINT edition_band_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE edition_bestand MODIFY COLUMN EditionID INT NOT NULL;
ALTER TABLE edition_bestand ADD CONSTRAINT edition_bestand_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE edition_hateditor MODIFY COLUMN EditionID INT NOT NULL;
ALTER TABLE edition_hateditor ADD CONSTRAINT edition_hateditor_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN EditionID INT DEFAULT NULL;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE einzelbeleg_textkritik MODIFY COLUMN EditionID INT DEFAULT NULL;
UPDATE einzelbeleg_textkritik SET EditionID = NULL WHERE EditionID = -1 OR EditionID = 0;
ALTER TABLE einzelbeleg_textkritik ADD CONSTRAINT einzelbeleg_textkritik_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN EditionID INT DEFAULT NULL;
UPDATE handschrift_ueberlieferung SET EditionID = NULL WHERE EditionID = -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE quelle_inedition MODIFY COLUMN EditionID INT NOT NULL;
ALTER TABLE quelle_inedition ADD CONSTRAINT quelle_inedition_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);
ALTER TABLE ueberlieferung_edition MODIFY COLUMN EditionID INT DEFAULT NULL;
UPDATE ueberlieferung_edition SET EditionID = NULL WHERE EditionID = -1;
ALTER TABLE ueberlieferung_edition ADD CONSTRAINT ueberlieferung_edition_EditionID FOREIGN KEY (EditionID) REFERENCES edition(ID);

ALTER TABLE edition_band MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE edition_bestand MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE edition_hateditor MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN EinzelbelegID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatamtweihe MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatamtweihe ADD CONSTRAINT einzelbeleg_hatamtweihe_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatareal MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatareal ADD CONSTRAINT einzelbeleg_hatareal_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatethnie MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatethnie ADD CONSTRAINT einzelbeleg_hatethnie_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatfunktion MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatfunktion ADD CONSTRAINT einzelbeleg_hatfunktion_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatmghlemma MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatmghlemma ADD CONSTRAINT einzelbeleg_hatmghlemma_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatnamenkommentar MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatnamenkommentar ADD CONSTRAINT einzelbeleg_hatnamenkommentar_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatperson MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatperson ADD CONSTRAINT einzelbeleg_hatperson_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_hatstand MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatstand ADD CONSTRAINT einzelbeleg_hatstand_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);
ALTER TABLE einzelbeleg_textkritik MODIFY COLUMN EinzelbelegID INT UNSIGNED NOT NULL;
DELETE FROM einzelbeleg_textkritik WHERE EinzelbelegID NOT IN (SELECT ID FROM einzelbeleg); /* 1/69964, copied from 8.sql, only seems to work here after types have changed for some reason. */
ALTER TABLE einzelbeleg_textkritik ADD CONSTRAINT einzelbeleg_textkritik_EinzelbelegID FOREIGN KEY (EinzelbelegID) REFERENCES einzelbeleg(ID);

ALTER TABLE einzelbeleg_hatamtweihe MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatareal MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatethnie MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatfunktion MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatmghlemma MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatnamenkommentar MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatperson MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_hatstand MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE einzelbeleg_textkritik MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

/* gast...-tables are only views and don't need any modifications */

ALTER TABLE handschrift MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN HandschriftID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_HandschriftID FOREIGN KEY (HandschriftID) REFERENCES handschrift(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN HandschriftID INT UNSIGNED DEFAULT NULL;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_HandschriftID FOREIGN KEY (HandschriftID) REFERENCES handschrift(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN HandschriftID INT UNSIGNED DEFAULT NULL;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_HandschriftID FOREIGN KEY (HandschriftID) REFERENCES handschrift(ID);

ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE ueberlieferung_edition MODIFY COLUMN UeberlieferungID INT UNSIGNED NOT NULL;
ALTER TABLE ueberlieferung_edition MODIFY COLUMN UeberlieferungID INT UNSIGNED;
ALTER TABLE ueberlieferung_edition ADD CONSTRAINT ueberlieferung_edition_UeberlieferungID FOREIGN KEY (UeberlieferungID) REFERENCES handschrift_ueberlieferung(ID);
ALTER TABLE einzelbeleg_textkritik MODIFY COLUMN HandschriftID INT DEFAULT NULL;
UPDATE einzelbeleg_textkritik SET HandschriftID=NULL WHERE HandschriftID=0 OR HandschriftID = -1;
ALTER TABLE einzelbeleg_textkritik MODIFY COLUMN HandschriftID INT UNSIGNED DEFAULT NULL;
ALTER TABLE einzelbeleg_textkritik ADD CONSTRAINT einzelbeleg_textkritik_HandschriftID FOREIGN KEY (HandschriftID) REFERENCES handschrift_ueberlieferung(ID);

/* literatur...-tables have been removed from database */

ALTER TABLE mgh_lemma MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN MGHLemmaID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_MGHLemmaID FOREIGN KEY (MGHLemmaID) REFERENCES mgh_lemma(ID);
ALTER TABLE einzelbeleg_hatmghlemma MODIFY COLUMN MGHLemmaID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatmghlemma ADD CONSTRAINT einzelbeleg_hatmghlemma_MGHLemmaID FOREIGN KEY (MGHLemmaID) REFERENCES mgh_lemma(ID);
ALTER TABLE mgh_lemma_bearbeiter MODIFY COLUMN MGHLemmaID INT UNSIGNED NOT NULL;
ALTER TABLE mgh_lemma_bearbeiter ADD CONSTRAINT mgh_lemma_bearbeiter_MGHLemmaID FOREIGN KEY (MGHLemmaID) REFERENCES mgh_lemma(ID);
ALTER TABLE mgh_lemma_korrektor MODIFY COLUMN MGHLemmaID INT UNSIGNED NOT NULL;
ALTER TABLE mgh_lemma_korrektor ADD CONSTRAINT mgh_lemma_korrektor_MGHLemmaID FOREIGN KEY (MGHLemmaID) REFERENCES mgh_lemma(ID);

ALTER TABLE mgh_lemma_bearbeiter MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE mgh_lemma_korrektor MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE namenkommentar MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN NamenkommentarID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_NamenkommentarID FOREIGN KEY (NamenkommentarID) REFERENCES namenkommentar(ID);
ALTER TABLE einzelbeleg_hatnamenkommentar MODIFY COLUMN NamenkommentarID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatnamenkommentar ADD CONSTRAINT einzelbeleg_hatnamenkommentar_NamenkommentarID FOREIGN KEY (NamenkommentarID) REFERENCES namenkommentar(ID);
ALTER TABLE namenkommentar_bearbeiter MODIFY COLUMN NamenkommentarID INT UNSIGNED NOT NULL;
ALTER TABLE namenkommentar_bearbeiter ADD CONSTRAINT namenkommentar_bearbeiter_NamenkommentarID FOREIGN KEY (NamenkommentarID) REFERENCES namenkommentar(ID);
ALTER TABLE namenkommentar_korrektor MODIFY COLUMN NamenkommentarID INT UNSIGNED NOT NULL;
ALTER TABLE namenkommentar_korrektor ADD CONSTRAINT namenkommentar_korrektor_NamenkommentarID FOREIGN KEY (NamenkommentarID) REFERENCES namenkommentar(ID);

ALTER TABLE namenkommentar_bearbeiter MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE namenkommentar_korrektor MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN PersonID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE einzelbeleg_hatperson MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE einzelbeleg_hatperson ADD CONSTRAINT einzelbeleg_hatperson_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_hatamtstandweihe MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE person_hatamtstandweihe ADD CONSTRAINT person_hatamtstandweihe_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_hatareal MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE person_hatareal ADD CONSTRAINT person_hatareal_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_hatethnie MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE person_hatethnie ADD CONSTRAINT person_hatethnie_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_hatstand MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE person_hatstand ADD CONSTRAINT person_hatstand_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_quiet MODIFY COLUMN PersonID INT UNSIGNED NOT NULL;
ALTER TABLE person_quiet ADD CONSTRAINT person_quiet_PersonID FOREIGN KEY (PersonID) REFERENCES person(ID);
ALTER TABLE person_variante MODIFY COLUMN personID INT UNSIGNED NOT NULL;
ALTER TABLE person_variante ADD CONSTRAINT person_variante_personID FOREIGN KEY (personID) REFERENCES person(ID); /* for some reason, "personID" is written with a lowercase p here. will be cleaned up later. */
ALTER TABLE person_verwandtmit MODIFY COLUMN PersonIDvon INT UNSIGNED NOT NULL;
ALTER TABLE person_verwandtmit ADD CONSTRAINT person_verwandtmit_PersonIDvon FOREIGN KEY (PersonIDvon) REFERENCES person(ID);
ALTER TABLE person_verwandtmit MODIFY COLUMN PersonIDzu INT UNSIGNED NOT NULL;
ALTER TABLE person_verwandtmit ADD CONSTRAINT person_verwandtmit_PersonIDzu FOREIGN KEY (PersonIDzu) REFERENCES person(ID);

ALTER TABLE person_hatamtstandweihe MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_hatareal MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_hatethnie MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_hatstand MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_quiet MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_variante MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE person_verwandtmit MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE quelle MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE bemerkung MODIFY COLUMN QuelleID INT UNSIGNED DEFAULT NULL;
ALTER TABLE bemerkung ADD CONSTRAINT bemerkung_QuelleID FOREIGN KEY (QuelleID) REFERENCES quelle(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN QuelleID INT UNSIGNED DEFAULT NULL;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_QuelleID FOREIGN KEY (QuelleID) REFERENCES quelle(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN QuelleID INT UNSIGNED DEFAULT NULL;
UPDATE handschrift_ueberlieferung SET QuelleID = NULL WHERE QuelleID NOT IN (SELECT ID FROM quelle);
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_QuelleID FOREIGN KEY (QuelleID) REFERENCES quelle(ID);
ALTER TABLE quelle_inedition MODIFY COLUMN QuelleID INT UNSIGNED NOT NULL;
ALTER TABLE quelle_inedition ADD CONSTRAINT quelle_inedition_QuelleID FOREIGN KEY (QuelleID) REFERENCES quelle(ID);
ALTER TABLE urkunde MODIFY COLUMN QuelleID INT UNSIGNED NOT NULL;
ALTER TABLE urkunde ADD CONSTRAINT urkunde_QuelleID FOREIGN KEY (QuelleID) REFERENCES quelle(ID);

ALTER TABLE quelle_inedition MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

/* schlagwort...-tables have been removed from database */

ALTER TABLE selektion_amtstandweihe MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 (empty table, might be removed later) */

ALTER TABLE selektion_amtweihe MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
ALTER TABLE einzelbeleg_hatamtweihe MODIFY COLUMN AmtWeiheID INT NOT NULL;
ALTER TABLE einzelbeleg_hatamtweihe ADD CONSTRAINT einzelbeleg_hatamtweihe_AmtWeiheID FOREIGN KEY (AmtWeiheID) REFERENCES selektion_amtweihe(ID);
ALTER TABLE person_hatamtstandweihe MODIFY COLUMN AmtWeiheID INT NOT NULL;
ALTER TABLE person_hatamtstandweihe ADD CONSTRAINT person_hatamtstandweihe_AmtWeiheID FOREIGN KEY (AmtWeiheID) REFERENCES selektion_amtweihe(ID); /* careful, this is NOT selektion_amtstandweihe!!! that table is empty!!! person_hatamtstandweihe should be renamed to person_hatamtweihe at some point. and maybe selektion_amtstandweihe can be dropped. */

ALTER TABLE selektion_areal MODIFY COLUMN ID INT; /* DEFAULT -1. We cannot use AUTO_INCREMENT here because it hasn't been AUTO_INCREMENT before and would cause reindex => foreign references would break. Put on ToDo List for later. */
ALTER TABLE einzelbeleg_hatareal MODIFY COLUMN ArealID INT NOT NULL;
ALTER TABLE einzelbeleg_hatareal ADD CONSTRAINT einzelbeleg_hatareal_ArealID FOREIGN KEY (ArealID) REFERENCES selektion_areal(ID);
ALTER TABLE person_hatareal MODIFY COLUMN ArealID INT NOT NULL;
ALTER TABLE person_hatareal ADD CONSTRAINT person_hatareal_ArealID FOREIGN KEY (ArealID) REFERENCES selektion_areal(ID);

ALTER TABLE selektion_bearbeitungsstatus MODIFY COLUMN ID INT; /* DEFAULT 2 (OLD DEFAULT 0), also no AUTO_INCREMENT */
ALTER TABLE edition MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE edition ADD CONSTRAINT edition_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE einzelbeleg MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
UPDATE handschrift_ueberlieferung SET BearbeitungsstatusID = 2 WHERE BearbeitungsstatusID = 0;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE mgh_lemma MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE mgh_lemma ADD CONSTRAINT mgh_lemma_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE namenkommentar MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE namenkommentar ADD CONSTRAINT namenkommentar_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE person MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE person ADD CONSTRAINT person_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);
ALTER TABLE quelle MODIFY COLUMN BearbeitungsstatusID INT NOT NULL DEFAULT 2;
ALTER TABLE quelle ADD CONSTRAINT quelle_BearbeitungsstatusID FOREIGN KEY (BearbeitungsstatusID) REFERENCES selektion_bearbeitungsstatus(ID);

ALTER TABLE selektion_bewertung MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 (empty table, might be removed later) */

ALTER TABLE selektion_bkz MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 */

ALTER TABLE selektion_datgenauigkeit MODIFY COLUMN ID INT; /* DEFAULT 0, no AUTO_INCREMENT */
UPDATE handschrift_ueberlieferung SET GenauigkeitBisJahr = -1 WHERE GenauigkeitBisJahr IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitBisJahr INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitBisJahr FOREIGN KEY (GenauigkeitBisJahr) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitBisJahrhundert = -1 WHERE GenauigkeitBisJahrhundert IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitBisJahrhundert INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitBisJahrhundert FOREIGN KEY (GenauigkeitBisJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitBisMonat = -1 WHERE GenauigkeitBisMonat IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitBisMonat INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitBisMonat FOREIGN KEY (GenauigkeitBisMonat) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitBisTag = -1 WHERE GenauigkeitBisTag IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitBisTag INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitBisTag FOREIGN KEY (GenauigkeitBisTag) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitVonJahr = -1 WHERE GenauigkeitVonJahr IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitVonJahr INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitVonJahr FOREIGN KEY (GenauigkeitVonJahr) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitVonJahrhundert = -1 WHERE GenauigkeitVonJahrhundert IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitVonJahrhundert INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitVonJahrhundert FOREIGN KEY (GenauigkeitVonJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitVonMonat = -1 WHERE GenauigkeitVonMonat IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitVonMonat INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitVonMonat FOREIGN KEY (GenauigkeitVonMonat) REFERENCES selektion_datgenauigkeit(ID);
UPDATE handschrift_ueberlieferung SET GenauigkeitVonTag = -1 WHERE GenauigkeitVonTag IS NULL;
ALTER TABLE handschrift_ueberlieferung MODIFY COLUMN GenauigkeitVonTag INT NOT NULL DEFAULT -1;
ALTER TABLE handschrift_ueberlieferung ADD CONSTRAINT handschrift_ueberlieferung_GenauigkeitVonTag FOREIGN KEY (GenauigkeitVonTag) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitBisJahr = -1 WHERE GenauigkeitBisJahr IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitBisJahr INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitBisJahr FOREIGN KEY (GenauigkeitBisJahr) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitBisJahrhundert = -1 WHERE GenauigkeitBisJahrhundert IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitBisJahrhundert INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitBisJahrhundert FOREIGN KEY (GenauigkeitBisJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitBisMonat = -1 WHERE GenauigkeitBisMonat IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitBisMonat INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitBisMonat FOREIGN KEY (GenauigkeitBisMonat) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitBisTag = -1 WHERE GenauigkeitBisTag IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitBisTag INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitBisTag FOREIGN KEY (GenauigkeitBisTag) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitVonJahr = -1 WHERE GenauigkeitVonJahr IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitVonJahr INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitVonJahr FOREIGN KEY (GenauigkeitVonJahr) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitVonJahrhundert = -1 WHERE GenauigkeitVonJahrhundert IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitVonJahrhundert INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitVonJahrhundert FOREIGN KEY (GenauigkeitVonJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitVonMonat = -1 WHERE GenauigkeitVonMonat IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitVonMonat INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitVonMonat FOREIGN KEY (GenauigkeitVonMonat) REFERENCES selektion_datgenauigkeit(ID);
UPDATE quelle SET GenauigkeitVonTag = -1 WHERE GenauigkeitVonTag IS NULL;
ALTER TABLE quelle MODIFY COLUMN GenauigkeitVonTag INT NOT NULL DEFAULT -1;
ALTER TABLE quelle ADD CONSTRAINT quelle_GenauigkeitVonTag FOREIGN KEY (GenauigkeitVonTag) REFERENCES selektion_datgenauigkeit(ID);

ALTER TABLE selektion_dmghband MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
UPDATE edition SET dMGHBandID = -1 WHERE dMGHBandID IS NULL;
ALTER TABLE edition MODIFY COLUMN dMGHBandID INT NOT NULL DEFAULT -1;
ALTER TABLE edition ADD CONSTRAINT edition_dMGHBandID FOREIGN KEY (dMGHBandID) REFERENCES selektion_dmghband(ID);

ALTER TABLE selektion_echtheit MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 */
UPDATE einzelbeleg SET QuelleEchtheitID = -1 WHERE QuelleEchtheitID IS NULL;
UPDATE einzelbeleg SET QuelleEchtheitID = -1 WHERE QuelleEchtheitID = 0;
ALTER TABLE einzelbeleg MODIFY COLUMN QuelleEchtheitID INT NOT NULL DEFAULT -1;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_QuelleEchtheitID FOREIGN KEY (QuelleEchtheitID) REFERENCES selektion_echtheit(ID);

ALTER TABLE selektion_editor MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT; /* DEFAULT NULL */
ALTER TABLE edition_hateditor MODIFY COLUMN EditorID INT UNSIGNED NOT NULL;
ALTER TABLE edition_hateditor ADD CONSTRAINT edition_hateditor_EditorID FOREIGN KEY (EditorID) REFERENCES selektion_editor(ID);

ALTER TABLE selektion_ethnie MODIFY COLUMN ID INT; /* DEFAULT -1, no AUTO_INCREMENT */
ALTER TABLE einzelbeleg_hatethnie MODIFY COLUMN EthnieID INT NOT NULL;
ALTER TABLE einzelbeleg_hatethnie ADD CONSTRAINT einzelbeleg_hatethnie_EthnieID FOREIGN KEY (EthnieID) REFERENCES selektion_ethnie(ID);
ALTER TABLE person_hatethnie MODIFY COLUMN EthnieID INT NOT NULL;
ALTER TABLE person_hatethnie ADD CONSTRAINT person_hatethnie_EthnieID FOREIGN KEY (EthnieID) REFERENCES selektion_ethnie(ID);

ALTER TABLE selektion_ethnienerhalt MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 => -1*/
ALTER TABLE person_hatethnie MODIFY COLUMN EthnienerhaltID INT NOT NULL;
ALTER TABLE person_hatethnie ADD CONSTRAINT person_hatethnie_EthnienerhaltID FOREIGN KEY (EthnienerhaltID) REFERENCES selektion_ethnienerhalt(ID); /* Problem here? Check! /*

ALTER TABLE selektion_funktion MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 => -1*/
UPDATE einzelbeleg_hatfunktion SET FunktionID = -1 WHERE FunktionID IS NULL;
ALTER TABLE einzelbeleg_hatfunktion MODIFY COLUMN FunktionID INT NOT NULL;
ALTER TABLE einzelbeleg_hatfunktion ADD CONSTRAINT einzelbeleg_hatfunktion_FunktionID FOREIGN KEY (FunktionID) REFERENCES selektion_funktion(ID);

ALTER TABLE selektion_geschlecht MODIFY COLUMN ID INT; /* DEFAULT -1, no AUTO_INCREMENT */
UPDATE person SET Geschlecht = -1 WHERE Geschlecht IS NULL;
ALTER TABLE person MODIFY COLUMN Geschlecht INT NOT NULL DEFAULT -1;
ALTER TABLE person ADD CONSTRAINT person_Geschlecht FOREIGN KEY (Geschlecht) REFERENCES selektion_geschlecht(ID);

ALTER TABLE selektion_grammatikgeschlecht MODIFY COLUMN ID INT UNSIGNED; /* DEFAULT 3, no AUTO_INCREMENT */
UPDATE einzelbeleg SET GrammatikGeschlechtID = 3 WHERE GrammatikGeschlechtID IS NULL;
ALTER TABLE einzelbeleg MODIFY COLUMN GrammatikGeschlechtID INT UNSIGNED NOT NULL DEFAULT 3;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GrammatikGeschlechtID FOREIGN KEY (GrammatikGeschlechtID) REFERENCES selektion_grammatikgeschlecht(ID);

ALTER TABLE selektion_janein MODIFY COLUMN ID INT; /* DEFAULT -1, no AUTO_INCREMENT */
UPDATE person SET Fiktiv = -1 WHERE Fiktiv IS NULL;
ALTER TABLE person MODIFY COLUMN Fiktiv INT NOT NULL DEFAULT -1;
ALTER TABLE person ADD CONSTRAINT person_Fiktiv FOREIGN KEY (Fiktiv) REFERENCES selektion_janein(ID);

ALTER TABLE selektion_kasus MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
UPDATE einzelbeleg SET KasusID = -1 WHERE KasusID IS NULL;
ALTER TABLE einzelbeleg MODIFY COLUMN KasusID INT NOT NULL DEFAULT -1;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_KasusID FOREIGN KEY (KasusID) REFERENCES selektion_kasus(ID);

ALTER TABLE selektion_lebendverstorben MODIFY COLUMN ID INT UNSIGNED; /* DEFAULT 2, no AUTO_INCREMENT */
UPDATE einzelbeleg SET LebendVerstorbenID = -2 WHERE LebendVerstorbenID IS NULL;
ALTER TABLE einzelbeleg MODIFY COLUMN LebendVerstorbenID INT UNSIGNED NOT NULL DEFAULT 2;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_LebendVerstorbenID FOREIGN KEY (LebendVerstorbenID) REFERENCES selektion_lebendverstorben(ID);

/* selektion_literaturtyp has been removed from database */

ALTER TABLE selektion_ort MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
UPDATE edition SET OrtID = -1 WHERE OrtID IS NULL;
ALTER TABLE edition MODIFY COLUMN OrtID INT NOT NULL DEFAULT -1;
ALTER TABLE edition ADD CONSTRAINT edition_OrtID FOREIGN KEY (OrtID) REFERENCES selektion_ort(ID);

ALTER TABLE selektion_quellengattung MODIFY COLUMN ID INT; /* DEFAULT -1, no AUTO_INCREMENT */
UPDATE einzelbeleg SET QuelleGattungID = -1 WHERE QuelleGattungID IS NULL;
ALTER TABLE einzelbeleg MODIFY COLUMN QuelleGattungID INT NOT NULL DEFAULT -1;
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_QuelleGattungID FOREIGN KEY (QuelleGattungID) REFERENCES selektion_quellengattung(ID);

ALTER TABLE selektion_reihe MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
UPDATE edition SET ReiheID = -1 WHERE ReiheID IS NULL;
ALTER TABLE edition MODIFY COLUMN ReiheID INT NOT NULL DEFAULT -1;
ALTER TABLE edition ADD CONSTRAINT edition_ReiheID FOREIGN KEY (ReiheID) REFERENCES selektion_reihe(ID);

ALTER TABLE selektion_sammelband MODIFY COLUMN ID INT UNSIGNED; /* DEFAULT NULL here because there is no -1 and 0 is an allowed value + no AUTO_INCREMENT */
ALTER TABLE edition MODIFY COLUMN SammelbandID INT UNSIGNED DEFAULT NULL;
ALTER TABLE edition ADD CONSTRAINT edition_SammelbandID FOREIGN KEY (SammelbandID) REFERENCES selektion_sammelband(ID);

ALTER TABLE selektion_stand MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
ALTER TABLE einzelbeleg_hatstand MODIFY COLUMN StandID INT NOT NULL;
ALTER TABLE einzelbeleg_hatstand ADD CONSTRAINT einzelbeleg_hatstand_StandID FOREIGN KEY (StandID) REFERENCES selektion_stand(ID);
ALTER TABLE person_hatstand MODIFY COLUMN StandID INT NOT NULL;
ALTER TABLE person_hatstand ADD CONSTRAINT person_hatstand_StandID FOREIGN KEY (StandID) REFERENCES selektion_stand(ID);

/* selektion_sw_...-tables have been removed from database */

ALTER TABLE selektion_urkundeausstellerempfaenger MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT 0 => -1 or 1?*/
ALTER TABLE urkunde_hataussteller MODIFY COLUMN AusstellerID INT NOT NULL;
ALTER TABLE urkunde_hataussteller ADD CONSTRAINT urkunde_hataussteller_AusstellerID FOREIGN KEY (AusstellerID) REFERENCES selektion_urkundeausstellerempfaenger(ID);
ALTER TABLE urkunde_hatempfaenger MODIFY COLUMN EmpfaengerID INT NOT NULL;
ALTER TABLE urkunde_hatempfaenger ADD CONSTRAINT urkunde_hatempfaenger_EmpfaengerID FOREIGN KEY (EmpfaengerID) REFERENCES selektion_urkundeausstellerempfaenger(ID);

ALTER TABLE selektion_verwandtschaftsgrad MODIFY COLUMN ID INT AUTO_INCREMENT; /* DEFAULT -1 */
ALTER TABLE person_verwandtmit MODIFY COLUMN VerwandtschaftsgradID INT NOT NULL;
ALTER TABLE person_verwandtmit ADD CONSTRAINT person_verwandtmit_VerwandtschaftsgradID FOREIGN KEY (VerwandtschaftsgradID) REFERENCES selektion_verwandtschaftsgrad(ID);

ALTER TABLE suche_favoriten MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE ueberlieferung_edition MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE urkunde MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;
ALTER TABLE urkunde_betreff MODIFY COLUMN UrkundeID INT UNSIGNED NOT NULL;
ALTER TABLE urkunde_betreff ADD CONSTRAINT urkunde_betreff_UrkundeID FOREIGN KEY (UrkundeID) REFERENCES urkunde(ID);
ALTER TABLE urkunde_dorsalnotiz MODIFY COLUMN UrkundeID INT UNSIGNED NOT NULL;
ALTER TABLE urkunde_dorsalnotiz ADD CONSTRAINT urkunde_dorsalnotiz_UrkundeID FOREIGN KEY (UrkundeID) REFERENCES urkunde(ID);
ALTER TABLE urkunde_hataussteller MODIFY COLUMN UrkundeID INT UNSIGNED NOT NULL;
ALTER TABLE urkunde_hataussteller ADD CONSTRAINT urkunde_hataussteller_UrkundeID FOREIGN KEY (UrkundeID) REFERENCES urkunde(ID);
ALTER TABLE urkunde_hatempfaenger MODIFY COLUMN UrkundeID INT UNSIGNED NOT NULL;
ALTER TABLE urkunde_hatempfaenger ADD CONSTRAINT urkunde_hatempfaenger_UrkundeID FOREIGN KEY (UrkundeID) REFERENCES urkunde(ID);

ALTER TABLE urkunde_betreff MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE urkunde_dorsalnotiz MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE urkunde_hataussteller MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

ALTER TABLE urkunde_hatempfaenger MODIFY COLUMN ID INT UNSIGNED AUTO_INCREMENT;

