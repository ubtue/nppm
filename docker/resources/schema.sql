-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: localhost    Database: nppm
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bemerkung`
--

DROP TABLE IF EXISTS `bemerkung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bemerkung` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bemerkung` longtext NOT NULL,
  `PersonID` int DEFAULT NULL,
  `EinzelbelegID` int DEFAULT NULL,
  `QuelleID` int DEFAULT NULL,
  `EditionID` int DEFAULT NULL,
  `HandschriftID` int DEFAULT NULL,
  `NamenkommentarID` int DEFAULT NULL,
  `MGHLemmaID` int DEFAULT NULL,
  `LiteraturID` int DEFAULT NULL,
  `GruppeID` int DEFAULT NULL,
  `BenutzerID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `QuelleID` (`QuelleID`),
  KEY `EditionID` (`EditionID`),
  KEY `HandschriftID` (`HandschriftID`),
  KEY `NamenkommentarID` (`NamenkommentarID`),
  KEY `LiteraturID` (`LiteraturID`),
  KEY `GruppeID` (`GruppeID`),
  KEY `BenutzerID` (`BenutzerID`),
  KEY `MGHLemmaID` (`MGHLemmaID`)
) ENGINE=MyISAM AUTO_INCREMENT=9955 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `benutzer`
--

DROP TABLE IF EXISTS `benutzer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `benutzer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Login` varchar(255) NOT NULL DEFAULT '',
  `Nachname` varchar(255) NOT NULL DEFAULT '',
  `Vorname` varchar(255) NOT NULL DEFAULT '',
  `EMail` varchar(255) NOT NULL DEFAULT '',
  `Password` varchar(255) NOT NULL DEFAULT '',
  `IstAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `GruppeID` int DEFAULT NULL,
  `Sprache` varchar(3) NOT NULL DEFAULT 'de',
  `IstGast` tinyint(1) NOT NULL DEFAULT '0',
  `IstAktiv` tinyint unsigned NOT NULL DEFAULT '1',
  `IstReadOnly` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `benutzer_gruppe`
--

DROP TABLE IF EXISTS `benutzer_gruppe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `benutzer_gruppe` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datenbank_filter`
--

DROP TABLE IF EXISTS `datenbank_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datenbank_filter` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Formular` varchar(255) NOT NULL,
  `Bezeichnung` varchar(255) NOT NULL,
  `SQLString` varchar(255) NOT NULL,
  `Nummer` int unsigned NOT NULL,
  `gb` varchar(255) NOT NULL,
  `fr` varchar(45) NOT NULL,
  `la` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Formular` (`Formular`),
  KEY `Bezeichnung` (`Bezeichnung`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datenbank_mapping`
--

DROP TABLE IF EXISTS `datenbank_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datenbank_mapping` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Formular` varchar(50) NOT NULL DEFAULT '',
  `Datenfeld` varchar(50) NOT NULL DEFAULT '',
  `de_Beschriftung` varchar(255) DEFAULT NULL,
  `Feldtyp` varchar(255) NOT NULL,
  `Array` tinyint(1) NOT NULL DEFAULT '0',
  `ZielTabelle` varchar(50) DEFAULT NULL,
  `ZielAttribut` varchar(255) DEFAULT NULL,
  `FormularAttribut` varchar(255) DEFAULT NULL,
  `Auswahlherkunft` varchar(50) DEFAULT NULL,
  `combinedFeldnamen` varchar(255) DEFAULT NULL,
  `combinedFeldtypen` varchar(255) DEFAULT NULL,
  `de_combinedAnzeigenamen` varchar(255) DEFAULT NULL,
  `buttonAktion` varchar(255) DEFAULT NULL,
  `Seite` varchar(255) DEFAULT NULL,
  `default` varchar(255) DEFAULT NULL,
  `gb_beschriftung` varchar(255) DEFAULT NULL,
  `fr_beschriftung` varchar(255) DEFAULT NULL,
  `gb_combinedAnzeigenamen` varchar(255) DEFAULT NULL,
  `fr_combinedAnzeigenamen` varchar(255) DEFAULT NULL,
  `la_beschriftung` varchar(255) DEFAULT NULL,
  `la_combinedAnzeigenamen` varchar(255) DEFAULT NULL,
  `de_Platzhalter` varchar(255) DEFAULT NULL,
  `gb_Platzhalter` varchar(255) DEFAULT NULL,
  `fr_Platzhalter` varchar(255) DEFAULT NULL,
  `la_Platzhalter` varchar(255) DEFAULT NULL,
  `de_Tooltip` text,
  `gb_Tooltip` text,
  `fr_Tooltip` text,
  `la_Tooltip` text,
  PRIMARY KEY (`ID`),
  KEY `Formular` (`Formular`),
  KEY `Datenfeld` (`Datenfeld`)
) ENGINE=MyISAM AUTO_INCREMENT=299 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datenbank_selektion`
--

