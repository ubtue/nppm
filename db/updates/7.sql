# Migration MyISAM => InnoDB
#
# The engine used for new tables is determined by the server default (see "SHOW ENGINES";)
# (There is no Database-specific setting that needs to be changed).
#
# First we must change the engine of all tables,
# afterwards we are able to introduce foreign keys between them.
# (This will be done in a separate update file.)
#
# Note: Several tables are not included:
# - DROPPED tables from previous SQL updates
# - gast... tables, since they are in fact only views (try using "SHOW CREATE TABLE gastquelle;")
#
# You can use the following statement to check the storage engine of all tables:
# - SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'neg';
ALTER TABLE bemerkung ENGINE = INNODB;
ALTER TABLE benutzer ENGINE = INNODB;
ALTER TABLE benutzer_gruppe ENGINE = INNODB;
ALTER TABLE datenbank_filter ENGINE = INNODB;
ALTER TABLE datenbank_mapping ENGINE = INNODB;
ALTER TABLE datenbank_selektion ENGINE = INNODB;
ALTER TABLE datenbank_sprachen ENGINE = INNODB;
ALTER TABLE datenbank_texte ENGINE = INNODB;
ALTER TABLE edition ENGINE = INNODB;
ALTER TABLE edition_band ENGINE = INNODB;
ALTER TABLE edition_bestand ENGINE = INNODB;
ALTER TABLE edition_hateditor ENGINE = INNODB;
ALTER TABLE einzelbeleg ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatamtweihe ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatareal ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatethnie ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatfunktion ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatmghlemma ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatnamenkommentar ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatperson ENGINE = INNODB;
ALTER TABLE einzelbeleg_hatstand ENGINE = INNODB;
ALTER TABLE einzelbeleg_textkritik ENGINE = INNODB;
ALTER TABLE handschrift ENGINE = INNODB;
ALTER TABLE handschrift_ueberlieferung ENGINE = INNODB;
ALTER TABLE mgh_lemma ENGINE = INNODB;
ALTER TABLE mgh_lemma_bearbeiter MODIFY Zeitstempel datetime DEFAULT NOW();
ALTER TABLE mgh_lemma_bearbeiter ENGINE = INNODB;
ALTER TABLE mgh_lemma_korrektor MODIFY Zeitstempel datetime DEFAULT NOW();
ALTER TABLE mgh_lemma_korrektor ENGINE = INNODB;
ALTER TABLE namenkommentar ENGINE = INNODB;
ALTER TABLE namenkommentar_bearbeiter MODIFY Zeitstempel datetime DEFAULT NOW();
ALTER TABLE namenkommentar_bearbeiter ENGINE = INNODB;
ALTER TABLE namenkommentar_korrektor MODIFY Zeitstempel datetime DEFAULT NOW();
ALTER TABLE namenkommentar_korrektor ENGINE = INNODB;
ALTER TABLE person ENGINE = INNODB;
ALTER TABLE person_hatamtstandweihe ENGINE = INNODB;
ALTER TABLE person_hatareal ENGINE = INNODB;
ALTER TABLE person_hatethnie ENGINE = INNODB;
ALTER TABLE person_hatstand ENGINE = INNODB;
ALTER TABLE person_quiet ENGINE = INNODB;
ALTER TABLE person_variante ENGINE = INNODB;
ALTER TABLE person_verwandtmit ENGINE = INNODB;
ALTER TABLE quelle ENGINE = INNODB;
ALTER TABLE quelle_inedition ENGINE = INNODB;
ALTER TABLE selektion_amtstandweihe ENGINE = INNODB;
ALTER TABLE selektion_amtweihe ENGINE = INNODB;
ALTER TABLE selektion_areal ENGINE = INNODB;
ALTER TABLE selektion_autor ENGINE = INNODB;
ALTER TABLE selektion_bearbeitungsstatus ENGINE = INNODB;
ALTER TABLE selektion_bewertung ENGINE = INNODB;
ALTER TABLE selektion_bkz ENGINE = INNODB;
ALTER TABLE selektion_datgenauigkeit ENGINE = INNODB;
ALTER TABLE selektion_dmghband ENGINE = INNODB;
ALTER TABLE selektion_echtheit ENGINE = INNODB;
ALTER TABLE selektion_editor ENGINE = INNODB;
ALTER TABLE selektion_ethnie ENGINE = INNODB;
ALTER TABLE selektion_ethnienerhalt ENGINE = INNODB;
ALTER TABLE selektion_funktion ENGINE = INNODB;
ALTER TABLE selektion_geschlecht ENGINE = INNODB;
ALTER TABLE selektion_grammatikgeschlecht ENGINE = INNODB;
ALTER TABLE selektion_janein ENGINE = INNODB;
ALTER TABLE selektion_kasus ENGINE = INNODB;
ALTER TABLE selektion_lebendverstorben ENGINE = INNODB;
ALTER TABLE selektion_ort ENGINE = INNODB;
ALTER TABLE selektion_quellengattung ENGINE = INNODB;
ALTER TABLE selektion_reihe ENGINE = INNODB;
ALTER TABLE selektion_sammelband ENGINE = INNODB;
ALTER TABLE selektion_stand ENGINE = INNODB;
ALTER TABLE selektion_urkundeausstellerempfaenger ENGINE = INNODB;
ALTER TABLE selektion_verwandtschaftsgrad ENGINE = INNODB;
ALTER TABLE suche_favoriten ENGINE = INNODB;
ALTER TABLE ueberlieferung_edition ENGINE = INNODB;
ALTER TABLE urkunde ENGINE = INNODB;
ALTER TABLE urkunde_betreff ENGINE = INNODB;
ALTER TABLE urkunde_dorsalnotiz ENGINE = INNODB;
ALTER TABLE urkunde_hataussteller ENGINE = INNODB;
ALTER TABLE urkunde_hatempfaenger ENGINE = INNODB;

