<%@ page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@ page import="java.util.ArrayList" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>
<%@ page import="java.math.BigInteger" isThreadSafe="false" %>

<%@ page import="com.lowagie.text.Document" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.rtf.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.rtf.list.*" isThreadSafe="false" %>
<%@ page import="org.apache.commons.lang3.StringUtils" isThreadSafe="false" %>
<%@ page import="java.io.*" isThreadSafe="false" %>
<%@ page import="java.awt.Color" isThreadSafe="false" %>


<%

  int limit=0;
  int offset = 5;
  try {
    limit = Integer.parseInt(request.getParameter("limit"));
  }
  catch (Exception ex) { }

  String formular = request.getParameter("form");
  String tableString = "";

  List<String> conditions = new ArrayList<>();

  List<String> fields = new ArrayList<>();
  List<String> fieldNames = new ArrayList<>();
  List<String> count = new ArrayList<>();

  List<String> tables = new ArrayList<>();
  List<String> joins = new ArrayList<>();

  List<String> headlines = new ArrayList<>();

  // Welche Grund-Tabellen (Einzelbeleg / Person / Namenkommentar) werden benötigt...
  boolean einzelbeleg = false;
  boolean person = false;
  boolean namenkommentar = false;
  boolean mghlemma = false;
  boolean edition = false;