DROP TABLE IF EXISTS `datenbank_selektion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datenbank_selektion` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `selektion` varchar(255) NOT NULL,
  `tabelle` varchar(255) NOT NULL,
  `spalte` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datenbank_sprachen`
--

DROP TABLE IF EXISTS `datenbank_sprachen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datenbank_sprachen` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Sprache` varchar(45) NOT NULL,
  `Kuerzel` varchar(3) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datenbank_texte`
--

DROP TABLE IF EXISTS `datenbank_texte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datenbank_texte` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Formular` varchar(50) NOT NULL,
  `Textfeld` varchar(50) NOT NULL,
  `de` varchar(255) NOT NULL DEFAULT 'TODO',
  `gb` varchar(255) NOT NULL DEFAULT 'TODO',
  `fr` varchar(255) NOT NULL DEFAULT 'TODO',
  `la` varchar(255) NOT NULL DEFAULT 'TODO',
  PRIMARY KEY (`ID`),
  KEY `Formular` (`Formular`),
  KEY `Textfeld` (`Textfeld`)
) ENGINE=MyISAM AUTO_INCREMENT=192 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edition`
--

DROP TABLE IF EXISTS `edition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `edition` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Titel` varchar(255) NOT NULL DEFAULT '',
  `Jahr` varchar(255) DEFAULT NULL,
  `Seiten` varchar(255) DEFAULT NULL,
  `Zitierweise` varchar(255) DEFAULT NULL,
  `OrtID` int DEFAULT NULL,
  `ReiheID` int DEFAULT NULL,
  `SammelbandID` int DEFAULT NULL,
  `Verbindlich` int DEFAULT NULL,
  `BearbeitungsstatusID` int NOT NULL DEFAULT '0',
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `BandNummer` varchar(100) DEFAULT NULL,
  `dMGHBandID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `OrtID` (`OrtID`),
  KEY `ReiheID` (`ReiheID`),
  KEY `SammelbandID` (`SammelbandID`),
  KEY `dMGHBandID` (`dMGHBandID`)
) ENGINE=MyISAM AUTO_INCREMENT=2841 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edition_band`
--

DROP TABLE IF EXISTS `edition_band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `edition_band` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EditionID` int NOT NULL DEFAULT '0',
  `BandNummer` varchar(255) DEFAULT NULL,
  `Jahr` varchar(255) DEFAULT NULL,
  `Standard` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`)
) ENGINE=MyISAM AUTO_INCREMENT=875 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edition_bestand`
--

DROP TABLE IF EXISTS `edition_bestand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `edition_bestand` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EditionID` int NOT NULL DEFAULT '0',
  `BKZ` int DEFAULT '0',
  `Signatur` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`)
) ENGINE=MyISAM AUTO_INCREMENT=424 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edition_hateditor`
--

DROP TABLE IF EXISTS `edition_hateditor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `edition_hateditor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EditionID` int NOT NULL DEFAULT '0',
  `EditorID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`),
  KEY `EditorID` (`EditorID`)
) ENGINE=MyISAM AUTO_INCREMENT=3136 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg`
--

DROP TABLE IF EXISTS `einzelbeleg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Belegnummer` varchar(10) NOT NULL DEFAULT '0',
  `Kontext` text,
  `GeschlechtID` int DEFAULT NULL,
  `LebendVerstorbenID` int DEFAULT NULL,
  `EditionID` int DEFAULT NULL,
  `HandschriftID` int DEFAULT NULL,
  `QuelleID` int DEFAULT NULL,
  `EditionKapitel` varchar(255) DEFAULT NULL,
  `EditionSeite` varchar(255) DEFAULT NULL,
  `QuelleGattungID` int NOT NULL DEFAULT '-1',
  `QuelleEchtheitID` int DEFAULT NULL,
  `QuelleDatierung` varchar(255) DEFAULT NULL,
  `UeberlieferungDatierung` varchar(255) DEFAULT NULL,
  `Belegform` varchar(255) NOT NULL DEFAULT '',
  `Griechisch` varchar(255) DEFAULT NULL,
  `Diakritisch` varchar(255) DEFAULT NULL,
  `KasusID` int DEFAULT NULL,
  `GrammatikGeschlechtID` int DEFAULT NULL,
  `ASWQuellenzitat` text,
  `Bemerkung` text,
  `BearbeitungsstatusID` int DEFAULT NULL,
  `KommentarEthnie` text,
  `KommentarAreal` text,
  `KommentarVerwandtschaft` text,
  `Eindeutig` tinyint(1) DEFAULT NULL,
  `VonTag` int DEFAULT NULL,
  `VonMonat` int DEFAULT NULL,
  `VonJahr` int DEFAULT NULL,
  `VonJahrhundert` varchar(5) DEFAULT NULL,
  `BisTag` int DEFAULT NULL,
  `BisMonat` int DEFAULT NULL,
  `BisJahr` int DEFAULT NULL,
  `BisJahrhundert` varchar(5) DEFAULT NULL,
  `GenauigkeitVonTag` int DEFAULT '-1',
  `GenauigkeitVonMonat` int DEFAULT '-1',
  `GenauigkeitVonJahr` int DEFAULT '-1',
  `GenauigkeitVonJahrhundert` int DEFAULT '-1',
  `DatierungUngewiss` tinyint unsigned DEFAULT NULL,
  `KommentarDatierung` varchar(255) DEFAULT NULL,
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `GenauigkeitBisTag` int DEFAULT '-1',
  `GenauigkeitBisMonat` int DEFAULT '-1',
  `GenauigkeitBisJahr` int DEFAULT '-1',
  `GenauigkeitBisJahrhundert` int DEFAULT '-1',
  `GenauigkeitQuelleBisTag` int DEFAULT '-1',
  `GenauigkeitQuelleBisMonat` int DEFAULT '-1',
  `GenauigkeitQuelleBisJahr` int DEFAULT '-1',
  `GenauigkeitQuelleBisJahrhundert` int DEFAULT '-1',
  `GenauigkeitQuelleVonTag` int DEFAULT '-1',
  `GenauigkeitQuelleVonMonat` int DEFAULT '-1',
  `GenauigkeitQuelleVonJahr` int DEFAULT '-1',
  `GenauigkeitQuelleVonJahrhundert` int DEFAULT '-1',
  `QuelleBisTag` int DEFAULT NULL,
  `QuelleBisMonat` int DEFAULT NULL,
  `QuelleBisJahr` int DEFAULT NULL,
  `QuelleBisJahrhundert` varchar(5) DEFAULT NULL,
  `QuelleVonTag` int DEFAULT NULL,
  `QuelleVonMonat` int DEFAULT NULL,
  `QuelleVonJahr` int DEFAULT NULL,
  `QuelleVonJahrhundert` varchar(5) DEFAULT NULL,
  `KommentarPerson` text,
  `MGHLemmaKorrigiert` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`),
  KEY `GeschlechtID` (`GeschlechtID`),
  KEY `LebendVerstorbenID` (`LebendVerstorbenID`),
  KEY `QuelleID` (`QuelleID`),
  KEY `QuelleGattungID` (`QuelleGattungID`),
  KEY `QuelleEchtheitID` (`QuelleEchtheitID`),
  KEY `KasusID` (`KasusID`),
  KEY `HandschriftID` (`HandschriftID`),
  KEY `GrammatikGeschlechtID` (`GrammatikGeschlechtID`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `Belegform` (`Belegform`)
) ENGINE=MyISAM AUTO_INCREMENT=106144 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatamtweihe`
--

DROP TABLE IF EXISTS `einzelbeleg_hatamtweihe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatamtweihe` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `AmtWeiheID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `AmtWeiheID` (`AmtWeiheID`)
) ENGINE=MyISAM AUTO_INCREMENT=30155 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatareal`
--

DROP TABLE IF EXISTS `einzelbeleg_hatareal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatareal` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `ArealID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `ArealID` (`ArealID`)
) ENGINE=MyISAM AUTO_INCREMENT=17377 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatethnie`
--

DROP TABLE IF EXISTS `einzelbeleg_hatethnie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatethnie` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `EthnieID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `EthnieID` (`EthnieID`)
) ENGINE=MyISAM AUTO_INCREMENT=365 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatfunktion`
--

DROP TABLE IF EXISTS `einzelbeleg_hatfunktion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatfunktion` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `FunktionID` int DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `FunktionID` (`FunktionID`)
) ENGINE=MyISAM AUTO_INCREMENT=48545 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatmghlemma`
--

