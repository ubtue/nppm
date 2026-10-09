UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'lebend/verstorben', `gb_beschriftung` = 'aive/dead', `fr_beschriftung` = 'vivant/mort', `la_beschriftung` = 'vivus/mortuus' WHERE Formular = "einzelbeleg" and Datenfeld = "LebendVerstorben";

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Moderne Namen', `gb_beschriftung` = 'Modern Names', `fr_beschriftung` = 'Noms modernes', `la_beschriftung` = 'Moderna nomina' WHERE Formular = "person" and Datenfeld = "Varianten";

UPDATE `datenbank_texte` SET `de` = 'Verwandschaftsbeziehung', `gb` = 'Kinship Relationship', `fr` = 'Relation de parenté', `la` = 'Cognationis relatio' WHERE Formular = "gast_person" and Textfeld = "Verwandtschaftsgrade";

UPDATE `datenbank_mapping` SET `de_combinedAnzeigenamen` = 'Person ID;;Name d. Person;Verwandschaftsbeziehung', `gb_combinedAnzeigenamen` = 'Person ID;Name of Person;Kinship Relationship', `fr_combinedAnzeigenamen` = 'Personne ID;;Nom de la personne;Relation de parenté', `la_combinedAnzeigenamen` = 'Numerus personae ID;;Nomen personae;Cognationis relatio' WHERE Formular = "person" and Datenfeld = "Verwandtschaft";

UPDATE `datenbank_mapping` SET `de_Beschriftung` = 'Belegformen', `gb_beschriftung` = 'Forms of Reference', `fr_beschriftung` = 'Formes de référence', `la_beschriftung` = 'Formae testimonii' WHERE Formular = "mgh_lemma" and Datenfeld = "EinzelbelegRO";