//     for (int i=1; i<15; i++) {
// 	if(request.getParameter("order"+i)!=null){
//  	     if (request.getParameter("order"+i).equals("OrderNamen") && request.getParameter("Namenlemma").trim().equals("") && (request.getParameter("Ausgabe_Namenlemma") == null || !request.getParameter("Ausgabe_Namenlemma").equals("on")) && request.getParameter("MGHLemma").trim().equals("") && (request.getParameter("Ausgabe_MGHLemma") == null || !request.getParameter("Ausgabe_MGHLemma").equals("on"))){
//  		   out.println("<div>Bitte wählen Sie unter 'Ausgabe', nach welchen Lemmata gruppiert werden soll (Namenlemma / MGH-Lemma).</div>");
//  		   return;
//  	     }
//  	  }
// }

  // ######### SUCHANFRAGE ##########
  // ### ZUM NAMEN ###
  if (!request.getParameter("Namenlemma").trim().equals("")) {
    conditions.add("namenkommentar.PLemma LIKE '"+request.getParameter("Namenlemma").trim()+"'");
    namenkommentar = true;
  }
  if (!request.getParameter("Erstglied").trim().equals("")) {
    conditions.add("namenkommentar.PLemma LIKE '"+request.getParameter("Erstglied").trim()+"~%'");
    namenkommentar = true;
  }
  if (!request.getParameter("Zweitglied").trim().equals("")) {
    conditions.add("namenkommentar.PLemma LIKE '%~"+request.getParameter("Zweitglied").trim()+"'");
    namenkommentar = true;
  }
  if (!request.getParameter("MGHLemma").trim().equals("")) {
	    conditions.add("mgh_lemma.MGHLemma LIKE '"+request.getParameter("MGHLemma").trim()+"'");
	    mghlemma = true;
	  }
  // ### ZUR PERSON ###

  if (!request.getParameter("Personenname").trim().equals("")) {
    conditions.add("(person.Standardname LIKE '"+request.getParameter("Personenname").trim()+"' OR person_variante.Variante LIKE '"+request.getParameter("Personenname").trim()+"')");
    tableString += " LEFT OUTER JOIN person_variante ON person.ID=person_variante.personID";
    person = true;
  }
  if (Integer.parseInt(request.getParameter("Geschlecht")) > -1) {
    conditions.add("person.Geschlecht = '"+request.getParameter("Geschlecht")+"'");
    person = true;
  }
  else if (Integer.parseInt(request.getParameter("Geschlecht")) == -2) {
    conditions.add("(person.Geschlecht is null or person.Geschlecht=-1)");
    person = true;
  }
  if (Integer.parseInt(request.getParameter("AmtWeihePerson")) > -1) {
    tableString += " INNER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
    List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("AmtWeihePerson")), SelektionAmtWeihe.class).getSubtreeIdsRecursive();
    conditions.add("person_hatamtstandweihe.AmtWeiheID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
    person = true;
  }
  else if (Integer.parseInt(request.getParameter("AmtWeihePerson")) == -2) {
    conditions.add("NOT EXISTS (SELECT * from person_hatamtstandweihe where person.ID=person_hatamtstandweihe.PersonID)");
    person = true;
  }
  if (Integer.parseInt(request.getParameter("StandPerson")) > -1) {
    tableString += " INNER JOIN person_hatstand ON person.ID=person_hatstand.PersonID";
    List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("StandPerson")), SelektionStand.class).getSubtreeIdsRecursive();
    conditions.add("person_hatstand.StandID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
    person = true;
  }
 else if (Integer.parseInt(request.getParameter("StandPerson")) == -2) {
    conditions.add("NOT EXISTS (SELECT * from person_hatstand where person.ID=person_hatstand.PersonID)");
    person = true;
  }
  if (Integer.parseInt(request.getParameter("Verwandtschaftsgrad")) > -1) {
    tableString += " INNER JOIN person_verwandtmit ON person.ID=person_verwandtmit.PersonIDvon";
    conditions.add("person_verwandtmit.VerwandtschaftsgradID = '"+request.getParameter("Verwandtschaftsgrad")+"'");
    person = true;
  }
 else if (Integer.parseInt(request.getParameter("Verwandtschaftsgrad")) == -2) {
    conditions.add("NOT EXISTS (SELECT * from person_verwandtmit where person.ID=person_verwandtmit.PersonIDvon)");
    person = true;
  }

  // ### ZUM EINZELBELEG ###
 if (!request.getParameter("Belegform").trim().equals("")) {
    conditions.add("einzelbeleg.Belegform LIKE '"+request.getParameter("Belegform").trim()+"'");
    einzelbeleg = true;
  }
   if (!request.getParameter("Kontext").trim().equals("")) {
    conditions.add("einzelbeleg.Kontext LIKE '"+request.getParameter("Kontext").trim()+"'");
    einzelbeleg = true;
  }
  if (Integer.parseInt(request.getParameter("AmtWeiheEinzelbeleg")) > -1) {
    tableString += " INNER JOIN einzelbeleg_hatamtweihe ON einzelbeleg.ID=einzelbeleg_hatamtweihe.EinzelbelegID";
    List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("AmtWeiheEinzelbeleg")), SelektionAmtWeihe.class).getSubtreeIdsRecursive();
    conditions.add("einzelbeleg_hatamtweihe.AmtWeiheID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
    einzelbeleg = true;
  }
  else if (Integer.parseInt(request.getParameter("AmtWeiheEinzelbeleg")) == -2) {
    conditions.add("NOT EXISTS (SELECT * from einzelbeleg_hatamtweihe where einzelbeleg.ID=einzelbeleg_hatamtweihe.EinzelbelegID)");
    einzelbeleg = true;
  }
  if (Integer.parseInt(request.getParameter("Funktion")) > -1) {
    tableString += " INNER JOIN einzelbeleg_hatfunktion ON einzelbeleg.ID=einzelbeleg_hatfunktion.EinzelbelegID";
    conditions.add("einzelbeleg_hatfunktion.FunktionID = '"+request.getParameter("Funktion")+"'");
    einzelbeleg = true;
  }
  else if (Integer.parseInt(request.getParameter("Funktion")) == -2) {
    conditions.add("NOT EXISTS (SELECT * from einzelbeleg_hatfunktion where einzelbeleg.ID=einzelbeleg_hatfunktion.EinzelbelegID)");
    einzelbeleg = true;
  }
  if (!request.getParameter("PersonZeitraum").trim().equals("")) {
       int vonNum = 0;
        int bisNum = 0;
     if (request.getParameter("PersonZeitraum").contains("-")) {
         // Zeitraum
         String von = request.getParameter("PersonZeitraum").substring(0, request.getParameter("PersonZeitraum").indexOf("-")).trim();
         String bis = request.getParameter("PersonZeitraum").substring(request.getParameter("PersonZeitraum").indexOf("-")+1).trim();
         if (von.toLowerCase().contains("jh")) {
        try {
        vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j")))-1) * 100;
        if(von.endsWith("2")) vonNum += 51;
        else vonNum += 1;
        }catch (NumberFormatException e) {;}
      }
      else if (von.toLowerCase().contains(".")) {

      }
      else {
        try {
          vonNum = Integer.parseInt(von);
        }
        catch (NumberFormatException e) {;}
      }

      if (bis.toLowerCase().contains("jh")) {
        try {
        bisNum = (Integer.parseInt(bis.substring(0, bis.toLowerCase().indexOf("j")))-1) * 100;
        if(bis.endsWith("1")) bisNum += 50;
        else bisNum += 100;
       } catch (NumberFormatException e) {;}
      }
      else if (bis.toLowerCase().contains(".")) {

      }
      else {

        try {
          bisNum = Integer.parseInt(bis);
        }
        catch (NumberFormatException e) {;}
      }
    }    else if (request.getParameter("PersonZeitraum").toLowerCase().contains("jh")) {

             String von = request.getParameter("PersonZeitraum").trim();
        try {
            vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j")))-1) * 100;
         bisNum = vonNum;
        if(von.endsWith("1")) bisNum += 50;
        else bisNum += 100;
        if(von.endsWith("2")) vonNum += 51;
        else vonNum += 1;
       } catch (NumberFormatException e) {;}

      // Einzelnes Jahrhundert
    }
    else if (request.getParameter("PersonZeitraum").toLowerCase().contains(".")) {
      // Einzelnes Datum
    }
    else {
      // Einzelne Jahreszahl
                   String von = request.getParameter("PersonZeitraum").trim();
         try {
            vonNum = Integer.parseInt(von);
            bisNum = vonNum;
                } catch (NumberFormatException e) {;}

    }

    conditions.add("(VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)<99999 and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)>-99999 and (VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)>="+vonNum+" and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)<="+bisNum+") OR"+
                                       "(VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)<="+vonNum+" and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)>="+bisNum+"))");
 einzelbeleg = true;
  }

  // ### ZUR QUELLE ###
  if (!request.getParameter("Quelle").trim().equals("")) {
    tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    conditions.add("quelle.Bezeichnung LIKE '"+request.getParameter("Quelle").trim()+"'");
    einzelbeleg = true;
  }
  if (Integer.parseInt(request.getParameter("Quellengattung")) > -1) {
    List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("Quellengattung")), SelektionQuellengattung.class).getSubtreeIdsRecursive();
    tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    conditions.add("quelle.QuelleGattungID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
    einzelbeleg = true;
  }
  else if (Integer.parseInt(request.getParameter("Quellengattung")) == -2) {
    tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    conditions.add("quelle.QuelleGattungID is null || quelle.QuelleGattungID=-1");
    einzelbeleg = true;
  }
    if (!request.getParameter("QuelleZeitraum").trim().equals("")) {
           int vonNum = 0;
        int bisNum = 0;
     if (request.getParameter("QuelleZeitraum").contains("-")) {
         // Zeitraum
         String von = request.getParameter("QuelleZeitraum").substring(0, request.getParameter("QuelleZeitraum").indexOf("-")).trim();
         String bis = request.getParameter("QuelleZeitraum").substring(request.getParameter("QuelleZeitraum").indexOf("-")+1).trim();
         if (von.toLowerCase().contains("jh")) {
        try {
        vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j")))-1) * 100;
        if(von.endsWith("2")) vonNum += 51;
        else vonNum += 1;
        }catch (NumberFormatException e) {;}
      }
      else if (von.toLowerCase().contains(".")) {

      }
      else {
        try {
          vonNum = Integer.parseInt(von);
        }
        catch (NumberFormatException e) {;}
      }

      if (bis.toLowerCase().contains("jh")) {
        try {
        bisNum = (Integer.parseInt(bis.substring(0, bis.toLowerCase().indexOf("j")))-1) * 100;
        if(bis.endsWith("1")) bisNum += 50;
        else bisNum += 100;
       } catch (NumberFormatException e) {;}
      }
      else if (bis.toLowerCase().contains(".")) {

      }
      else {

        try {
          bisNum = Integer.parseInt(bis);
        }
        catch (NumberFormatException e) {;}
      }
    }    else if (request.getParameter("QuelleZeitraum").toLowerCase().contains("jh")) {

             String von = request.getParameter("QuelleZeitraum").trim();
        try {
            vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j")))-1) * 100;
         bisNum = vonNum;
        if(von.endsWith("1")) bisNum += 50;
        else bisNum += 100;
        if(von.endsWith("2")) vonNum += 51;
        else vonNum += 1;
       } catch (NumberFormatException e) {;}

      // Einzelnes Jahrhundert
    }
    else if (request.getParameter("QuelleZeitraum").toLowerCase().contains(".")) {
      // Einzelnes Datum
    }
    else {
      // Einzelne Jahreszahl
                   String von = request.getParameter("QuelleZeitraum").trim();
         try {
            vonNum = Integer.parseInt(von);
            bisNum = vonNum;
                } catch (NumberFormatException e) {;}

    }

    conditions.add("(VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)<99999 and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)>-99999 and (VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)>="+vonNum+" and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)<="+bisNum+") OR"+
                                       "(VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)<="+vonNum+" and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)>="+bisNum+"))");
    einzelbeleg = true;
  }

    String provenanceEinzelbeleg = request.getParameter("ProvenanceEinzelbeleg");

    if (provenanceEinzelbeleg != null && Integer.parseInt(provenanceEinzelbeleg) > -1) {
        if (Integer.parseInt(provenanceEinzelbeleg) == 0) {
            conditions.add("einzelbeleg.provenance_source = 'NeG'");
        } else if(Integer.parseInt(provenanceEinzelbeleg) == 1) {
            conditions.add("einzelbeleg.provenance_source = 'DMP'");
        } else if(Integer.parseInt(provenanceEinzelbeleg) == 2) {
            conditions.add("einzelbeleg.provenance_source = 'NPPM'");
        }
        einzelbeleg = true;
    }

  // ######### SUCHANFRAGE ##########

    String sprache = Constants.DEFAULT_LANG;
  if (session != null && session.getAttribute("Sprache") != null)
    sprache = (String)session.getAttribute("Sprache");
  /*
   //NeG-ID
  if (!request.getParameter("NeGID").trim().equals("")) {
           String newID = request.getParameter("NeGID");
        String newForm = newID.substring(1);
        if(newID.startsWith("B") || newID.startsWith("b")){
               conditions.add("einzelbeleg.ID='"+newForm+"'");
    fields.add("einzelbeleg.Belegform");
    fields.add("einzelbeleg.ID");
    count.add("einzelbeleg.ID");
    fieldNames.add("einzelbeleg.Belegform");
    //headlines.add("Belegform");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Belegform"));
    			einzelbeleg = true;
        }
        else if(newID.startsWith("P") || newID.startsWith("p")) {
               conditions.add("person.ID='"+newForm+"'");
                   fields.add("person.Standardname");
    fields.add("person.ID");
    count.add("person.ID");
    fieldNames.add("person.Standardname");
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Standardname"));

    			person = true;
        }
        else if(newID.startsWith("N") || newID.startsWith("n")){
               conditions.add("namenkommentar.ID='"+newForm+"'");
    			namenkommentar = true;
    			    fields.add("namenkommentar.PLemma");
    fields.add("namenkommentar.ID");
    fieldNames.add("namenkommentar.PLemma");
    count.add("namenkommentar.ID");
   headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));

        }
        else if(newID.startsWith("Q") || newID.startsWith("q")) {
         conditions.add("quelle.ID='"+newForm+"'");
     fields.add("quelle.Bezeichnung");
    fields.add("quelle.ID");
    count.add("quelle.ID");
    fieldNames.add("quelle.Bezeichnung");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Quelle"));
         if (!tableString.contains("quelle")) { tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
          einzelbeleg=true;
        }}
         else if(newID.startsWith("E") || newID.startsWith("e")) {
         conditions.add("edition.ID='"+newForm+"'");
             fields.add("edition.Titel");
             fields.add("edition.ID");
             fieldNames.add("edition.Titel");

             headlines.add(DatenbankDB.getMapping(sprache, "quelle", "Edition"));

             edition=true;

        }
         else if(newID.startsWith("T") || newID.startsWith("t")) {
         conditions.add("handschrift.ID='"+newForm+"'");
                 fields.add("handschrift.Bibliothekssignatur");
                 fields.add("handschrift.ID");
    fieldNames.add("handschrift.Bibliothekssignatur");
    if (!tableString.contains("handschrift")) {
      tableString += " LEFT OUTER JOIN handschrift ON handschrift.ID = einzelbeleg.HandschriftID";
    }
     headlines.add("Textzeuge");

          einzelbeleg=true;

        }

  }
*/

  // ######### AUSGABEFELDER ##########
  // ### Zum Namen ###
  if (request.getParameter("Ausgabe_Namenlemma") != null && request.getParameter("Ausgabe_Namenlemma").equals("on")) {
    fields.add("namenkommentar.PLemma");
    fields.add("namenkommentar.ID");
    fieldNames.add("namenkommentar.PLemma");
    count.add("namenkommentar.ID");
    tables.add("namenkommentar");
   // headlines.add("Namenlemma");
   headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));
    namenkommentar = true;
  }
    if (request.getParameter("Ausgabe_Erstglied") != null && request.getParameter("Ausgabe_Erstglied").equals("on")) {
    fields.add("substring_index(`namenkommentar`.`PLemma`,_utf8'~',1) AS `Erstglied`");
    fieldNames.add("Erstglied");
    tables.add("namenkommentar");
    headlines.add("Erstglied");
   //headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));
    namenkommentar = true;
  }
    if (request.getParameter("Ausgabe_Zweitglied") != null && request.getParameter("Ausgabe_Zweitglied").equals("on")) {
    fields.add("substring_index(`namenkommentar`.`PLemma`,_utf8'~',-(1)) AS `Zweitglied`");
    fieldNames.add("Zweitglied");
    tables.add("namenkommentar");
    headlines.add("Zweitglied");
   //headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));
    namenkommentar = true;
  }
    if (request.getParameter("Ausgabe_MGHLemma") != null && request.getParameter("Ausgabe_MGHLemma").equals("on")) {
        fields.add("mgh_lemma.MGHLemma");
        fields.add("mgh_lemma.ID");
        fieldNames.add("mgh_lemma.MGHLemma");
        count.add("mgh_lemma.ID");
        tables.add("mgh_lemma");
       // headlines.add("Namenlemma");
       headlines.add(DatenbankDB.getMapping(sprache, "mgh_lemma", "MGHLemma"));
        mghlemma = true;
  }
    // ### Zur Person ###
  if (request.getParameter("Ausgabe_Person_Standardname") != null && request.getParameter("Ausgabe_Person_Standardname").equals("on")) {
    fields.add("person.Standardname");
    fields.add("person.ID");
    count.add("person.ID");
    fieldNames.add("person.Standardname");
    tables.add("person");
 //   headlines.add("Standardname");
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Standardname"));
    person = true;
  }
  if (request.getParameter("Ausgabe_Person_AmtWeihe") != null && request.getParameter("Ausgabe_Person_AmtWeihe").equals("on")) {
    fields.add("selektion_amtweihe.Bezeichnung");
    fieldNames.add("selektion_amtweihe.Bezeichnung");
    if (!tableString.contains("person_hatamtstandweihe")) {
      tableString += " LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
    }
    if (!tableString.contains("selektion_amtweihe")) {
      tableString += " LEFT OUTER JOIN selektion_amtweihe ON person_hatamtstandweihe.AmtWeiheID=selektion_amtweihe.ID";
    }
 //   headlines.add("Amt / Weihe");
     headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeihe"));

    person = true;
  }
  if (request.getParameter("Ausgabe_Person_AmtWeiheZeitraum") != null && request.getParameter("Ausgabe_Person_AmtWeiheZeitraum").equals("on")) {
    fields.add("person_hatamtstandweihe.Zeitraum");
    fieldNames.add("person_hatamtstandweihe.Zeitraum");
    if (!tableString.contains("person_hatamtstandweihe")) {
      tableString += " LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
    }
 //   headlines.add("Zeitraum Amt/Weihe");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeiheZeitraum"));
    person = true;
  }
  if (request.getParameter("Ausgabe_Stand") != null && request.getParameter("Ausgabe_Stand").equals("on")) {
    fields.add("selektion_stand.Bezeichnung");
    fieldNames.add("selektion_stand.Bezeichnung");
    if (!tableString.contains("person_hatstand")) {
      tableString += " LEFT OUTER JOIN person_hatstand ON person.ID=person_hatstand.PersonID";
    }
    if (!tableString.contains("selektion_stand")) {
      tableString += " LEFT OUTER JOIN selektion_stand ON person_hatstand.StandID=selektion_stand.ID";
    }
     headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand"));

    person = true;
  }
  if (request.getParameter("Ausgabe_Person_Ethnie") != null && request.getParameter("Ausgabe_Person_Ethnie").equals("on")) {
    fields.add("selektion_ethnie.Bezeichnung");
    fieldNames.add("selektion_ethnie.Bezeichnung");
    if (!tableString.contains("person_hatethnie")) {
      tableString += " LEFT OUTER JOIN person_hatethnie ON person.ID=person_hatethnie.PersonID";
    }
    if (!tableString.contains("selektion_ethnie")) {
      tableString += " LEFT OUTER JOIN selektion_ethnie ON person_hatethnie.EthnieID=selektion_ethnie.ID";
    }
 //   headlines.add("Ethnie(n)");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Ethnie"));
    person = true;
  }
  if (request.getParameter("Ausgabe_Geschlecht") != null && request.getParameter("Ausgabe_Geschlecht").equals("on")) {
    fields.add("selektion_geschlecht.Bezeichnung");
    fieldNames.add("selektion_geschlecht.Bezeichnung");
    if (!tableString.contains("selektion_geschlecht")) {
      tableString += " LEFT OUTER JOIN selektion_geschlecht ON person.Geschlecht=selektion_geschlecht.ID";
    }
 //   headlines.add("Ethnie(n)");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Geschlecht"));
    person = true;
  }
  if (request.getParameter("Ausgabe_Person_Verwandte") != null && request.getParameter("Ausgabe_Person_Verwandte").equals("on")) {
    fields.add("selektion_verwandtschaftsgrad.Bezeichnung");
    fields.add("perszu.Standardname");
    fields.add("perszu.ID");
    fieldNames.add("selektion_verwandtschaftsgrad.Bezeichnung");
    fieldNames.add("perszu.Standardname");
    if (!tableString.contains("person_verwandtmit")) {
      tableString += " LEFT OUTER JOIN person_verwandtmit ON person.ID=person_verwandtmit.PersonIDvon";
    }
    if (!tableString.contains("selektion_verwandtschafsgrad")) {
      tableString += " LEFT OUTER JOIN selektion_verwandtschaftsgrad ON person_verwandtmit.VerwandtschaftsgradID=selektion_verwandtschaftsgrad.ID";
    }
    tableString += " LEFT OUTER JOIN person perszu ON person_verwandtmit.PersonIDzu = perszu.ID";
    //headlines.add("Verwandtschaftsgrad");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Verwandtschaftsgrad"));

  //  headlines.add("Verwandte(r)");
         headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Verwandte"));

    person = true;
  }
  if (request.getParameter("Ausgabe_Person_Areal") != null && request.getParameter("Ausgabe_Person_Areal").equals("on")) {
    fields.add("selektion_areal.Bezeichnung");
    fieldNames.add("selektion_areal.Bezeichnung");
    if (!tableString.contains("person_hatareal")) {
      tableString += " LEFT OUTER JOIN person_hatareal ON person.ID=person_hatareal.PersonID";
    }
    if (!tableString.contains("selektion_areal")) {
      tableString += " LEFT OUTER JOIN selektion_areal ON person_hatareal.ArealID=selektion_areal.ID";
    }
   // headlines.add("Areal");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Areal"));

    person = true;
  }

  // ### Zum Einzelbeleg ###
  if (request.getParameter("Ausgabe_Einzelbeleg_Belegstelle") != null && request.getParameter("Ausgabe_Einzelbeleg_Belegstelle").equals("on")) {
    fields.add("quelle.Bezeichnung");
    fields.add("quelle.ID");
    count.add("quelle.ID");
    fieldNames.add("quelle.Bezeichnung");
    if (!tableString.contains("quelle")) {
      tableString += " LEFT OUTER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    }
    //headlines.add("Quelle");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Quelle"));

    if (!edition && !tableString.contains("edition")) {
      tableString += " LEFT OUTER JOIN edition ON einzelbeleg.EditionID=edition.ID";
    fields.add("edition.Titel");
    fields.add("edition.ID");
    fieldNames.add("edition.Titel");
    //headlines.add("Edition");
           headlines.add(DatenbankDB.getMapping(sprache, "quelle", "Edition"));
    }

    fields.add("einzelbeleg.EditionKapitel");
    fieldNames.add("einzelbeleg.EditionKapitel");
    //headlines.add("Kapitel");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "EditionKapitel"));

    fields.add("einzelbeleg.EditionSeite");
    fieldNames.add("einzelbeleg.EditionSeite");
   // headlines.add("Seite");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "EditionSeite"));
    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Provenance_Einzelbeleg") != null && request.getParameter("Ausgabe_Provenance_Einzelbeleg").equals("on")) {
        fields.add("einzelbeleg.provenance_source");
        fieldNames.add("einzelbeleg.provenance_source");
        //headlines.add("provenance_source");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "ProvenanceEinzelbeleg"));
        einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Quelle_Datierung") != null && request.getParameter("Ausgabe_Quelle_Datierung").equals("on")) {
    fields.add("quelle.VonTag");
    fields.add("quelle.VonMonat");
    fields.add("quelle.VonJahr");
    fields.add("quelle.VonJahrhundert");
    fields.add("quelle.BisTag");
    fields.add("quelle.BisMonat");
    fields.add("quelle.BisJahr");
    fields.add("quelle.BisJahrhundert");
    fieldNames.add("quelle.VonTag");
    fieldNames.add("quelle.VonMonat");
    fieldNames.add("quelle.VonJahr");
    fieldNames.add("quelle.VonJahrhundert");
    fieldNames.add("quelle.BisTag");
    fieldNames.add("quelle.BisMonat");
    fieldNames.add("quelle.BisJahr");
    fieldNames.add("quelle.BisJahrhundert");
    headlines.add("Q von T.");
    headlines.add("Q von M.");
    headlines.add("Q von J.");
    headlines.add("Q von Jh.");
    headlines.add("Q bis T.");
    headlines.add("Q bis M.");
    headlines.add("Q bis J.");
    headlines.add("Q bis Jh.");
    if (!tableString.contains("quelle")) {
      tableString += " LEFT OUTER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    }
    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Quellengattung") != null && request.getParameter("Ausgabe_Einzelbeleg_Quellengattung").equals("on")) {
    fields.add("selektion_quellengattung.Bezeichnung");
    fieldNames.add("selektion_quellengattung.Bezeichnung");
    if (!tableString.contains("selektion_quellengattung")) {
      tableString += " LEFT OUTER JOIN selektion_quellengattung ON quelle.QuelleGattungID=selektion_quellengattung.ID";
    }
    //headlines.add("Quellengattung");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Quellengattung"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Belegform") != null && request.getParameter("Ausgabe_Einzelbeleg_Belegform").equals("on")) {
    fields.add("einzelbeleg.Belegform");
    fields.add("einzelbeleg.ID");
    count.add("einzelbeleg.ID");
    fieldNames.add("einzelbeleg.Belegform");
    //headlines.add("Belegform");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Belegform"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Kontext") != null && request.getParameter("Ausgabe_Einzelbeleg_Kontext").equals("on")) {
    fields.add("einzelbeleg.Kontext");
    fieldNames.add("einzelbeleg.Kontext");
   // headlines.add("Kontext");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Kontext"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Datierung") != null && request.getParameter("Ausgabe_Einzelbeleg_Datierung").equals("on")) {
    fields.add("einzelbeleg.VonTag");
    fields.add("einzelbeleg.VonMonat");
    fields.add("einzelbeleg.VonJahr");
    fields.add("einzelbeleg.VonJahrhundert");
    fields.add("einzelbeleg.BisTag");
    fields.add("einzelbeleg.BisMonat");
    fields.add("einzelbeleg.BisJahr");
    fields.add("einzelbeleg.BisJahrhundert");
    fieldNames.add("einzelbeleg.VonTag");
    fieldNames.add("einzelbeleg.VonMonat");
    fieldNames.add("einzelbeleg.VonJahr");
    fieldNames.add("einzelbeleg.VonJahrhundert");
    fieldNames.add("einzelbeleg.BisTag");
    fieldNames.add("einzelbeleg.BisMonat");
    fieldNames.add("einzelbeleg.BisJahr");
    fieldNames.add("einzelbeleg.BisJahrhundert");
    headlines.add("EB von T.");
    headlines.add("EB von M.");
    headlines.add("EB von J.");
    headlines.add("EB von Jh.");
    headlines.add("EB bis T.");
    headlines.add("EB bis M.");
    headlines.add("EB bis J.");
    headlines.add("EB bis Jh.");
    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_lebend") != null && request.getParameter("Ausgabe_Einzelbeleg_lebend").equals("on")) {
    fields.add("selektion_lebendverstorben.Bezeichnung");
    fieldNames.add("selektion_lebendverstorben.Bezeichnung");
    if (!tableString.contains("selektion_lebendverstorben")) {
      tableString += " LEFT OUTER JOIN selektion_lebendverstorben ON einzelbeleg.LebendVerstorbenID=selektion_lebendverstorben.ID";
    }
    //headlines.add("lebend / verstorben");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Lebend"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Funktion") != null && request.getParameter("Ausgabe_Einzelbeleg_Funktion").equals("on")) {
    fields.add("selektion_funktion.Bezeichnung");
    fieldNames.add("selektion_funktion.Bezeichnung");
    if (!tableString.contains("einzelbeleg_hatfunktion")) {
      tableString += " LEFT OUTER JOIN einzelbeleg_hatfunktion ON einzelbeleg.ID=einzelbeleg_hatfunktion.EinzelbelegID";
    }
    if (!tableString.contains("selektion_funktion")) {
      tableString += " LEFT OUTER JOIN selektion_funktion ON einzelbeleg_hatfunktion.FunktionID=selektion_funktion.ID";
    }
   // headlines.add("Funktion");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Funktion"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Areal") != null && request.getParameter("Ausgabe_Einzelbeleg_Areal").equals("on")) {
    fields.add("selektion_areal.Bezeichnung");
    fieldNames.add("selektion_areal.Bezeichnung");
    if (!tableString.contains("einzelbeleg_hatareal")) {
      tableString += " LEFT OUTER JOIN einzelbeleg_hatareal ON einzelbeleg.ID=einzelbeleg_hatareal.EinzelbelegID";
    }
    if (!tableString.contains("selektion_areal")) {
      tableString += " LEFT OUTER JOIN selektion_areal ON einzelbeleg_hatareal.ArealID=selektion_areal.ID";
    }
    //headlines.add("Areal");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Areal"));

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Varianten") != null && request.getParameter("Ausgabe_Einzelbeleg_Varianten").equals("on")) {
    fields.add("einzelbeleg_textkritik.Variante");
    fields.add("handschrift.Bibliothekssignatur");
     fields.add("handschrift_ueberlieferung.VonJahrhundert");
    fields.add("handschrift_ueberlieferung.BisJahrhundert");
   fieldNames.add("einzelbeleg_textkritik.Variante");
    fieldNames.add("handschrift.Bibliothekssignatur");
    fieldNames.add("handschrift_ueberlieferung.VonJahrhundert");
    fieldNames.add("handschrift_ueberlieferung.BisJahrhundert");
    if (!tableString.contains("einzelbeleg_textkritik")) {
      tableString += " LEFT OUTER JOIN einzelbeleg_textkritik ON einzelbeleg.ID=einzelbeleg_textkritik.EinzelbelegID LEFT OUTER JOIN ueberlieferung_edition ON (einzelbeleg_textkritik.EditionID=ueberlieferung_edition.EditionID AND einzelbeleg_textkritik.HandschriftID=ueberlieferung_edition.UeberlieferungID) LEFT OUTER JOIN handschrift_ueberlieferung ON handschrift_ueberlieferung.ID=ueberlieferung_edition.UeberlieferungID LEFT OUTER JOIN handschrift ON handschrift_ueberlieferung.HandschriftID=handschrift.ID ";
    }
   // headlines.add("Variante");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Varianten"));
    headlines.add("Bib.Sig.");
    headlines.add("TZ v. J.");
    headlines.add("TZ b. J.");

    einzelbeleg = true;
  }
  if (request.getParameter("Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat") != null && request.getParameter("Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat").equals("on")) {
    fields.add("handschrift_ueberlieferung.Schriftheimat");
    fieldNames.add("handschrift_ueberlieferung.Schriftheimat");
    if (!tableString.contains("handschrift")) {
      tableString += " LEFT OUTER JOIN handschrift ON handschrift.ID = einzelbeleg.HandschriftID";
    }
    if (!tableString.contains("handschrift_ueberlieferung")) {
      tableString += " LEFT OUTER JOIN handschrift_ueberlieferung ON handschrift.ID=handschrift_ueberlieferung.HandschriftID";
    }
    //headlines.add("Schriftheimat d. Textzeugen");
           headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat"));

    einzelbeleg = true;
  }
  // ######### AUSGABEFELDER ##########


  // ######### ORDER BY ##########
  String orderV [] = new String [15];
  String order = "";
  if (request.getParameter("neworder") != null) {
    order = "ORDER BY "+request.getParameter("neworder")+" ";
    if (request.getParameter("newdirection") != null) {
      order +=request.getParameter("newdirection");
    }
    else
      order += "ASC";
  }

  for (int i=1; i<orderV.length; i++) {
    if (request.getParameter("order"+i)!= null && !request.getParameter("order"+i).equals("-1")) {
      if (i==1 && request.getParameter("neworder") == null)
        order = "ORDER BY";
      else
        order += ", ";
      if (request.getParameter("order"+i).equals("OrderNamen") ) {
        order += " namenkommentar.PLemma";
        orderV[i-1] = "namenkommentar.PLemma";
        namenkommentar = true;

        if (request.getParameter("Ausgabe_Namenlemma") == null || !request.getParameter("Ausgabe_Namenlemma").equals("on")) {
           	fields.add("namenkommentar.PLemma");
           	fields.add("namenkommentar.ID");
    		fieldNames.add("namenkommentar.PLemma");
    		count.add("namenkommentar.ID");
    		tables.add("namenkommentar");
   			// headlines.add("Namenlemma");
   			headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));
    		namenkommentar = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderMGH")){
          order += " mgh_lemma.MGHLemma";
          orderV[i-1] = "mgh_lemma.MGHLemma";
          mghlemma = true;

    	   if (request.getParameter("Ausgabe_MGHLemma") == null || !request.getParameter("Ausgabe_MGHLemma").equals("on")) {
    	        fields.add("mgh_lemma.MGHLemma");
    	        fields.add("mgh_lemma.ID");
    	        fieldNames.add("mgh_lemma.MGHLemma");
    	        count.add("mgh_lemma.ID");
    	        tables.add("mgh_lemma");
    	       // headlines.add("Namenlemma");
    	       headlines.add(DatenbankDB.getMapping(sprache, "mgh_lemma", "MGHLemma"));
    	        mghlemma = true;
    	  }

      }
      else if (request.getParameter("order"+i).equals("OrderErstglied")) {
        order += " Erstglied";
        orderV[i-1] = "Erstglied";
        namenkommentar = true;

    	if (request.getParameter("Ausgabe_Erstglied") == null || !request.getParameter("Ausgabe_Erstglied").equals("on")) {
    		fields.add("substring_index(`namenkommentar`.`PLemma`,_utf8'~',1) AS `Erstglied`");
    		fieldNames.add("Erstglied");
    		tables.add("namenkommentar");
    		headlines.add("Erstglied");
    		namenkommentar = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderZweitglied")) {
        order += " Zweitglied";
        orderV[i-1] = "Zweitglied";
        namenkommentar = true;

    	if (request.getParameter("Ausgabe_Zweitglied") == null || !request.getParameter("Ausgabe_Zweitglied").equals("on")) {
    		fields.add("substring_index(`namenkommentar`.`PLemma`,_utf8'~',-(1)) AS `Zweitglied`");
    		fieldNames.add("Zweitglied");
    		tables.add("namenkommentar");
    		headlines.add("Zweitglied");
    		namenkommentar = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderPersonen")) {
        order += " person.Standardname";
        orderV[i-1] = "person.ID";
        person = true;

        if (request.getParameter("Ausgabe_Person_Standardname") == null || !request.getParameter("Ausgabe_Person_Standardname").equals("on")) {
    		fields.add("person.Standardname");
    		fields.add("person.ID");
    		count.add("person.ID");
    		fieldNames.add("person.Standardname");
    		tables.add("person");
 //   		headlines.add("Standardname");
    		headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Standardname"));
    		person = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderGeschlecht")) {
        order += " selektion_geschlecht.Bezeichnung";
        orderV[i-1] = "selektion_geschlecht.Bezeichnung";
        person = true;

       if (request.getParameter("Ausgabe_Geschlecht") == null || !request.getParameter("Ausgabe_Geschlecht").equals("on")) {
    		fields.add("selektion_geschlecht.Bezeichnung");
    		fieldNames.add("selektion_geschlecht.Bezeichnung");
    		if (!tableString.contains("selektion_geschlecht")) {
      			tableString += " LEFT OUTER JOIN selektion_geschlecht ON person.Geschlecht=selektion_geschlecht.ID";
    		}
        	headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Geschlecht"));
    		person = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderAmtWeihe")) {
        order += " selektion_amtweihe.Bezeichnung";
        orderV[i-1] = "selektion_amtweihe.Bezeichnung";
        person = true;

        if (request.getParameter("Ausgabe_Person_AmtWeihe") == null || !request.getParameter("Ausgabe_Person_AmtWeihe").equals("on")) {
    		fields.add("selektion_amtweihe.Bezeichnung");
    		fieldNames.add("selektion_amtweihe.Bezeichnung");
    		if (!tableString.contains("person_hatamtstandweihe")) {
      			tableString += " LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
    		}
    		if (!tableString.contains("selektion_amtweihe")) {
      			tableString += " LEFT OUTER JOIN selektion_amtweihe ON person_hatamtstandweihe.AmtWeiheID=selektion_amtweihe.ID";
    		}
     		headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeihe"));

    		person = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderStand")) {
        order += " selektion_stand.Bezeichnung";
        orderV[i-1] = "selektion_stand.Bezeichnung";
        person = true;

  		if (request.getParameter("Ausgabe_Stand") == null || !request.getParameter("Ausgabe_Stand").equals("on")) {
    		fields.add("selektion_stand.Bezeichnung");
    		fieldNames.add("selektion_stand.Bezeichnung");
    		if (!tableString.contains("person_hatstand")) {
      			tableString += " LEFT OUTER JOIN person_hatstand ON person.ID=person_hatstand.PersonID";
    		}
    		if (!tableString.contains("selektion_stand")) {
      			tableString += " LEFT OUTER JOIN selektion_stand ON person_hatstand.StandID=selektion_stand.ID";
    		}
     		headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand"));

    		person = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderEthnie")) {
        order += " selektion_ethnie.Bezeichnung";
        orderV[i-1] = "selektion_ethnie.Bezeichnung";
        person = true;

  		if (request.getParameter("Ausgabe_Person_Ethnie") == null || !request.getParameter("Ausgabe_Person_Ethnie").equals("on")) {
    		fields.add("selektion_ethnie.Bezeichnung");
    		fieldNames.add("selektion_ethnie.Bezeichnung");
    		if (!tableString.contains("person_hatethnie")) {
      			tableString += " LEFT OUTER JOIN person_hatethnie ON person.ID=person_hatethnie.PersonID";
    		}
    		if (!tableString.contains("selektion_ethnie")) {
      			tableString += " LEFT OUTER JOIN selektion_ethnie ON person_hatethnie.EthnieID=selektion_ethnie.ID";
    		}
        	headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Ethnie"));
    		person = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderBelege")) {
        order += " einzelbeleg.Belegform";
        orderV[i-1] = "einzelbeleg.ID";
        einzelbeleg = true;

        if (request.getParameter("Ausgabe_Einzelbeleg_Belegform") == null || !request.getParameter("Ausgabe_Einzelbeleg_Belegform").equals("on")) {
    		fields.add("einzelbeleg.Belegform");
    		fields.add("einzelbeleg.ID");
    		count.add("einzelbeleg.ID");
    		fieldNames.add("einzelbeleg.Belegform");
    //		headlines.add("Belegform");
           	headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Belegform"));

    		einzelbeleg = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderQuellen")) {
        order += " quelle.Bezeichnung";
        orderV[i-1] = "quelle.Bezeichnung";
        einzelbeleg = true;

        if (request.getParameter("Ausgabe_Einzelbeleg_Belegstelle") == null || !request.getParameter("Ausgabe_Einzelbeleg_Belegstelle").equals("on")) {
    		fields.add("quelle.Bezeichnung");
    		fields.add("quelle.ID");
    		count.add("quelle.ID");
    		fieldNames.add("quelle.Bezeichnung");
    		if (!tableString.contains("quelle")) {
      			tableString += " LEFT OUTER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    		}
    //		headlines.add("Quelle");
           	headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Quelle"));

    		einzelbeleg = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderQuellengattung")) {
        order += " selektion_quellengattung.Bezeichnung";
        orderV[i-1] = "selektion_quellengattung.Bezeichnung";
        einzelbeleg = true;

        if (request.getParameter("Ausgabe_Einzelbeleg_Quellengattung") == null || !request.getParameter("Ausgabe_Einzelbeleg_Quellengattung").equals("on")) {
    		fields.add("selektion_quellengattung.Bezeichnung");
    		fieldNames.add("selektion_quellengattung.Bezeichnung");
    		if (!tableString.contains("selektion_quellengattung")) {
      			tableString += " LEFT OUTER JOIN selektion_quellengattung ON quelle.QuelleGattungID=selektion_quellengattung.ID";
    		}
    //		headlines.add("Quellengattung");
           	headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Quellengattung"));

    		einzelbeleg = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderVariante")) {
        order += " einzelbeleg_textkritik.Variante";
        orderV[i-1] = "einzelbeleg_textkritik.Variante";
        einzelbeleg = true;

        if (request.getParameter("Ausgabe_Einzelbeleg_Varianten") == null || !request.getParameter("Ausgabe_Einzelbeleg_Varianten").equals("on")) {
    fields.add("einzelbeleg_textkritik.Variante");
    fields.add("handschrift.Bibliothekssignatur");
    fields.add("handschrift_ueberlieferung.VonJahrhundert");
    fields.add("handschrift_ueberlieferung.BisJahrhundert");
    fieldNames.add("einzelbeleg_textkritik.Variante");
    fieldNames.add("handschrift.Bibliothekssignatur");
    fieldNames.add("handschrift_ueberlieferung.VonJahrhundert");
    fieldNames.add("handschrift_ueberlieferung.BisJahrhundert");
    if (!tableString.contains("einzelbeleg_textkritik")) {
      tableString += " LEFT OUTER JOIN einzelbeleg_textkritik ON einzelbeleg.ID=einzelbeleg_textkritik.EinzelbelegID LEFT OUTER JOIN ueberlieferung_edition ON (einzelbeleg_textkritik.EditionID=ueberlieferung_edition.EditionID AND einzelbeleg_textkritik.HandschriftID=ueberlieferung_edition.UeberlieferungID) LEFT OUTER JOIN handschrift_ueberlieferung ON handschrift_ueberlieferung.ID=ueberlieferung_edition.UeberlieferungID LEFT OUTER JOIN handschrift ON handschrift_ueberlieferung.HandschriftID=handschrift.ID ";    }
   // headlines.add("Variante");
          headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Varianten"));
    headlines.add("Bib.Sig.");
    headlines.add("TZ v. J.");
    headlines.add("TZ b. J.");

    einzelbeleg = true;
  		}
      }
      else if (request.getParameter("order"+i).equals("OrderTextzeugen")) {

      }
      else if (request.getParameter("order"+i).equals("OrderDatEinzelbeleg")) {
        orderV[i-1] = "einzelbelegBerJahr";
        int zeitraum = 25;
        try{
           zeitraum = Integer.parseInt(request.getParameter("order"+i+"zeit"));
        }catch(Exception ex){
        }
          order += " (VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert) DIV "+ zeitraum + "), VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert)"; // Richtung wird später angefügt
        einzelbeleg = true;

      //  if (request.getParameter("Ausgabe_Einzelbeleg_Datierung") == null || !request.getParameter("Ausgabe_Einzelbeleg_Datierung").equals("on")) {
    		fields.add("VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert) AS einzelbelegBerJahr");
    		fieldNames.add("einzelbelegBerJahr");
    		headlines.add("EB von J.");
    		einzelbeleg = true;
  	  //	}
      }
     else if (request.getParameter("order"+i).equals("OrderDatQuelle")) {
        orderV[i-1] = "quelleBerJahr";
        int zeitraum = 25;
        try{
           zeitraum = Integer.parseInt(request.getParameter("order"+i+"zeit"));
        }catch(Exception ex){
        }
        order += " (VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) DIV "+ zeitraum + "), VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert)"; // Richtung wird später angefügt
        einzelbeleg = true;

     //   if (request.getParameter("Ausgabe_Quelle_Datierung") == null || !request.getParameter("Ausgabe_Quelle_Datierung").equals("on")) {
    		fields.add("VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) AS quelleBerJahr");
    		fieldNames.add("quelleBerJahr");
    		if (!tableString.contains("quelle")) {
      			tableString += " LEFT OUTER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    		}

    		headlines.add("Q von J.");
    		einzelbeleg = true;
  	//	}
      }
      else if (request.getParameter("order"+i).equals("OrderAemter")) {

      }
      if (request.getParameter("order"+i+"ASCDESC") != null) {
        order += " "+request.getParameter("order"+i+"ASCDESC");
      }
      else {
        order +=" ASC";
      }
    }
    else orderV[i] = "-";

  //  out.println(order);

    // end if
  } // end for
  // ######### ORDER BY ##########


  // ######### EXPORT ##########
  String export = "liste";
  if (request.getParameter("export") != null) {
    export = request.getParameter("export");
  }
  // ######### EXPORT ##########


  // ######### Grundtabellen ##########
  String tablePreString = "";
  if (einzelbeleg || (person && namenkommentar)|| (person && mghlemma) || (namenkommentar && mghlemma)) {
    tablePreString = "einzelbeleg";
    if (person) {
      tablePreString += " LEFT OUTER JOIN einzelbeleg_hatperson ON einzelbeleg.ID=einzelbeleg_hatperson.EinzelbelegID";
      tablePreString += " LEFT OUTER JOIN person ON einzelbeleg_hatperson.PersonID=person.ID";
    }
    if (namenkommentar) {
      tablePreString += " LEFT OUTER JOIN einzelbeleg_hatnamenkommentar ON einzelbeleg_hatnamenkommentar.EinzelbelegID=einzelbeleg.ID";
      tablePreString += " LEFT OUTER JOIN namenkommentar ON namenkommentar.ID=einzelbeleg_hatnamenkommentar.NamenkommentarID";
    }
    if (mghlemma) {
        tablePreString += " LEFT OUTER JOIN einzelbeleg_hatmghlemma ON einzelbeleg_hatmghlemma.EinzelbelegID=einzelbeleg.ID";
        tablePreString += " LEFT OUTER JOIN mgh_lemma ON mgh_lemma.ID=einzelbeleg_hatmghlemma.MGHLemmaID";
      }
    if (edition)
    {
       tablePreString += " RIGHT OUTER JOIN edition ON einzelbeleg.EditionID=edition.ID";
    }
  }
  else if (person) {
    tablePreString = "person";
  }
  else if (namenkommentar) {
    tablePreString = "namenkommentar";
  }
  else if (mghlemma) {
	    tablePreString = "mgh_lemma";
	  }
 else if (edition) {
    tablePreString = "edition";
  }
  tableString = tablePreString + tableString;
  // ######### Grundtabellen ##########


%>

<%


  if (true) {
    conditions = removeDuplicates(conditions);
    fields = removeDuplicates(fields);
    tables = removeDuplicates(tables);

    joins = removeDuplicates(joins);



    // Bedingungen
    String conditionsString = "";
    if (conditions.size() > 0) {
      conditionsString += conditions.get(0);
      for (int i=1; i<conditions.size(); i++) {
        conditionsString += " AND "+conditions.get(i);
      }
    }
    else {
      conditionsString += "1";
    }

    String orderString = " ORDER BY ";

      // Ausgabefelder
    String fieldsString = "";
    List<String> fieldAliases = new ArrayList<>();
    if (fields.size() > 0) {
      fieldsString += QueryHelper.getFieldAliasSelect(fields.get(0));
      fieldAliases.add(QueryHelper.getFieldAliasSelect(fields.get(0)));

      if(fields.get(0).indexOf(" AS ")>0)
         orderString += fields.get(0).substring(fields.get(0).indexOf(" AS ")+4);
      else orderString += fields.get(0);


      for (int i=1; i<fields.size(); i++) {
        fieldsString += ", "+QueryHelper.getFieldAliasSelect(fields.get(i));
        fieldAliases.add(QueryHelper.getFieldAliasSelect(fields.get(i)));
        orderString += ", ";
              if(fields.get(i).indexOf(" AS ")>0)
         orderString += fields.get(i).substring(fields.get(i).indexOf(" AS ")+4);
      else orderString += fields.get(i);

      }
    }

    // Zählfelder
    String countString = "";
    if (count.size() > 0) {
      countString += "count(DISTINCT " + count.get(0) + ")";
      for (int i=1; i<count.size(); i++) {
        countString += ", count(DISTINCT "+count.get(i) + ")";
      }
    }


    // Tabellen
    String tablesString = "";
    if (tables.size() > 0) {
      tablesString += tables.get(0);
      for (int i=1; i<tables.size(); i++) {
        tablesString += ", "+tables.get(i);
      }
    }

    // Joins
    String joinsString = "";
    if (joins.size() > 0) {
      joinsString += joins.get(0);
      for (int i=1; i<joins.size(); i++) {
        joinsString += " "+joins.get(i);
      }
    }


    tablesString = tableString;
    try {
      int pageoffset = 0;
      if (request.getParameter("pageoffset") != null) {
        pageoffset = Integer.parseInt(request.getParameter("pageoffset"));
      }


	  if(fields.size()==0){
	  	out.println("Bitte wählen Sie mind. ein Ausgabefeld aus (Schritt 2).");
	  	return;
	  }


      String sql = "SELECT "+countString+" FROM "+tablesString+" WHERE ("+conditionsString+")"; // GROUP BY "+fieldsString;

    if(!countString.equals("")){
        out.println("<b> Insgesamt ");
        java.util.List<Object[]> result = new ArrayList<>();
        result = SucheDB.getSearchCount(conditionsString, countString, tablesString);
        for(Object[] item : result){
           for (int i=0; i<count.size(); i++) {
              out.println(item[i].toString());
               if(count.get(i).startsWith("einzelbeleg"))
                   if(Integer.valueOf(item[i].toString()) == 1)
                       out.print(" Beleg");
                   else
                       out.print(" Belege");
               else if(count.get(i).startsWith("namen"))
                   out.print(" Namen");
               else if(count.get(i).startsWith("mgh"))
                   out.print(" Namen (MGH-Lemma)");
               else if(count.get(i).startsWith("quelle"))
                   if(Integer.valueOf(item[i].toString()) == 1)
                       out.print(" Quelle");
                   else
                       out.print(" Quellen");
               else if(count.get(i).startsWith("person"))
                   if(Integer.valueOf(item[i].toString()) == 1)
                       out.print(" Person");
                   else out.print(" Personen");
               if(i<count.size()-1)
                   out.println(", ");
           }
       }
    }
      out.println("<br></b>");



      sql = "SELECT DISTINCT "+fieldsString+" FROM "+tablesString+" WHERE ("+conditionsString+") "+order; //GROUP BY "+fieldsString+"

       if (order.equals("")) sql += orderString;

 //     if (export.equals("liste") || export.equals("browse"))
 //       sql += " LIMIT "+(pageoffset*pageLimit)+", "+pageLimit;


      //out.println(sql);
    // if(true)return;
    java.util.List<Map<String, String>> searchResults = null;
    searchResults = SucheDB.getSearchResult(fieldsString, tablesString, conditionsString, orderString, order, fieldAliases.toArray(String[]::new));

  //    out.println("<p><i>insgesamt <b>"+linecount+"</b> Treffer</i></p>");
              int orderSize = 0;
         for(int z = 0; z<orderV.length; z++)
            if(orderV[z]!= null && !orderV[z].equals("-")) orderSize++;
        boolean [] first  = {true, true, true, true, true,true, true, true, true, true,true, true, true, true, true};
      String oldValue [] = new String [15];


      %>


      <%

      // ########## LISTE/BROWSE ##########
      try{
      if (export.equals("liste") || export.equals("browse")) {

      String header = "";

      out.print("<a href=\"#\" onClick=\"expandNextLevel('complete')\" style=\"font-size:small\" >Weitere Ebene aufklappen</a>");
      out.print("<a href=\"#\" onClick=\"collapseNextLevel('complete')\" style=\"font-size:small\">Weitere Ebene zuklappen</a>");

  //      out.print("<table class=\"resultlist\">");
        header += "<tr>";
        for (int i=0; i<headlines.size(); i++) {
        if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") ||fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))){
          header += "<th width=\""+(100/headlines.size())+"%\"class=\"resultlist\">";
          // Link für Seite erzeugen
          String direction = "";
          if (order.contains(fieldNames.get(i))) {
            direction = order.substring(order.indexOf(fieldNames.get(i)+" ")+fieldNames.get(i).length()+1, min(order.length(), order.indexOf(fieldNames.get(i)+" ")+fieldNames.get(i).length()+5));
            if (direction.contains("DESC")) {
              direction = "DESC";
            }
            else {
              direction = "ASC";
            }
          }

          String parameter = "?neworder="+fieldNames.get(i);
          if (direction.equals("ASC"))
            parameter += "&newdirection=DESC";
          else
            parameter += "&newdirection=ASC";

          for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ) {
            String paramName = e.nextElement();
            if (!paramName.contains("order") && !paramName.equals("newdirection"))
              parameter += "&"+paramName+"="+urlEncode(request.getParameter(paramName));
          }

          header += headlines.get(i);

          header += "</th>";
          }
        }
        boolean even = false;
                header += "</tr>";
        out.print("<p id='result-loading'>Suchergebnis l\u00E4dt...</p>");
        out.print("<ul class=\"mktree\" id=\"complete\" style='display:none'>");


            if(orderSize == 0) out.print("<table class=\"resultlist\" width=\"100%\">"+header+"<tr>");


            boolean found = false;

        for (Map<String, String> item : searchResults) {
        found = true;

        for(int z = 0; z<orderSize; z++){
           int jahr = 0;
           String jahrV = item.get(QueryHelper.getFieldAliasResult(orderV[z]));
           int zeitraum = 0;
           if(orderV[z].endsWith("Jahr")){
           try{
               zeitraum = Integer.parseInt(request.getParameter("order" + (z+1) + "zeit"));
           }catch(Exception ex){ zeitraum = 25;}
               if(jahrV==null) jahr = 0;
               else jahr = Integer.parseInt(jahrV);
               jahr = jahr / zeitraum;
               jahrV = "" +  jahr;
           }

        if(first[z] || item.get(QueryHelper.getFieldAliasResult(orderV[z]))!=null && !jahrV.equalsIgnoreCase(oldValue[z])) {
           oldValue[z] = jahrV;
           if(!first[z]){
              out.print("</table>");
                            for(int z2=z; z2<orderSize; z2++)out.print("</ul></li>");
                            //out.println();

           }
              first[z] = false;
              for(int z2=z+1; z2<orderSize; z2++) first[z2]=true;

            if(z>0)out.print("<li class=\"liClosed\" style=\"font-size:medium\">");
           else out.print("<li class=\"liOpen\" style=\"font-size:large\">");
           //entryCount[z]++;

           String text = item.get(QueryHelper.getFieldAliasResult(orderV[z]));
           if(orderV[z].startsWith("einzelbeleg.ID"))text = item.get(QueryHelper.getFieldAliasResult("einzelbeleg.Belegform"));
           if(orderV[z].startsWith("person.ID"))text = item.get(QueryHelper.getFieldAliasResult("person.Standardname"));
           if(text==null) text="-";
           String titel=orderV[z];

            if(orderV[z].startsWith("einzelbeleg.ID")) titel="einzelbeleg.Belegform";
           if(orderV[z].startsWith("person.ID")) titel="person.Standardname";
           titel = headlines.get(fieldNames.indexOf(titel));

           out.print(titel + ":");
                           boolean link = false;
           if(export.equals("browse") && !text.equals("-"))
                if (orderV[z].equals("einzelbeleg.ID")) {
                  out.print("<a href=\"einzelbeleg?ID="+item.get(QueryHelper.getFieldAliasResult("einzelbeleg.ID"))+"\">");
                  link = true;
                }
                else if (orderV[z].equals("person.ID")) {
                  out.print("<a href=\"person?ID="+item.get(QueryHelper.getFieldAliasResult("person.ID"))+"\">");
                  link = true;
                }
                else if (orderV[z].equals("perszu.Standardname")) {
                  out.print("<a href=\"person?ID="+item.get(QueryHelper.getFieldAliasResult("perszu.ID"))+"\">");
                  link = true;
                }
                else if (orderV[z].equals("namenkommentar.PLemma")) {
                  out.print("<a href=\"namenkommentar?ID="+item.get(QueryHelper.getFieldAliasResult("namenkommentar.ID"))+"\">");
                  link = true;
                }
                else if (orderV[z].equals("mgh_lemma.MGHLemma")) {
                    out.print("<a href=\"lemma?ID="+item.get(QueryHelper.getFieldAliasResult("mgh_lemmaID"))+"\">");
                    link = true;
                  }
                 else if (orderV[z].equals("quelle.Bezeichnung")) {
                  out.print("<a href=\"quelle?ID="+item.get(QueryHelper.getFieldAliasResult("quelle.ID"))+"\">");
                  link = true;
                }
                else if (orderV[z].equals("edition.Titel")) {
                  try{
                  out.print("<a href=\"edition?ID="+item.get(QueryHelper.getFieldAliasResult("edition.ID"))+"\">");
                  link = true;
                  }catch(Exception e){
                     link=false;
                  }
                }
                else if (orderV[z].contains("ID")) {
           out.print("<a href=\""+formular+".jsp?ID="+item.get(QueryHelper.getFieldAliasResult(formular+".ID"))+"\">Gehe zu: ");
                              link = true;
                }


           if(orderV[z].startsWith("einzelbeleg.ID"))
              out.print(format(text, "einzelbeleg.Belegform"));
           else if(orderV[z].endsWith("Jahr")){
              int ja = Integer.parseInt(oldValue[z]);
              out.print("" + (ja* zeitraum) + "-" + ((ja+1)* zeitraum -1));
           }
           else {

               String format = orderV[z];
               if(orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) format = "PLemma";
                    out.print(format(text, format));
               }
               if (link) {
                 out.print("</a>&nbsp;");
                }

           if(z==orderSize-1){
           out.print("<ul><table class=\"resultlist\" width=\"100%\">"+header+"<tr>");
           }
           else out.print("<ul>");
        }


        }


          out.print("<tr class=\""+(even?"":"un")+"even\">");
           if (!formular.equals("favorit") && !formular.equals("freie_suche")&& !formular.equals("namenkommentar")&& !formular.equals("literatur")) {
            out.print("<td class=\"resultlist\" valign=\"top\" align=\"center\"><a href=\""+formular+".jsp?ID="+item.get(QueryHelper.getFieldAliasResult(formular+".ID"))+"\">Gehe zu</a></td>");
          }

          for(int i=0; i<fieldNames.size(); i++) {
            String fieldName = fieldNames.get(i);
            String fieldAlias = QueryHelper.getFieldAliasResult(fieldName);
          if(fieldName.endsWith("Jahrhundert") || fieldName.endsWith("Jahr") || fieldName.endsWith("Monat") || fieldName.endsWith("Tag") || !order.contains(fieldName)){
            out.print("<td class=\"resultlist\" valign=\"top\">");
             if (item.get(fieldAlias) != null && !DBtoHTML(item.get(fieldAlias)).equals("")) {
              String fieldValue = item.get(fieldAlias);
              String cell = DBtoHTML(fieldValue);
              if (export.equals("browse")) {
                boolean link = false;
                if (fieldName.contains("einzelbeleg.Belegform") && item.get(QueryHelper.getFieldAliasResult("einzelbeleg.ID")) != null) {
                  out.print("<a href=\"einzelbeleg?ID="+item.get(QueryHelper.getFieldAliasResult("einzelbeleg.ID"))+"\">");
                  link = true;
                }
                else if (fieldName.contains("person.Standardname") && item.get(QueryHelper.getFieldAliasResult("person.ID")) != null) {
                  out.print("<a href=\"person?ID="+item.get(QueryHelper.getFieldAliasResult("person.ID"))+"\">");
                  link = true;
                }
                else if (fieldName.contains("perszu.Standardname") && item.get(QueryHelper.getFieldAliasResult("perszu.ID")) != null) {
                  out.print("<a href=\"person?ID="+item.get(QueryHelper.getFieldAliasResult("perszu.ID"))+"\">");
                  link = true;
                }
                else if (fieldName.contains("namenkommentar.PLemma") && item.get(QueryHelper.getFieldAliasResult("namenkommentar.ID")) != null) {
                  out.print("<a href=\"namenkommentar?ID="+item.get(QueryHelper.getFieldAliasResult("namenkommentar.ID"))+"\">");
                  link = true;
                }
                else if (fieldName.contains("mgh_lemma.MGHLemma") && item.get(QueryHelper.getFieldAliasResult("mgh_lemma.ID")) != null) {
                    out.print("<a href=\"lemma?ID="+item.get(QueryHelper.getFieldAliasResult("mgh_lemma.ID"))+"\">");
                    link = true;
                  }
                  else if (fieldName.contains("quelle.Bezeichnung") && item.get(QueryHelper.getFieldAliasResult("quelle.ID")) != null) {
                  out.print("<a href=\"quelle?ID="+item.get(QueryHelper.getFieldAliasResult("quelle.ID"))+"\">");
                  link = true;
                }
                else if (fieldName.contains("edition.Titel") && item.get(QueryHelper.getFieldAliasResult("edition.ID")) != null) {
                  try{
                  out.print("<a href=\"edition?ID="+item.get(QueryHelper.getFieldAliasResult("edition.ID"))+"\">");
                  link = true;
                  }catch(Exception e){
                     link=false;
                  }
                }
                else if (fieldName.contains("ID")) {
                  out.print("<a href=\""+formular+".jsp?ID="+item.get(formular+"ID")+"\">Gehe zu: ");
                              link = true;
                }
                if(fieldName.endsWith("PLemma") || fieldName.equals("Erstglied") || fieldName.equals("Zweitglied"))
                   cell = format(cell, "PLemma");
                   out.print(cell);
                if (link) {
                  out.print("</a>");
                }
              }
              else{
                if(fieldName.endsWith("PLemma") || fieldName.equals("Erstglied") || fieldName.equals("Zweitglied"))
                	cell = format(cell, "PLemma");

                out.print(cell);
              }
            }
            else
              out.print("&nbsp;");

            out.print("</td>");
            }
          }
          out.print("</tr>");
          even = !even;

        }

        out.print("</tr>");
        out.print("</table>");
        for(int z = orderSize-1; z>=0; z--)out.print("</ul></li>");

        if(!found)out.println("Kein Eintrag vorhanden, der dem Suchkriterium entspricht.");

        out.print("</ul>");

                %>
<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function(e) {
		var result_list = document.getElementById("complete");
		try {
			var array = result_list.getElementsByTagName("li");
			for(var j = 0; j < array.length; j++) {
				var ul = array[j].getElementsByTagName("ul")[0].previousSibling;
				var li = array[j].getElementsByTagName("li");
				var count = 0;
				if(li.length < 1)
					count = (array[j].getElementsByTagName("table")[0].rows.length - 2);
				else
			       count = ul.nextSibling.childNodes.length;
			    if(count == 1)
			    	ul.data = ul.data + "("+ count + " Eintrag)";
			    else
			    	ul.data = ul.data + "("+ count + " Eintr\u00E4ge)";
			}
		}
		catch(ex) {
		}
		finally {
			result_list.style.display = "block";
			document.getElementById("result-loading").style.display = "none";
		}
	});
</script>
        <%
      }
      }catch(Exception ex){out.println(fieldNames);out.println(ex);out.println("!!!"+ ex.getStackTrace()[0] + ex.getStackTrace());}
      // ########## LISTE/BROWSE #########

      // ########## EXCEL #########
      if (export.equals("excel")) {
        PrintWriter excel = new PrintWriter(new FileWriter(this.getServletContext().getRealPath("/")+"print\\output_"+session.getAttribute("Benutzername")+".csv"));
       for(int z = 0; z<orderSize; z++){
            String titel=orderV[z];
           if(orderV[z].startsWith("einzelbeleg.ID")) titel="einzelbeleg.Belegform";
           titel = headlines.get(fieldNames.indexOf(titel));
           excel.print("\""+titel+"\";");
        }

        for (int i=0; i<headlines.size(); i++) {
         if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") ||fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i)))
          excel.print("\""+headlines.get(i)+"\";");
        }
        excel.println();

        for ( Map<String, String> item : searchResults ) {
          for(int z = 0; z<orderSize; z++){
           int jahr = 0;
           String jahrV = item.get(orderV[z]);
           int zeitraum = 0;
           if(orderV[z].endsWith("Jahr")){
           	   zeitraum = Integer.parseInt(request.getParameter("order" + (z+1) + "zeit"));
               if(jahrV==null) jahr = 0;
               else jahr = Integer.parseInt(jahrV);
               jahr = jahr / zeitraum;
               jahrV = "" +  jahr;
           }

        if(first[z] || item.get(orderV[z])!=null && !jahrV.equals(oldValue[z])) {
           oldValue[z] = jahrV;
           if(!first[z]){
              excel.println();
           }
           first[z] = false;
           for(int z2=z+1; z2<orderSize; z2++) first[z2]=true;
           for(int z2=0; z2<z; z2++) excel.print(";");

           String text = item.get(orderV[z]);
           if(orderV[z].startsWith("einzelbeleg.ID"))text = item.get("einzelbeleg.Belegform");
           if(text==null) text="-";
           String titel=orderV[z];

           if(orderV[z].startsWith("einzelbeleg.ID")) titel="einzelbeleg.Belegform";

           if(orderV[z].endsWith("Jahr")){
              int ja = Integer.parseInt(oldValue[z]);
              excel.println("\"" + (ja* zeitraum) + "-" + ((ja+1)* zeitraum -1) + "\";");
           }
           else {
               String format = orderV[z];
               if(orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) format = "PLemma";
                     excel.println("\"" + text + "\";");
           }
        }
        }

         for(int z2=0; z2<orderSize; z2++) excel.print(";");

         for(int i=0; i<fieldNames.size(); i++) {

            if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))){

              if (item.get(fieldNames.get(i)) == null || item.get(fieldNames.get(i)).equals("null"))
                excel.print("\"-\";");
              else
                excel.print("\""+item.get(fieldNames.get(i))+"\";");
            }
          }
          excel.println();
        }
        excel.close();
        out.println("<a href='../../print/output_"+session.getAttribute("Benutzername")+".csv'>herunterladen</a>");
      }
      // ########## EXCEL #########

      // ########## RTF #########
      if (export.equals("rtf")) {
		Document document = new Document(PageSize.A4.rotate());

		// step 2:
		// we create a writer that listens to the document
		// and directs a RTF-stream to a file

		RtfWriter2.getInstance(document, new FileOutputStream(this.getServletContext().getRealPath("/")+"print/output_"+session.getAttribute("Benutzername")+".rtf"));

		// step 3: we open the document
		document.open();

		int tabSize = 0;

		        for (int i=0; i<headlines.size(); i++) {
          if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") ||fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i)))
                      tabSize++;
         }


            Table tab = new Table(tabSize);
                    for (int i=0; i<headlines.size(); i++) {
          if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") ||fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i)))
                       tab.addCell(new Cell(new Paragraph(HTMLtoDB(headlines.get(i)), new  Font(Font.TIMES_ROMAN, 10, Font.BOLD, new Color(0, 0, 0)))));
         }



        for ( Map<String, String> item : searchResults ) {
          for(int z = 0; z<orderSize; z++){
           int jahr = 0;
           String jahrV = item.get(orderV[z]);
           int zeitraum = 0;
           if(orderV[z].endsWith("Jahr")){
           	   zeitraum = Integer.parseInt(request.getParameter("order" + (z+1) + "zeit"));
               if(jahrV==null) jahr = 0;
               else jahr = Integer.parseInt(jahrV);
               jahr = jahr / zeitraum;
               jahrV = "" +  jahr;
           }

        if(first[z] || item.get(orderV[z])!=null && !jahrV.equals(oldValue[z])) {
           oldValue[z] = jahrV;
           String t = "";
           if(!first[z]){
            document.add(tab);
             tab = new Table(tabSize);

        for (int i=0; i<headlines.size(); i++) {
          if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") ||fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i)))
                       tab.addCell(new Cell(new Paragraph(HTMLtoDB(headlines.get(i)), new  Font(Font.TIMES_ROMAN, 10, Font.BOLD, new Color(0, 0, 0)))));
         }


           }
           first[z] = false;
           for(int z2=z+1; z2<orderSize; z2++) first[z2]=true;
           for(int z2=0; z2<z; z2++) t += "\t";

           String text = item.get(orderV[z]);
           if(orderV[z].startsWith("einzelbeleg.ID"))text = item.get("einzelbeleg.Belegform");
           if(text==null) text="-";
           String titel=orderV[z];
      //     out.println(z + "::" + orderV[z]);

           if(orderV[z].startsWith("einzelbeleg.ID")) titel="einzelbeleg.Belegform";
           titel = HTMLtoDB(headlines.get(fieldNames.indexOf(titel)));

           int fontsize = 16 - 2*z;
           if(fontsize<10) fontsize=10;

           if(orderV[z].endsWith("Jahr")){
              int ja = Integer.parseInt(oldValue[z]);
              document.add(new Paragraph(t + titel + ":" + (ja* zeitraum) + "-" + ((ja+1)* zeitraum -1), new  Font(Font.TIMES_ROMAN, fontsize, Font.NORMAL, new Color(0, 0, 0))));
           }
           else {
               String format = orderV[z];
               if(orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) format = "PLemma";
               document.add(new Paragraph( t  + titel + ":" +   text, new  Font(Font.TIMES_ROMAN, fontsize, Font.NORMAL, new Color(0, 0, 0))));
           }
        }
        }


         for(int i=0; i<fieldNames.size(); i++) {

            if(fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))){

              if (item.get(fieldNames.get(i)) == null || item.get(fieldNames.get(i)).equals("null"))
                tab.addCell(new Cell(new Paragraph("-", new  Font(Font.TIMES_ROMAN, 8, Font.NORMAL, new Color(0, 0, 0)))));
              else
                tab.addCell(new Cell(new Paragraph(item.get(fieldNames.get(i)), new  Font(Font.TIMES_ROMAN, 8, Font.NORMAL, new Color(0, 0, 0)))));
            }
          }
        }
    	  document.add(tab);
        document.close();

        out.println("<a href='../../print/output_"+session.getAttribute("Benutzername")+".rtf'>herunterladen</a>");
      }
      // ########## rtf #########

      // ########## SEITENNAVIGATION #########
  /*    if (export.equals("liste") || export.equals("browse")) {
        out.println("<p class=\"resultlistnavigation\" align=\"center\">");
        int pages = (linecount / pageLimit)+1;
        for (int i=0; i< pages; i++) {
          // Link für Seite erzeugen
          String parameter = "?pageoffset="+i;
          for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ) {
            String paramName = e.nextElement();
            if (!paramName.equals("pageoffset"))
              parameter += "&"+paramName+"="+urlEncode(request.getParameter(paramName));
          }

          // Link zur ersten Seite anzeigen falls nötig
          if (i ==  0 && i <= pageoffset - 10) {
            out.println("<a href=\""+parameter+"\">"+(i+1)+"</a>&nbsp;...&nbsp;");
          }

          // gelinkte Seitennummer anzeigen
          if (i < pageoffset + 10 && i > pageoffset - 10) {
            if (i==pageoffset) {
              out.println("<b>");
            }
            out.println("<a href=\""+parameter+"\">"+(i+1)+"</a>&nbsp;");
            if (i==pageoffset) {
              out.println("</b>");
            }
          }
          // Link zur letzten Seite anzeigen falls nötig
          if (i ==  pages-1 && i >= pageoffset + 10) {
            out.println("...&nbsp;<a href=\""+parameter+"\">"+(i+1)+"</a>&nbsp;");
          }
        }
        out.println("</p>");
      }*/
      // ########## SEITENNAVIGATION #########
    }
    catch (Exception e) {
      out.println(e);
    }
    finally {

    }
  }
%>