DROP TABLE IF EXISTS `einzelbeleg_hatmghlemma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatmghlemma` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL,
  `MGHLemmaID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `MGHLemmaID` (`MGHLemmaID`)
) ENGINE=InnoDB AUTO_INCREMENT=130614 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatnamenkommentar`
--

DROP TABLE IF EXISTS `einzelbeleg_hatnamenkommentar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatnamenkommentar` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=61890 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatperson`
--

DROP TABLE IF EXISTS `einzelbeleg_hatperson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatperson` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '0',
  `PersonID` int NOT NULL DEFAULT '0',
  `gesichert` tinyint DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `PersonID` (`PersonID`)
) ENGINE=MyISAM AUTO_INCREMENT=61090 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_hatstand`
--

DROP TABLE IF EXISTS `einzelbeleg_hatstand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_hatstand` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int unsigned NOT NULL,
  `StandID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `StandID` (`StandID`)
) ENGINE=MyISAM AUTO_INCREMENT=10190 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `einzelbeleg_textkritik`
--

DROP TABLE IF EXISTS `einzelbeleg_textkritik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `einzelbeleg_textkritik` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EinzelbelegID` int NOT NULL DEFAULT '-1',
  `EditionID` int NOT NULL DEFAULT '-1',
  `HandschriftID` int NOT NULL DEFAULT '-1',
  `Variante` varchar(255) DEFAULT NULL,
  `Bemerkung` longtext,
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`),
  KEY `EinzelbelegID` (`EinzelbelegID`),
  KEY `HandschriftID` (`HandschriftID`)
) ENGINE=MyISAM AUTO_INCREMENT=72712 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `gastnamenkommentar`
--

DROP TABLE IF EXISTS `gastnamenkommentar`;
/*!50001 DROP VIEW IF EXISTS `gastnamenkommentar`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastnamenkommentar` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastnamenkommentar_zweitglied`
--

DROP TABLE IF EXISTS `gastnamenkommentar_zweitglied`;
/*!50001 DROP VIEW IF EXISTS `gastnamenkommentar_zweitglied`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastnamenkommentar_zweitglied` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`,
 1 AS `zweitglied`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastquelle`
--

DROP TABLE IF EXISTS `gastquelle`;
/*!50001 DROP VIEW IF EXISTS `gastquelle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastquelle` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastselektion_amtweihe_einzelbeleg`
--

DROP TABLE IF EXISTS `gastselektion_amtweihe_einzelbeleg`;
/*!50001 DROP VIEW IF EXISTS `gastselektion_amtweihe_einzelbeleg`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastselektion_amtweihe_einzelbeleg` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastselektion_amtweihe_person`
--

DROP TABLE IF EXISTS `gastselektion_amtweihe_person`;
/*!50001 DROP VIEW IF EXISTS `gastselektion_amtweihe_person`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastselektion_amtweihe_person` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastselektion_ethnie_einzelbeleg`
--

DROP TABLE IF EXISTS `gastselektion_ethnie_einzelbeleg`;
/*!50001 DROP VIEW IF EXISTS `gastselektion_ethnie_einzelbeleg`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastselektion_ethnie_einzelbeleg` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastselektion_ethnie_person`
--

DROP TABLE IF EXISTS `gastselektion_ethnie_person`;
/*!50001 DROP VIEW IF EXISTS `gastselektion_ethnie_person`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastselektion_ethnie_person` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gastselektion_stand`
--

DROP TABLE IF EXISTS `gastselektion_stand`;
/*!50001 DROP VIEW IF EXISTS `gastselektion_stand`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gastselektion_stand` AS SELECT
 1 AS `ID`,
 1 AS `Bezeichnung`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `handschrift`
--

DROP TABLE IF EXISTS `handschrift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `handschrift` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bibliothekssignatur` varchar(255) COLLATE latin1_german1_ci NOT NULL DEFAULT '',
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`)
) ENGINE=MyISAM AUTO_INCREMENT=3386 DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `handschrift_ueberlieferung`
--

DROP TABLE IF EXISTS `handschrift_ueberlieferung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `handschrift_ueberlieferung` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `QuelleID` int NOT NULL DEFAULT '-1',
  `Sigle` varchar(255) DEFAULT NULL,
  `Bibliothekssignatur` varchar(255) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `VonTag` int DEFAULT NULL,
  `VonMonat` int DEFAULT NULL,
  `VonJahr` int DEFAULT NULL,
  `VonJahrhundert` varchar(5) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `BisTag` int DEFAULT NULL,
  `BisMonat` int DEFAULT NULL,
  `BisJahr` int DEFAULT NULL,
  `BisJahrhundert` varchar(5) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `GenauigkeitVonTag` int DEFAULT '-1',
  `GenauigkeitVonMonat` int DEFAULT '-1',
  `GenauigkeitVonJahr` int DEFAULT '-1',
  `GenauigkeitVonJahrhundert` int DEFAULT '-1',
  `Schriftheimat` int NOT NULL DEFAULT '-1',
  `UeberlieferungDatierung` varchar(255) CHARACTER SET latin1 COLLATE latin1_german1_ci DEFAULT NULL,
  `BearbeitungsstatusID` int NOT NULL DEFAULT '0',
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `HandschriftID` int DEFAULT NULL,
  `Bibliotheksheimat` int NOT NULL DEFAULT '-1',
  `GenauigkeitBisTag` int DEFAULT '-1',
  `GenauigkeitBisMonat` int DEFAULT '-1',
  `GenauigkeitBisJahr` int DEFAULT '-1',
  `GenauigkeitBisJahrhundert` int DEFAULT '-1',
  `EditionID` int NOT NULL DEFAULT '-1',
  PRIMARY KEY (`ID`),
  KEY `QuelleID` (`QuelleID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`),
  KEY `HandschriftID` (`HandschriftID`),
  KEY `EditionID` (`EditionID`)
) ENGINE=MyISAM AUTO_INCREMENT=7506 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur`
--

DROP TABLE IF EXISTS `literatur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Titel` varchar(255) NOT NULL DEFAULT '',
  `Titel2` varchar(255) DEFAULT NULL,
  `LiteraturTypID` int NOT NULL DEFAULT '0',
  `Auflage` varchar(255) DEFAULT NULL,
  `Ort` varchar(255) DEFAULT NULL,
  `Jahr` varchar(255) DEFAULT NULL,
  `Seite` varchar(255) DEFAULT NULL,
  `Reihe` varchar(255) DEFAULT NULL,
  `BearbeitungsstatusID` int DEFAULT NULL,
  `Kurzzitierweise` varchar(255) DEFAULT NULL,
  `PhilologischRelevant` tinyint(1) DEFAULT NULL,
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `inLitID` int unsigned DEFAULT NULL,
  `inBand` varchar(45) DEFAULT NULL,
  `Umfang` varchar(45) DEFAULT NULL,
  `AutorJahr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`)
) ENGINE=MyISAM AUTO_INCREMENT=1808 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_autor`
--

DROP TABLE IF EXISTS `literatur_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_autor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Nachname` varchar(255) DEFAULT NULL,
  `Vorname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=1190 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_herausgeber`
--

DROP TABLE IF EXISTS `literatur_herausgeber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_herausgeber` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Nachname` varchar(255) DEFAULT NULL,
  `Vorname` varchar(255) DEFAULT NULL,
  `Verbindungstext` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_sw_arealgens`
--

DROP TABLE IF EXISTS `literatur_sw_arealgens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_sw_arealgens` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=914 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_sw_morphologie`
--

DROP TABLE IF EXISTS `literatur_sw_morphologie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_sw_morphologie` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=382 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_sw_namenelemente`
--

DROP TABLE IF EXISTS `literatur_sw_namenelemente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_sw_namenelemente` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=3698 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `literatur_sw_phongraph`
--

DROP TABLE IF EXISTS `literatur_sw_phongraph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literatur_sw_phongraph` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `LiteraturID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `LiteraturID` (`LiteraturID`)
) ENGINE=MyISAM AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mgh_lemma`
--

DROP TABLE IF EXISTS `mgh_lemma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mgh_lemma` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MGHLemma` varchar(255) DEFAULT NULL,
  `BearbeitungsstatusID` int NOT NULL,
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_mgh_lemma_MGHLemma` (`MGHLemma`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`)
) ENGINE=InnoDB AUTO_INCREMENT=16511 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mgh_lemma_bearbeiter`
--

DROP TABLE IF EXISTS `mgh_lemma_bearbeiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mgh_lemma_bearbeiter` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MGHLemmaID` int NOT NULL DEFAULT '0',
  `BenutzerID` int NOT NULL DEFAULT '0',
  `Zeitstempel` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `MGHLemmaID` (`MGHLemmaID`),
  KEY `BenutzerID` (`BenutzerID`)
) ENGINE=MyISAM AUTO_INCREMENT=6136 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mgh_lemma_korrektor`
--

DROP TABLE IF EXISTS `mgh_lemma_korrektor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mgh_lemma_korrektor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `MGHLemmaID` int NOT NULL DEFAULT '0',
  `BenutzerID` int NOT NULL DEFAULT '0',
  `Zeitstempel` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `MGHLemmaID` (`MGHLemmaID`),
  KEY `BenutzerID` (`BenutzerID`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `namenkommentar`
--

DROP TABLE IF EXISTS `namenkommentar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `namenkommentar` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ELemma` varchar(255) DEFAULT NULL,
  `PLemma` varchar(255) DEFAULT NULL,
  `Suffix` varchar(255) DEFAULT NULL,
  `Hinweise` longtext,
  `Protokoll` longtext,
  `Dateiname` varchar(255) DEFAULT NULL,
  `BearbeitungsstatusID` int NOT NULL DEFAULT '0',
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `Rekonstruktion` int unsigned DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`)
) ENGINE=MyISAM AUTO_INCREMENT=6362 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `namenkommentar_bearbeiter`
--

DROP TABLE IF EXISTS `namenkommentar_bearbeiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `namenkommentar_bearbeiter` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `BenutzerID` int NOT NULL DEFAULT '0',
  `Zeitstempel` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`),
  KEY `BenutzerID` (`BenutzerID`)
) ENGINE=MyISAM AUTO_INCREMENT=6135 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `namenkommentar_korrektor`
--

DROP TABLE IF EXISTS `namenkommentar_korrektor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `namenkommentar_korrektor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `BenutzerID` int NOT NULL DEFAULT '0',
  `Zeitstempel` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`),
  KEY `BenutzerID` (`BenutzerID`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `ID` int NOT NULL DEFAULT '0',
  `PKZ` varchar(10) NOT NULL DEFAULT '0',
  `Standardname` varchar(255) DEFAULT NULL,
  `Geschlecht` int DEFAULT '-1',
  `Fiktiv` int DEFAULT '-1',
  `BearbeitungsstatusID` int DEFAULT '-1',
  `KommentarEthnie` longtext,
  `KommentarAreal` longtext,
  `PersonenkommentarDatei` varchar(255) DEFAULT NULL,
  `Identifizierungsproblem` longtext,
  `Ort` varchar(255) DEFAULT NULL,
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `CMRef` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`),
  KEY `Geschlecht` (`Geschlecht`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_hatamtstandweihe`
--

DROP TABLE IF EXISTS `person_hatamtstandweihe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_hatamtstandweihe` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonID` int NOT NULL DEFAULT '0',
  `AmtWeiheID` int NOT NULL DEFAULT '0',
  `Zeitraum` varchar(255) DEFAULT NULL,
  `Identifizierung` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`),
  KEY `AmtWeiheID` (`AmtWeiheID`)
) ENGINE=MyISAM AUTO_INCREMENT=7368 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_hatareal`
--

DROP TABLE IF EXISTS `person_hatareal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_hatareal` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonID` int NOT NULL DEFAULT '0',
  `ArealID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`),
  KEY `ArealID` (`ArealID`)
) ENGINE=MyISAM AUTO_INCREMENT=19207 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_hatethnie`
--

DROP TABLE IF EXISTS `person_hatethnie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_hatethnie` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonID` int NOT NULL DEFAULT '0',
  `EthnieID` int NOT NULL DEFAULT '0',
  `EthnienerhaltID` int NOT NULL DEFAULT '-1',
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`),
  KEY `EthnieID` (`EthnieID`),
  KEY `EthnienerhaltID` (`EthnienerhaltID`)
) ENGINE=MyISAM AUTO_INCREMENT=15210 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_hatstand`
--

DROP TABLE IF EXISTS `person_hatstand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_hatstand` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonID` int NOT NULL DEFAULT '0',
  `StandID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`),
  KEY `StandID` (`StandID`)
) ENGINE=MyISAM AUTO_INCREMENT=21142 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_quiet`
--

DROP TABLE IF EXISTS `person_quiet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_quiet` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonID` int NOT NULL DEFAULT '0',
  `QuiEt` varchar(255) DEFAULT NULL,
  `Zusatz` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PersonID` (`PersonID`)
) ENGINE=MyISAM AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_variante`
--

DROP TABLE IF EXISTS `person_variante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_variante` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `personID` int unsigned NOT NULL,
  `Variante` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `personID` (`personID`)
) ENGINE=InnoDB AUTO_INCREMENT=578 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_verwandtmit`
--

DROP TABLE IF EXISTS `person_verwandtmit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_verwandtmit` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PersonIDvon` int NOT NULL DEFAULT '0',
  `PersonIDzu` int NOT NULL DEFAULT '0',
  `VerwandtschaftsgradID` int NOT NULL DEFAULT '-1',
  PRIMARY KEY (`ID`),
  KEY `PersonIDvon` (`PersonIDvon`),
  KEY `PersonIDzu` (`PersonIDzu`),
  KEY `VerwandtschaftsgradID` (`VerwandtschaftsgradID`)
) ENGINE=MyISAM AUTO_INCREMENT=34343 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quelle`
--

DROP TABLE IF EXISTS `quelle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quelle` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  `Quellennummer` varchar(255) DEFAULT NULL,
  `QuellenKommentarDatei` varchar(255) DEFAULT NULL,
  `UeberlieferungsKommentarDatei` varchar(255) DEFAULT NULL,
  `BearbeitungsstatusID` int DEFAULT '0',
  `VonTag` int DEFAULT NULL,
  `VonMonat` int DEFAULT NULL,
  `VonJahr` int DEFAULT NULL,
  `VonJahrhundert` varchar(5) DEFAULT NULL,
  `BisTag` int DEFAULT NULL,
  `BisMonat` int DEFAULT NULL,
  `BisJahr` int DEFAULT NULL,
  `BisJahrhundert` varchar(5) DEFAULT NULL,
  `GenauigkeitVonTag` int DEFAULT '-1',
  `GenauigkeitVonMonat` int DEFAULT '-1',
  `GenauigkeitVonJahr` int DEFAULT '-1',
  `GenauigkeitVonJahrhundert` int DEFAULT '-1',
  `DatierungUngewiss` tinyint(1) DEFAULT NULL,
  `KommentarDatierung` varchar(255) DEFAULT NULL,
  `LetzteAenderung` datetime DEFAULT NULL,
  `LetzteAenderungVon` int DEFAULT NULL,
  `Erstellt` datetime DEFAULT NULL,
  `ErstelltVon` int DEFAULT NULL,
  `GehoertGruppe` int DEFAULT NULL,
  `GenauigkeitBisTag` int DEFAULT '-1',
  `GenauigkeitBisMonat` int DEFAULT '-1',
  `GenauigkeitBisJahr` int DEFAULT '-1',
  `GenauigkeitBisJahrhundert` int DEFAULT '-1',
  `ZuVeroeffentlichen` int unsigned NOT NULL DEFAULT '0',
  `CMRef` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LetzteAenderungVon` (`LetzteAenderungVon`),
  KEY `ErstelltVon` (`ErstelltVon`),
  KEY `GehoertGruppe` (`GehoertGruppe`),
  KEY `BearbeitungsstatusID` (`BearbeitungsstatusID`),
  KEY `zuVeroeffentlichen` (`ZuVeroeffentlichen`)
) ENGINE=MyISAM AUTO_INCREMENT=94819 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quelle_inedition`
--

DROP TABLE IF EXISTS `quelle_inedition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quelle_inedition` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `QuelleID` int NOT NULL DEFAULT '0',
  `EditionID` int NOT NULL DEFAULT '0',
  `Standard` int NOT NULL DEFAULT '0',
  `Seiten` varchar(45) DEFAULT NULL,
  `Nummer` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`),
  KEY `QuelleID` (`QuelleID`)
) ENGINE=MyISAM AUTO_INCREMENT=3158 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_arealgens`
--

DROP TABLE IF EXISTS `schlagwort_arealgens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_arealgens` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_morphologie`
--

DROP TABLE IF EXISTS `schlagwort_morphologie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_morphologie` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=995 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_motivation`
--

DROP TABLE IF EXISTS `schlagwort_motivation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_motivation` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_namenlexikon`
--

DROP TABLE IF EXISTS `schlagwort_namenlexikon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_namenlexikon` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_phongraph`
--

DROP TABLE IF EXISTS `schlagwort_phongraph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_phongraph` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schlagwort_sprachherkunft`
--

DROP TABLE IF EXISTS `schlagwort_sprachherkunft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schlagwort_sprachherkunft` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NamenkommentarID` int NOT NULL DEFAULT '0',
  `Schlagwort` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `NamenkommentarID` (`NamenkommentarID`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_amtstandweihe`
--

DROP TABLE IF EXISTS `selektion_amtstandweihe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_amtstandweihe` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_amtweihe`
--

DROP TABLE IF EXISTS `selektion_amtweihe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_amtweihe` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=1089 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_areal`
--

DROP TABLE IF EXISTS `selektion_areal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_areal` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_autor`
--

DROP TABLE IF EXISTS `selektion_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_autor` (
  `ID` int NOT NULL DEFAULT '0',
  `Nachname` varchar(50) NOT NULL DEFAULT '',
  `Vorname` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_bearbeitungsstatus`
--

DROP TABLE IF EXISTS `selektion_bearbeitungsstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_bearbeitungsstatus` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_bewertung`
--

DROP TABLE IF EXISTS `selektion_bewertung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_bewertung` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_bkz`
--

DROP TABLE IF EXISTS `selektion_bkz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_bkz` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_datgenauigkeit`
--

DROP TABLE IF EXISTS `selektion_datgenauigkeit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_datgenauigkeit` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_dmghband`
--

DROP TABLE IF EXISTS `selektion_dmghband`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_dmghband` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_echtheit`
--

DROP TABLE IF EXISTS `selektion_echtheit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_echtheit` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_editor`
--

DROP TABLE IF EXISTS `selektion_editor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_editor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nachname` varchar(50) DEFAULT NULL,
  `Vorname` varchar(50) DEFAULT NULL,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_ethnie`
--

DROP TABLE IF EXISTS `selektion_ethnie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_ethnie` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_ethnienerhalt`
--

DROP TABLE IF EXISTS `selektion_ethnienerhalt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_ethnienerhalt` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_funktion`
--

DROP TABLE IF EXISTS `selektion_funktion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_funktion` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_geschlecht`
--

DROP TABLE IF EXISTS `selektion_geschlecht`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_geschlecht` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_grammatikgeschlecht`
--

DROP TABLE IF EXISTS `selektion_grammatikgeschlecht`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_grammatikgeschlecht` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_janein`
--

DROP TABLE IF EXISTS `selektion_janein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_janein` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_kasus`
--

DROP TABLE IF EXISTS `selektion_kasus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_kasus` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_lebendverstorben`
--

DROP TABLE IF EXISTS `selektion_lebendverstorben`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_lebendverstorben` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_literaturtyp`
--

DROP TABLE IF EXISTS `selektion_literaturtyp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_literaturtyp` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_ort`
--

DROP TABLE IF EXISTS `selektion_ort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_ort` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_quellengattung`
--

DROP TABLE IF EXISTS `selektion_quellengattung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_quellengattung` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_reihe`
--

DROP TABLE IF EXISTS `selektion_reihe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_reihe` (
  `ID` int NOT NULL,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sammelband`
--

DROP TABLE IF EXISTS `selektion_sammelband`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sammelband` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_stand`
--

DROP TABLE IF EXISTS `selektion_stand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_stand` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_arealgens`
--

DROP TABLE IF EXISTS `selektion_sw_arealgens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_arealgens` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2451 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_morphologie`
--

DROP TABLE IF EXISTS `selektion_sw_morphologie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_morphologie` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=1427 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_motivation`
--

DROP TABLE IF EXISTS `selektion_sw_motivation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_motivation` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_namenelemente`
--

DROP TABLE IF EXISTS `selektion_sw_namenelemente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_namenelemente` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=14329 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_namenlexikon`
--

DROP TABLE IF EXISTS `selektion_sw_namenlexikon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_namenlexikon` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_phongraph`
--

DROP TABLE IF EXISTS `selektion_sw_phongraph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_phongraph` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=1256 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_sw_sprachherkunft`
--

DROP TABLE IF EXISTS `selektion_sw_sprachherkunft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_sw_sprachherkunft` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_urkundeausstellerempfaenger`
--

DROP TABLE IF EXISTS `selektion_urkundeausstellerempfaenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_urkundeausstellerempfaenger` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `selektion_verwandtschaftsgrad`
--

DROP TABLE IF EXISTS `selektion_verwandtschaftsgrad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selektion_verwandtschaftsgrad` (
  `ID` int NOT NULL DEFAULT '0',
  `Bezeichnung` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suche_favoriten`
--

DROP TABLE IF EXISTS `suche_favoriten`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suche_favoriten` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(255) CHARACTER SET latin1 NOT NULL,
  `SQL` text CHARACTER SET latin1 NOT NULL,
  `de_Ueberschriften` varchar(255) COLLATE latin1_german1_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ueberlieferung_edition`
--

DROP TABLE IF EXISTS `ueberlieferung_edition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ueberlieferung_edition` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UeberlieferungID` int NOT NULL DEFAULT '-1',
  `EditionID` int NOT NULL DEFAULT '-1',
  `Sigle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `EditionID` (`EditionID`),
  KEY `UeberlieferungID` (`UeberlieferungID`)
) ENGINE=MyISAM AUTO_INCREMENT=6638 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urkunde`
--

DROP TABLE IF EXISTS `urkunde`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `urkunde` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `QuelleID` int NOT NULL DEFAULT '0',
  `Actumort` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `QuelleID` (`QuelleID`)
) ENGINE=MyISAM AUTO_INCREMENT=2682 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urkunde_betreff`
--

DROP TABLE IF EXISTS `urkunde_betreff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `urkunde_betreff` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UrkundeID` int NOT NULL DEFAULT '0',
  `Betreff` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `UrkundeID` (`UrkundeID`)
) ENGINE=MyISAM AUTO_INCREMENT=1848 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urkunde_dorsalnotiz`
--

DROP TABLE IF EXISTS `urkunde_dorsalnotiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `urkunde_dorsalnotiz` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UrkundeID` int NOT NULL DEFAULT '0',
  `Dorsalnotiz` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `UrkundeID` (`UrkundeID`)
) ENGINE=MyISAM AUTO_INCREMENT=926 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urkunde_hataussteller`
--

DROP TABLE IF EXISTS `urkunde_hataussteller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `urkunde_hataussteller` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UrkundeID` int NOT NULL DEFAULT '0',
  `AusstellerID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `UrkundeID` (`UrkundeID`),
  KEY `AusstellerID` (`AusstellerID`)
) ENGINE=MyISAM AUTO_INCREMENT=1812 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urkunde_hatempfaenger`
--

DROP TABLE IF EXISTS `urkunde_hatempfaenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `urkunde_hatempfaenger` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UrkundeID` int NOT NULL DEFAULT '0',
  `EmpfaengerID` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `UrkundeID` (`UrkundeID`),
  KEY `EmpfaengerID` (`EmpfaengerID`)
) ENGINE=MyISAM AUTO_INCREMENT=1676 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `gastnamenkommentar`
--

/*!50001 DROP VIEW IF EXISTS `gastnamenkommentar`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastnamenkommentar` AS select `namenkommentar`.`ID` AS `ID`,`namenkommentar`.`PLemma` AS `Bezeichnung` from `namenkommentar` where `namenkommentar`.`ID` in (select `n`.`ID` AS `ID` from (((`einzelbeleg` `e` join `quelle` `q`) join `einzelbeleg_hatnamenkommentar` `h`) join `namenkommentar` `n`) where ((`e`.`ID` = `h`.`EinzelbelegID`) and (`n`.`ID` = `h`.`NamenkommentarID`) and (`e`.`QuelleID` = `q`.`ID`) and (`q`.`ZuVeroeffentlichen` = 1))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastnamenkommentar_zweitglied`
--

/*!50001 DROP VIEW IF EXISTS `gastnamenkommentar_zweitglied`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastnamenkommentar_zweitglied` AS select `namenkommentar`.`ID` AS `ID`,`namenkommentar`.`PLemma` AS `Bezeichnung`,substring_index(`namenkommentar`.`PLemma`,'~',-(1)) AS `zweitglied` from `namenkommentar` where (`namenkommentar`.`ID` in (select `n`.`ID` AS `ID` from (((`einzelbeleg` `e` join `quelle` `q`) join `einzelbeleg_hatnamenkommentar` `h`) join `namenkommentar` `n`) where ((`e`.`ID` = `h`.`EinzelbelegID`) and (`n`.`ID` = `h`.`NamenkommentarID`) and (`e`.`QuelleID` = `q`.`ID`) and (`q`.`ZuVeroeffentlichen` = 1))) and (`namenkommentar`.`PLemma` like '%~%')) union select '-1' AS `-1`,'-' AS `-`,'-' AS `-` order by `zweitglied`,`Bezeichnung` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastquelle`
--

/*!50001 DROP VIEW IF EXISTS `gastquelle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastquelle` AS select `quelle`.`ID` AS `ID`,`quelle`.`Bezeichnung` AS `Bezeichnung` from `quelle` where (`quelle`.`ZuVeroeffentlichen` = 1) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastselektion_amtweihe_einzelbeleg`
--

/*!50001 DROP VIEW IF EXISTS `gastselektion_amtweihe_einzelbeleg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastselektion_amtweihe_einzelbeleg` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung` from (`selektion_amtweihe` `s` join `einzelbeleg_hatamtweihe` `phs`) where ((`phs`.`AmtWeiheID` = `s`.`ID`) and `phs`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1)))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastselektion_amtweihe_person`
--

/*!50001 DROP VIEW IF EXISTS `gastselektion_amtweihe_person`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastselektion_amtweihe_person` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung` from (`selektion_amtweihe` `s` join `person_hatamtstandweihe` `phs`) where ((`phs`.`AmtWeiheID` = `s`.`ID`) and `phs`.`PersonID` in (select `einzelbeleg_hatperson`.`PersonID` AS `PersonID` from `einzelbeleg_hatperson` where `einzelbeleg_hatperson`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1))))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastselektion_ethnie_einzelbeleg`
--

/*!50001 DROP VIEW IF EXISTS `gastselektion_ethnie_einzelbeleg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastselektion_ethnie_einzelbeleg` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung` from (`selektion_ethnie` `s` join `einzelbeleg_hatethnie` `phs`) where ((`phs`.`EthnieID` = `s`.`ID`) and `phs`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1)))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastselektion_ethnie_person`
--

/*!50001 DROP VIEW IF EXISTS `gastselektion_ethnie_person`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastselektion_ethnie_person` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung` from (`selektion_ethnie` `s` join `person_hatethnie` `phs`) where ((`phs`.`EthnieID` = `s`.`ID`) and `phs`.`PersonID` in (select `einzelbeleg_hatperson`.`PersonID` AS `PersonID` from `einzelbeleg_hatperson` where `einzelbeleg_hatperson`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1))))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gastselektion_stand`
--

/*!50001 DROP VIEW IF EXISTS `gastselektion_stand`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gastselektion_stand` AS select distinct `s`.`ID` AS `ID`,`s`.`Bezeichnung` AS `Bezeichnung` from (`selektion_stand` `s` join `person_hatstand` `phs`) where ((`phs`.`StandID` = `s`.`ID`) and `phs`.`PersonID` in (select `einzelbeleg_hatperson`.`PersonID` AS `PersonID` from `einzelbeleg_hatperson` where `einzelbeleg_hatperson`.`EinzelbelegID` in (select `einzelbeleg`.`ID` AS `ID` from (`einzelbeleg` join `quelle`) where ((`einzelbeleg`.`QuelleID` = `quelle`.`ID`) and (`quelle`.`ZuVeroeffentlichen` = 1))))) union select '-1' AS `-1`,'-' AS `-` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-05 15:58:03
