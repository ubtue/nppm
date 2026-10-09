<%@page import="de.uni_tuebingen.ub.nppm.util.pagination.search.PrintPagination"%>
<%@page import="java.math.BigInteger"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*"%>

<%@ page import="java.io.*" isThreadSafe="false" %>
<%@ page import="java.awt.Color" isThreadSafe="false" %>
<%@ page import="java.util.ArrayList" isThreadSafe="false" %>
<%@ page import="java.util.Enumeration" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%@ page import="com.lowagie.text.Document" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.rtf.*" isThreadSafe="false" %>

<%@ page import="org.apache.commons.lang3.StringUtils" isThreadSafe="false" %>
<%

    String einzelbelegeVonQuelle = request.getParameter("einzelbelegeVonQuelle");
    if ("true".equals(einzelbelegeVonQuelle)) {
        int quellenId = 0;
        String[] quellenListe = request.getParameterValues("Quellenliste[]");
        if (quellenListe != null && quellenListe.length > 0) {
            quellenId = Integer.parseInt(quellenListe[0]);
        }
%>
<h3 class="ut-heading ut-heading--h3">
    <% Language.printTextfield(out, session, "quelle", "Bezeichnung");%>
    <jsp:include page="../inc.erzeugeFormular.jsp">
        <jsp:param name="ID" value="<%= quellenId%>"/>
        <jsp:param name="Formular" value="quelle"/>
        <jsp:param name="Datenfeld" value="Bezeichnung"/>
        <jsp:param name="size" value="50"/>
        <jsp:param name="Readonly" value="yes"/>
    </jsp:include>
</h3>
<%
    }
%>

<%
    int pageLimitX = 10;
    int limit = 0;
    int offset = 0;
    try {
        limit = Integer.parseInt(request.getParameter("limit"));
    } catch (Exception ex) {
    }

    String formular = request.getParameter("form");
    String tableString = "";

    //wird mit AND verknüpft
    List<String> conditions = new ArrayList<>();

    //Wird mit OR verknüpft
    List<String> orConditions = new ArrayList<>();

    List<String> fields = new ArrayList<>();
    List<String> fieldNames = new ArrayList<>();  //Ergebnisse
    List<String> count = new ArrayList<>();

    List<String> tables = new ArrayList<>();
    List<String> joins = new ArrayList<>();

    List<String> headlines = new ArrayList<>();  //header - name

    // Welche Grund-Tabellen (Einzelbeleg / Person / Namenkommentar) werden benötigt...
    boolean einzelbeleg = false;
    boolean person = false;
    boolean namenkommentar = false;
    boolean mghlemma = false;

    //NPPM-ID
    String NPPM_ID = request.getParameter("NPPMID");
    if (NPPM_ID != null && !NPPM_ID.trim().equals("")) {
        String newForm = NPPM_ID.substring(1);
        String sqlEscapedForm = DBtoDB(newForm);
        if (NPPM_ID.startsWith("B") || NPPM_ID.startsWith("b")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("einzelbeleg.ID='" + sqlEscapedForm + "'");
                einzelbeleg = true;
            }
        } else if (NPPM_ID.startsWith("P") || NPPM_ID.startsWith("p")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("person.ID='" + sqlEscapedForm + "'");
                person = true;
            }
        } else if (NPPM_ID.startsWith("N") || NPPM_ID.startsWith("n")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("namenkommentar.ID='" + sqlEscapedForm + "'");
                namenkommentar = true;
            }
        } else if (NPPM_ID.startsWith("Q") || NPPM_ID.startsWith("q")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("quelle.ID='" + sqlEscapedForm + "'");
                if (!tableString.contains("quelle")) {
                    tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
                }
            }
        } else if (NPPM_ID.startsWith("E") || NPPM_ID.startsWith("e")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("edition.ID='" + sqlEscapedForm + "'");
                if (!tableString.contains("edition")) {
                    tableString += " INNER JOIN edition ON einzelbeleg.EditionID = edition.ID";
                }
            }
        } else if (NPPM_ID.startsWith("M") || NPPM_ID.startsWith("m")) {
            if (Utils.safeNumeric(newForm)) {
                conditions.add("mgh_lemma.ID='" + sqlEscapedForm + "'");
                mghlemma = true;
            }
        }
    }

    // ######### SUCHANFRAGE ##########
    // ### ZUM NAMEN ###
    if (Utils.safeNumeric(request.getParameter("Namenkommentar2")) && Utils.safeNumeric(request.getParameter("Namenkommentar")) && !request.getParameter("Namenkommentar2").equals("-1") && request.getParameter("Namenkommentar").equals("-1")) {
        conditions.add("namenkommentar.ID=" + request.getParameter("Namenkommentar2"));
        namenkommentar = true;
    }
    if (Utils.safeNumeric(request.getParameter("Namenkommentar")) && !request.getParameter("Namenkommentar").equals("-1")) {
        conditions.add("namenkommentar.ID=" + request.getParameter("Namenkommentar"));
        namenkommentar = true;
    }
    if (request.getParameter("MGHLemma") != null && !request.getParameter("MGHLemma").trim().equals("")) {
        conditions.add("mgh_lemma.MGHLemma LIKE '" + DBtoDB(request.getParameter("MGHLemma").trim()) + "'");
        mghlemma = true;
    }
    if (Utils.safeNumeric(request.getParameter("Sprachherkunft")) && Integer.parseInt(request.getParameter("Sprachherkunft")) > -1) {
        conditions.add("mgh_lemma.SprachherkunftID = '" + request.getParameter("Sprachherkunft") + "'");
        mghlemma = true;
    }

    String erstgliedParam = request.getParameter("ErstGliedSelect");
    String zweitgliedParam = request.getParameter("ZweitGliedSelect");

    if (erstgliedParam != null && !erstgliedParam.trim().isEmpty() && !erstgliedParam.equals("-")) {
        conditions.add("SUBSTRING_INDEX(mgh_lemma.MGHLemma, '~', 1) LIKE '" + DBtoDB(erstgliedParam.trim()) + "'");
        mghlemma = true;
    }

    if (zweitgliedParam != null && !zweitgliedParam.trim().isEmpty() && !zweitgliedParam.equals("-")) {
        conditions.add("SUBSTRING_INDEX(mgh_lemma.MGHLemma, '~', -1) LIKE '" + DBtoDB(zweitgliedParam.trim()) + "'");
        mghlemma = true;
    }

    if (mghlemma) {
        conditions.add("mgh_lemma.MGHLemma NOT LIKE '%"+AbstractBase.escape(Constants.forbiddenLemmaSubstring,AbstractBase.sqlEscapesSingleQuotes)+"%'");
    }

    // ### ZUR PERSON ###
    if (request.getParameter("Personenname") != null && !request.getParameter("Personenname").trim().equals("")) {
        String pn = DBtoDB(request.getParameter("Personenname").trim());
        conditions.add("(person.Standardname LIKE '" + pn + "' OR person_variante.Variante LIKE '" + pn + "')");
        tableString += " LEFT OUTER JOIN person_variante ON person.ID=person_variante.personID";
        person = true;
    }
    if (request.getParameter("Geschlecht") != null && Utils.safeNumeric(request.getParameter("Geschlecht")) && Integer.parseInt(request.getParameter("Geschlecht")) > -1) {
        conditions.add("person.Geschlecht = '" + request.getParameter("Geschlecht") + "'");
        person = true;
    }
    if (Utils.safeNumeric(request.getParameter("AmtWeihePerson")) && Integer.parseInt(request.getParameter("AmtWeihePerson")) > -1) {
        tableString += " INNER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
        List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("AmtWeihePerson")), SelektionAmtWeihe.class).getSubtreeIdsRecursive();
        conditions.add("person_hatamtstandweihe.AmtWeiheID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
        person = true;
    }
    if (Utils.safeNumeric(request.getParameter("StandPerson")) && Integer.parseInt(request.getParameter("StandPerson")) > -1) {
        tableString += " INNER JOIN person_hatstand ON person.ID=person_hatstand.PersonID";
        List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("StandPerson")), SelektionStand.class).getSubtreeIdsRecursive();
        conditions.add("person_hatstand.StandID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
        person = true;
    }
    if (Utils.safeNumeric(request.getParameter("EthniePerson")) && Integer.parseInt(request.getParameter("EthniePerson")) > -1) {
        tableString += " INNER JOIN person_hatethnie ON person.ID=person_hatethnie.PersonID";
        conditions.add("person_hatethnie.EthnieID = '" + request.getParameter("EthniePerson") + "'");
        person = true;
    }
    if (Utils.safeNumeric(request.getParameter("Verwandtschaftsgrad")) && Integer.parseInt(request.getParameter("Verwandtschaftsgrad")) > -1) {
        tableString += " INNER JOIN person_verwandtmit ON person.ID=person_verwandtmit.PersonIDvon";
        conditions.add("person_verwandtmit.VerwandtschaftsgradID = '" + request.getParameter("Verwandtschaftsgrad") + "'");
        person = true;
    }

    // ### ZUM EINZELBELEG ###
    if (request.getParameter("Belegform") != null && !request.getParameter("Belegform").trim().equals("")) {
        conditions.add("einzelbeleg.Belegform LIKE '" + DBtoDB(request.getParameter("Belegform").trim()) + "'");
        einzelbeleg = true;
    }
    if (request.getParameter("Kontext") != null && !request.getParameter("Kontext").trim().equals("")) {
        conditions.add("einzelbeleg.Kontext LIKE '" + DBtoDB(request.getParameter("Kontext").trim()) + "'");
        einzelbeleg = true;
    }
    if (Utils.safeNumeric(request.getParameter("AmtWeiheEinzelbeleg")) && Integer.parseInt(request.getParameter("AmtWeiheEinzelbeleg")) > -1) {
        tableString += " INNER JOIN einzelbeleg_hatamtweihe ON einzelbeleg.ID=einzelbeleg_hatamtweihe.EinzelbelegID";
        List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("AmtWeiheEinzelbeleg")), SelektionAmtWeihe.class).getSubtreeIdsRecursive();
        conditions.add("einzelbeleg_hatamtweihe.AmtWeiheID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
        einzelbeleg = true;
    }
    if (Utils.safeNumeric(request.getParameter("StandEinzelbeleg")) && Integer.parseInt(request.getParameter("StandEinzelbeleg")) > -1) {
        tableString += " INNER JOIN einzelbeleg_hatstand  ON einzelbeleg.ID=einzelbeleg_hatstand.EinzelbelegID";
        List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("StandEinzelbeleg")), SelektionStand.class).getSubtreeIdsRecursive();
        conditions.add("einzelbeleg_hatstand.StandID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
        einzelbeleg = true;
    }
    if (Utils.safeNumeric(request.getParameter("EthnieEinzelbeleg")) && Integer.parseInt(request.getParameter("EthnieEinzelbeleg")) > -1) {
        tableString += " INNER JOIN einzelbeleg_hatethnie ON einzelbeleg.ID=einzelbeleg_hatethnie.EinzelbelegID";
        conditions.add("einzelbeleg_hatethnie.EthnieID = '" + request.getParameter("EthnieEinzelbeleg") + "'");
        einzelbeleg = true;
    }
    if (Utils.safeNumeric(request.getParameter("Funktion")) && Integer.parseInt(request.getParameter("Funktion")) > -1) {
        tableString += " INNER JOIN einzelbeleg_hatfunktion ON einzelbeleg.ID=einzelbeleg_hatfunktion.EinzelbelegID";
        conditions.add("einzelbeleg_hatfunktion.FunktionID = '" + request.getParameter("Funktion") + "'");
        einzelbeleg = true;
    }
    if (Utils.safeNumeric(request.getParameter("QuelleGattung")) && Integer.parseInt(request.getParameter("QuelleGattung")) > 0) {
        tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
        List<Integer> hierarchyIds = SelektionDB.getById(Integer.parseInt(request.getParameter("QuelleGattung")), SelektionQuellengattung.class).getSubtreeIdsRecursive();
        conditions.add("quelle.QuelleGattungID IN (" + StringUtils.join(hierarchyIds, ",") + ")");
        einzelbeleg = true;
    }
    if (request.getParameter("PersonZeitraum") != null && !request.getParameter("PersonZeitraum").trim().equals("")) {
        int vonNum = 0;
        int bisNum = 0;
        if (request.getParameter("PersonZeitraum").contains("-")) {
            // Zeitraum
            String von = request.getParameter("PersonZeitraum").substring(0, request.getParameter("PersonZeitraum").indexOf("-")).trim();
            String bis = request.getParameter("PersonZeitraum").substring(request.getParameter("PersonZeitraum").indexOf("-") + 1).trim();
            if (von.toLowerCase().contains("jh")) {
                try {
                    vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j"))) - 1) * 100;
                    if (von.endsWith("2")) {
                        vonNum += 51;
                    } else {
                        vonNum += 1;
                    }
                } catch (NumberFormatException e) {;
                }
            } else if (von.toLowerCase().contains(".")) {

            } else {
                try {
                    vonNum = Integer.parseInt(von);
                } catch (NumberFormatException e) {;
                }
            }

            if (bis.toLowerCase().contains("jh")) {
                try {
                    bisNum = (Integer.parseInt(bis.substring(0, bis.toLowerCase().indexOf("j"))) - 1) * 100;
                    if (bis.endsWith("1")) {
                        bisNum += 50;
                    } else {
                        bisNum += 100;
                    }
                } catch (NumberFormatException e) {;
                }
            } else if (bis.toLowerCase().contains(".")) {

            } else {

                try {
                    bisNum = Integer.parseInt(bis);
                } catch (NumberFormatException e) {;
                }
            }
        } else if (request.getParameter("PersonZeitraum").toLowerCase().contains("jh")) {

            String von = request.getParameter("PersonZeitraum").trim();
            try {
                vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j"))) - 1) * 100;
                bisNum = vonNum;
                if (von.endsWith("1")) {
                    bisNum += 50;
                } else {
                    bisNum += 100;
                }
                if (von.endsWith("2")) {
                    vonNum += 51;
                } else {
                    vonNum += 1;
                }
            } catch (NumberFormatException e) {;
            }

            // Einzelnes Jahrhundert
        } else if (request.getParameter("PersonZeitraum").toLowerCase().contains(".")) {
            // Einzelnes Datum
        } else {
            // Einzelne Jahreszahl
            String von = request.getParameter("PersonZeitraum").trim();
            try {
                vonNum = Integer.parseInt(von);
                bisNum = vonNum;
            } catch (NumberFormatException e) {;
            }

        }

        conditions.add("(VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)<99999 and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)>-99999 and (VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)>=" + vonNum + " and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)<=" + bisNum + ") OR"
                + "(VON_JAHR_JHDT(einzelbeleg.vonJahr, einzelbeleg.vonJahrhundert, einzelbeleg.bisJahrhundert)<=" + vonNum + " and BIS_JAHR_JHDT(einzelbeleg.bisJahr, einzelbeleg.bisJahrhundert, einzelbeleg.vonJahrhundert)>=" + bisNum + "))");
        einzelbeleg = true;
    }

    // ### ZUR QUELLE ###
    if (!tableString.contains(" quelle ")) {
        tableString += " INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
    }
    conditions.add("quelle.zuVeroeffentlichen=1");
    einzelbeleg = true;
    String[] quellenliste;
    quellenliste = request.getParameterValues("Quellenliste[]");
    if (request.getParameter("Quelle") != null && !request.getParameter("Quelle").trim().equals("") && (quellenliste == null || quellenliste.length == 0 || Utils.allValuesAre(quellenliste, "-1"))) {
        conditions.add("quelle.Bezeichnung LIKE '%" + DBtoDB(request.getParameter("Quelle").trim()) + "%'");
        namenkommentar = true;
    }

    if (quellenliste != null) {
        for (String qid : quellenliste) {
            // Nur numerische IDs akzeptieren
            if (!qid.equals("-1") && Utils.safeNumeric(qid)) {
                orConditions.add("quelle.ID=" + qid);
                einzelbeleg = true;
            }
        }
    }
    if (Utils.safeNumeric(request.getParameter("Quellengattung")) && Integer.parseInt(request.getParameter("Quellengattung")) > -1) {
        conditions.add("quelle.QuelleGattungID = '" + request.getParameter("Quellengattung") + "'");
        einzelbeleg = true;
    }
    if (request.getParameter("QuelleZeitraum") != null && !request.getParameter("QuelleZeitraum").trim().equals("")) {
        int vonNum = 0;
        int bisNum = 0;
        if (request.getParameter("QuelleZeitraum").contains("-")) {
            // Zeitraum
            String von = request.getParameter("QuelleZeitraum").substring(0, request.getParameter("QuelleZeitraum").indexOf("-")).trim();
            String bis = request.getParameter("QuelleZeitraum").substring(request.getParameter("QuelleZeitraum").indexOf("-") + 1).trim();
            if (von.toLowerCase().contains("jh")) {
                try {
                    vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j"))) - 1) * 100;
                    if (von.endsWith("2")) {
                        vonNum += 51;
                    } else {
                        vonNum += 1;
                    }
                } catch (NumberFormatException e) {;
                }
            } else if (von.toLowerCase().contains(".")) {

            } else {
                try {
                    vonNum = Integer.parseInt(von);
                } catch (NumberFormatException e) {;
                }
            }

            if (bis.toLowerCase().contains("jh")) {
                try {
                    bisNum = (Integer.parseInt(bis.substring(0, bis.toLowerCase().indexOf("j"))) - 1) * 100;
                    if (bis.endsWith("1")) {
                        bisNum += 50;
                    } else {
                        bisNum += 100;
                    }
                } catch (NumberFormatException e) {;
                }
            } else if (bis.toLowerCase().contains(".")) {

            } else {

                try {
                    bisNum = Integer.parseInt(bis);
                } catch (NumberFormatException e) {;
                }
            }
        } else if (request.getParameter("QuelleZeitraum").toLowerCase().contains("jh")) {

            String von = request.getParameter("QuelleZeitraum").trim();
            try {
                vonNum = (Integer.parseInt(von.substring(0, von.toLowerCase().indexOf("j"))) - 1) * 100;
                bisNum = vonNum;
                if (von.endsWith("1")) {
                    bisNum += 50;
                } else {
                    bisNum += 100;
                }
                if (von.endsWith("2")) {
                    vonNum += 51;
                } else {
                    vonNum += 1;
                }
            } catch (NumberFormatException e) {;
            }

            // Einzelnes Jahrhundert
        } else if (request.getParameter("QuelleZeitraum").toLowerCase().contains(".")) {
            // Einzelnes Datum
        } else {
            // Einzelne Jahreszahl
            String von = request.getParameter("QuelleZeitraum").trim();
            try {
                vonNum = Integer.parseInt(von);
                bisNum = vonNum;
            } catch (NumberFormatException e) {;
            }

        }

        conditions.add("(VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)<99999 and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)>-99999 and (VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)>=" + vonNum + " and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)<=" + bisNum + ") OR"
                + "(VON_JAHR_JHDT(quelle.vonJahr, quelle.vonJahrhundert, quelle.bisJahrhundert)<=" + vonNum + " and BIS_JAHR_JHDT(quelle.bisJahr, quelle.bisJahrhundert, quelle.vonJahrhundert)>=" + bisNum + "))");
        einzelbeleg = true;
    }

    String pageString = request.getParameter("Seite");
    if (pageString != null && !pageString.isEmpty()) {
        conditions.add("einzelbeleg.EditionSeite = '" + DBtoDB(request.getParameter("Seite")) + "'");
        einzelbeleg = true;
    }


    // ######### SUCHANFRAGE ##########
    String sprache = Constants.DEFAULT_LANG;
    if (session != null && session.getAttribute("Sprache") != null) {
        sprache = (String) session.getAttribute("Sprache");
    }

    // ######### AUSGABEFELDER ##########
    // ### Zum Einzelbeleg ###  //Damit Beleg ganz am Anfang steht
    if (request.getParameter("Ausgabe_Einzelbeleg_Belegform") != null && request.getParameter("Ausgabe_Einzelbeleg_Belegform").equals("on")) {
        fields.add("einzelbeleg.Belegform");
        fields.add("einzelbeleg.ID AS einzelbelegID");
        count.add("einzelbeleg.ID");
        fieldNames.add("einzelbeleg.Belegform");
        //headlines.add("Belegform");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Belegform"));

        einzelbeleg = true;
    }

    if (request.getParameter("Ausgabe_Einzelbeleg_Belegstelle") != null && request.getParameter("Ausgabe_Einzelbeleg_Belegstelle").equals("on")) {

    if (!"true".equals(einzelbelegeVonQuelle)) {
        fields.add("quelle.Bezeichnung");
        fieldNames.add("quelle.Bezeichnung");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Quelle"));
    }

        fields.add("quelle.ID AS quelleID");
        count.add("quelle.ID");

        if (!tableString.contains("quelle")) {
            tableString += " LEFT OUTER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID";
        }
        //headlines.add("Quelle");

        fields.add("einzelbeleg.seite");
        fieldNames.add("einzelbeleg.seite");
        headlines.add(Language.getTextfield(session, "suche", "NummerSeite"));

        fields.add("einzelbeleg.raster");
        fieldNames.add("einzelbeleg.raster");
        headlines.add(Language.getTextfield(session, "suche", "Raster"));

        fields.add("edition.Zitierweise");
        //fields.add("edition.ID");
        fieldNames.add("edition.Zitierweise");
        if (!tableString.contains("edition")) {
            tableString += " LEFT OUTER JOIN edition ON einzelbeleg.EditionID=edition.ID";
        }
        //headlines.add("Edition");
        headlines.add(DatenbankDB.getMapping(sprache, "quelle", "Edition"));

        fields.add("einzelbeleg.EditionKapitel");
        fieldNames.add("einzelbeleg.EditionKapitel");
        //headlines.add("Kapitel");
        headlines.add(DatenbankDB.getMapping(sprache, "einzelbeleg", "EditionKapitel"));

        fields.add("einzelbeleg.EditionSeite");
        fieldNames.add("einzelbeleg.EditionSeite");
        // headlines.add("Seite");
        headlines.add(DatenbankDB.getMapping(sprache, "einzelbeleg", "EditionSeite"));

        einzelbeleg = true;
    }

    // ### Zum Namen ###
    if (request.getParameter("Ausgabe_Namenlemma") != null && request.getParameter("Ausgabe_Namenlemma").equals("on")) {
        fields.add("namenkommentar.PLemma");
        fields.add("namenkommentar.ID AS namenkommentarID");
        fieldNames.add("namenkommentar.PLemma");
        count.add("namenkommentar.ID");
        tables.add("namenkommentar");
        // headlines.add("Namenlemma");
        headlines.add(DatenbankDB.getMapping(sprache, "namenkommentar", "PLemma"));
        namenkommentar = true;
    }
    if (request.getParameter("Ausgabe_MGHLemma") != null && request.getParameter("Ausgabe_MGHLemma").equals("on")) {
        fields.add("mgh_lemma.MGHLemma");
        fields.add("mgh_lemma.ID AS mgh_lemmaID");
        fieldNames.add("mgh_lemma.MGHLemma");
        count.add("mgh_lemma.ID");
        tables.add("mgh_lemma");
        // headlines.add("Namenlemma");
        headlines.add(DatenbankDB.getMapping(sprache, "mgh_lemma", "MGHLemma"));
        mghlemma = true;
    }
    if (request.getParameter("Ausgabe_Sprachherkunft") != null && request.getParameter("Ausgabe_Sprachherkunft").equals("on")) {
        fields.add("selektion_sprachherkunft.Bezeichnung");
        fieldNames.add("selektion_sprachherkunft.Bezeichnung");
        if (!tableString.contains("selektion_sprachherkunft")) {
            tableString += " LEFT OUTER JOIN selektion_sprachherkunft ON mgh_lemma.SprachherkunftID=selektion_sprachherkunft.ID";
        }
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Sprachherkunft"));
        mghlemma = true;
    }
    // ### Zur Person ###
    if (request.getParameter("Ausgabe_Person_Standardname") != null && request.getParameter("Ausgabe_Person_Standardname").equals("on")) {
        fields.add("person.Standardname");
        fields.add("person.ID AS personID");
        count.add("person.ID");
        fieldNames.add("person.Standardname");
        tables.add("person");
        //   headlines.add("Standardname");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Standardname"));
        person = true;
    }
    // für Person
    if (request.getParameter("Ausgabe_Person_AmtWeihe") != null && request.getParameter("Ausgabe_Person_AmtWeihe").equals("on")) {
        fields.add("amtweihe_person.Bezeichnung AS AmtWeihe_Person");
        fieldNames.add("AmtWeihe_Person");

        if (!tableString.contains("person_hatamtstandweihe")) {
            tableString += " LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
        }
        if (!tableString.contains("amtweihe_person")) {
            tableString += " LEFT OUTER JOIN selektion_amtweihe AS amtweihe_person ON person_hatamtstandweihe.AmtWeiheID=amtweihe_person.ID";
        }

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
    // Ausgabe für Person → Stand
    if ("on".equals(request.getParameter("Ausgabe_Stand"))) {
        // Alias für die Stand-Tabelle bei Person
        fields.add("stand_person.Bezeichnung AS Stand_Person");
        fieldNames.add("Stand_Person");

        if (!tableString.contains("person_hatstand")) {
            tableString += " LEFT OUTER JOIN person_hatstand ON person.ID = person_hatstand.PersonID";
        }
        if (!tableString.contains("stand_person")) {
            tableString += " LEFT OUTER JOIN selektion_stand AS stand_person ON person_hatstand.StandID = stand_person.ID";
        }

        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand"));
        person = true;
    }
    // für Einzelbeleg
    if (request.getParameter("Ausgabe_Einzelbeleg_AmtWeihe") != null && request.getParameter("Ausgabe_Einzelbeleg_AmtWeihe").equals("on")) {
        fields.add("amtweihe_eb.Bezeichnung AS AmtWeihe_Einzelbeleg");
        fieldNames.add("AmtWeihe_Einzelbeleg");

        if (!tableString.contains("einzelbeleg_hatamtweihe")) {
            tableString += " LEFT OUTER JOIN einzelbeleg_hatamtweihe ON einzelbeleg.ID=einzelbeleg_hatamtweihe.EinzelbelegID";
        }
        if (!tableString.contains("amtweihe_eb")) {
            tableString += " LEFT OUTER JOIN selektion_amtweihe AS amtweihe_eb ON einzelbeleg_hatamtweihe.AmtWeiheID=amtweihe_eb.ID";
        }

        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_AmtWeihe"));
        einzelbeleg = true;
    }
    // Ausgabe für Einzelbeleg → Stand
    if ("on".equals(request.getParameter("Ausgabe_Stand_Einzelbeleg"))) {
        // Alias für die Stand-Tabelle beim Einzelbeleg
        fields.add("stand_eb.Bezeichnung AS Stand_Einzelbeleg");
        fieldNames.add("Stand_Einzelbeleg");

        if (!tableString.contains("einzelbeleg_hatstand")) {
            tableString += " LEFT OUTER JOIN einzelbeleg_hatstand ON einzelbeleg.ID = einzelbeleg_hatstand.EinzelbelegID";
        }
        if (!tableString.contains("stand_eb")) {
            tableString += " LEFT OUTER JOIN selektion_stand AS stand_eb ON einzelbeleg_hatstand.StandID = stand_eb.ID";
        }

        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand_Einzelbeleg"));
        einzelbeleg = true;
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
        //   headlines.add("Geschlecht");
        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Geschlecht"));
        person = true;
    }
    if (request.getParameter("Ausgabe_Person_Verwandte") != null && request.getParameter("Ausgabe_Person_Verwandte").equals("on")) {
        fields.add("selektion_verwandtschaftsgrad.Bezeichnung");
        fields.add("perszu.Standardname");
        fields.add("perszu.ID AS perszuID");
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

    if (request.getParameter("Ausgabe_Einzelbeleg_Quellengattung") != null && request.getParameter("Ausgabe_Einzelbeleg_Quellengattung").equals("on")) {
        fields.add("selektion_quellengattung.Bezeichnung");
        fieldNames.add("selektion_quellengattung.Bezeichnung");
        if (!tableString.contains("selektion_quellengattung")) {
            tableString += " LEFT OUTER JOIN selektion_quellengattung ON quelle.QuelleGattungID=selektion_quellengattung.ID";
        }

        headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "QuelleGattung"));

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
        headlines.add(Language.getTextfield(session, "suche", "VonTag"));
        headlines.add(Language.getTextfield(session, "suche", "VonMonat"));
        headlines.add(Language.getTextfield(session, "suche", "VonJahr"));
        headlines.add(Language.getTextfield(session, "suche", "VonJahrhundert"));
        headlines.add(Language.getTextfield(session, "suche", "BisTag"));
        headlines.add(Language.getTextfield(session, "suche", "BisMonat"));
        headlines.add(Language.getTextfield(session, "suche", "BisJahr"));
        headlines.add(Language.getTextfield(session, "suche", "BisJahrhundert"));
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
        headlines.add(Language.getTextfield(session, "suche", "Signatur"));
        headlines.add(Language.getTextfield(session, "suche", "TZvJ"));
        headlines.add(Language.getTextfield(session, "suche", "TZbJ"));

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
    String orderV[] = new String[15];
    String order = "";
    if (request.getParameter("neworder") != null) {
        order = "ORDER BY " + request.getParameter("neworder") + " ";
        if (request.getParameter("newdirection") != null) {
            order += request.getParameter("newdirection");
        } else {
            order += "ASC";
        }
    }

    for (int i = 1; i < orderV.length; i++) {
        if (request.getParameter("order" + i) != null && !request.getParameter("order" + i).equals("-1")) {
            if (i == 1 && request.getParameter("neworder") == null) {
                order = "ORDER BY";
            } else {
                order += ", ";
            }
            if (request.getParameter("order" + i).equals("OrderNamen")) {
                order += " namenkommentar.PLemma";
                orderV[i - 1] = "namenkommentar.PLemma";
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
            } else if (request.getParameter("order" + i).equals("OrderMGH")) {
                order += " mgh_lemma.MGHLemma";
                orderV[i - 1] = "mgh_lemma.MGHLemma";
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

            } else if (request.getParameter("order" + i).equals("OrderErstglied")) {
                order += " Erstglied";
                orderV[i - 1] = "Erstglied";
                mghlemma = true;

                if (request.getParameter("Ausgabe_Erstglied") == null || !request.getParameter("Ausgabe_Erstglied").equals("on")) {
                    fields.add("substring_index(mgh_lemma.MGHLemma,_utf8'~',1) AS Erstglied");
                    fieldNames.add("Erstglied");
                    tables.add("mgh_lemma");
                    headlines.add("Erstglied");
                    mghlemma = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderZweitglied")) {
                order += " Zweitglied";
                orderV[i - 1] = "Zweitglied";
                mghlemma = true;

                if (request.getParameter("Ausgabe_Zweitglied") == null || !request.getParameter("Ausgabe_Zweitglied").equals("on")) {
                    fields.add("substring_index(mgh_lemma.MGHLemma,_utf8'~',-(1)) AS Zweitglied");
                    fieldNames.add("Zweitglied");
                    tables.add("mgh_lemma");
                    headlines.add("Zweitglied");
                    mghlemma = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderSprachherkunft")) {
                order += " selektion_sprachherkunft.Bezeichnung";
                orderV[i - 1] = "selektion_sprachherkunft.Bezeichnung";
                mghlemma = true;

                if (request.getParameter("Ausgabe_Sprachherkunft") == null || !request.getParameter("Ausgabe_Sprachherkunft").equals("on")) {
                    fields.add("selektion_sprachherkunft.Bezeichnung");
                    fieldNames.add("selektion_sprachherkunft.Bezeichnung");
                    if (!tableString.contains("selektion_sprachherkunft")) {
                        tableString += " LEFT OUTER JOIN selektion_sprachherkunft ON mgh_lemma.SprachherkunftID=selektion_sprachherkunft.ID";
                    }
                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Sprachherkunft"));
                    mghlemma = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderPersonen")) {
                order += " person.Standardname";
                orderV[i - 1] = "person.Standardname";
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
            } else if (request.getParameter("order" + i).equals("OrderGeschlecht")) {
                order += " selektion_geschlecht.Bezeichnung";
                orderV[i - 1] = "selektion_geschlecht.Bezeichnung";
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
            } else if (request.getParameter("order" + i).equals("OrderAmtWeihe")) {
                order += " AmtWeihe_Person"; // <-- nur Aliasname!
                orderV[i - 1] = "AmtWeihe_Person"; // <-- nur Aliasname
                person = true;

                if (request.getParameter("Ausgabe_Person_AmtWeihe") == null || !request.getParameter("Ausgabe_Person_AmtWeihe").equals("on")) {
                    fields.add("amtweihe_person.Bezeichnung AS AmtWeihe_Person"); // <-- mit Alias
                    fieldNames.add("AmtWeihe_Person"); // <-- nur Aliasname

                    if (!tableString.contains("person_hatamtstandweihe")) {
                        tableString += " LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID";
                    }
                    if (!tableString.contains("amtweihe_person")) { //AS amtweihe_person
                        tableString += " LEFT OUTER JOIN selektion_amtweihe AS amtweihe_person ON person_hatamtstandweihe.AmtWeiheID=amtweihe_person.ID";
                    }

                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeihe"));

                    person = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderAmtWeiheEinzelbeleg")) {
                order += " AmtWeihe_Einzelbeleg"; // <-- nur Aliasname!
                orderV[i - 1] = "AmtWeihe_Einzelbeleg"; // <-- nur Aliasname
                einzelbeleg = true;

                if (request.getParameter("Ausgabe_Einzelbeleg_AmtWeihe") == null || !request.getParameter("Ausgabe_Einzelbeleg_AmtWeihe").equals("on")) {
                    fields.add("amtweihe_eb.Bezeichnung AS AmtWeihe_Einzelbeleg"); // <-- mit Alias
                    fieldNames.add("AmtWeihe_Einzelbeleg"); // <-- nur Aliasname

                    if (!tableString.contains("einzelbeleg_hatamtweihe")) {
                        tableString += " LEFT OUTER JOIN einzelbeleg_hatamtweihe ON einzelbeleg.ID=einzelbeleg_hatamtweihe.EinzelbelegID";
                    }
                    if (!tableString.contains("amtweihe_eb")) { //  AS amtweihe_eb
                        tableString += " LEFT OUTER JOIN selektion_amtweihe AS amtweihe_eb ON einzelbeleg_hatamtweihe.AmtWeiheID=amtweihe_eb.ID";
                    }

                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_AmtWeihe"));

                    einzelbeleg = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderStand")) {
                order += " Stand_Person"; // <-- nur Aliasname!
                orderV[i - 1] = "Stand_Person"; // <-- nur Aliasname!
                person = true;

                if (request.getParameter("Ausgabe_Stand") == null || !request.getParameter("Ausgabe_Stand").equals("on")) {
                    fields.add("stand_person.Bezeichnung AS Stand_Person");
                    fieldNames.add("Stand_Person"); // <-- nur Aliasname!
                    if (!tableString.contains("person_hatstand")) {
                        tableString += " LEFT OUTER JOIN person_hatstand ON person.ID = person_hatstand.PersonID";
                    }
                    if (!tableString.contains("stand_person")) { // AS stand_person
                        tableString += " LEFT OUTER JOIN selektion_stand AS stand_person ON person_hatstand.StandID = stand_person.ID";
                    }
                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand"));

                    person = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderStandEinzelbeleg")) {
                order += " Stand_Einzelbeleg"; // <-- nur Aliasname!
                orderV[i - 1] = "Stand_Einzelbeleg"; // <-- nur Aliasname!
                einzelbeleg = true;

                if (request.getParameter("Ausgabe_Stand_Einzelbeleg") == null || !request.getParameter("Ausgabe_Stand_Einzelbeleg").equals("on")) {
                    fields.add("stand_eb.Bezeichnung AS Stand_Einzelbeleg");
                    fieldNames.add("Stand_Einzelbeleg"); // <-- nur Aliasname!
                    if (!tableString.contains("einzelbeleg_hatstand")) {
                        tableString += " LEFT OUTER JOIN einzelbeleg_hatstand ON einzelbeleg.ID = einzelbeleg_hatstand.EinzelbelegID";
                    }
                    if (!tableString.contains("stand_eb")) { // AS stand_person
                        tableString += " LEFT OUTER JOIN selektion_stand AS stand_eb ON einzelbeleg_hatstand.StandID = stand_eb.ID";
                    }
                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Stand_Einzelbeleg"));

                    einzelbeleg = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderEthnie")) {
                order += " selektion_ethnie.Bezeichnung";
                orderV[i - 1] = "selektion_ethnie.Bezeichnung";
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
            } else if (request.getParameter("order" + i).equals("OrderBelege")) {
                order += " einzelbeleg.Belegform";
                orderV[i - 1] = "einzelbeleg.ID";
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
            } else if (request.getParameter("order" + i).equals("OrderQuellen")) {
                order += " quelle.Bezeichnung";
                orderV[i - 1] = "quelle.Bezeichnung";
                einzelbeleg = true;

                if (request.getParameter("Ausgabe_Einzelbeleg_Belegstelle") == null || !request.getParameter("Ausgabe_Einzelbeleg_Belegstelle").equals("on")) {
                    fields.add("einzelbeleg.seite");
                    fieldNames.add("einzelbeleg.seite");
                    headlines.add("Nr./S.");

                    fields.add("einzelbeleg.raster");
                    fieldNames.add("einzelbeleg.raster");
                    headlines.add("Rast.");

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
            } else if (request.getParameter("order" + i).equals("OrderQuellengattung")) {
                order += " selektion_quellengattung.Bezeichnung";
                orderV[i - 1] = "selektion_quellengattung.Bezeichnung";
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
            } else if (request.getParameter("order" + i).equals("OrderVariante")) {
                order += " einzelbeleg_textkritik.Variante";
                orderV[i - 1] = "einzelbeleg_textkritik.Variante";
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
                        tableString += " LEFT OUTER JOIN einzelbeleg_textkritik ON einzelbeleg.ID=einzelbeleg_textkritik.EinzelbelegID LEFT OUTER JOIN ueberlieferung_edition ON (einzelbeleg_textkritik.EditionID=ueberlieferung_edition.EditionID AND einzelbeleg_textkritik.HandschriftID=ueberlieferung_edition.UeberlieferungID) LEFT OUTER JOIN handschrift_ueberlieferung ON handschrift_ueberlieferung.ID=ueberlieferung_edition.UeberlieferungID LEFT OUTER JOIN handschrift ON handschrift_ueberlieferung.HandschriftID=handschrift.ID ";
                    }
                    // headlines.add("Variante");
                    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Varianten"));
                    headlines.add(Language.getTextfield(session, "suche", "Signatur"));
                    headlines.add(Language.getTextfield(session, "suche", "TZvJ"));
                    headlines.add(Language.getTextfield(session, "suche", "TZbJ"));

                    einzelbeleg = true;
                }
            } else if (request.getParameter("order" + i).equals("OrderTextzeugen")) {

            } else if (request.getParameter("order" + i).equals("OrderDatEinzelbeleg")) {
                orderV[i - 1] = "einzelbelegBerJahr";
                int zeitraum = 25;
                try {
                    zeitraum = Integer.parseInt(request.getParameter("order" + i + "zeit"));
                } catch (Exception ex) {
                }
                order += " (VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert) DIV " + zeitraum + "), VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert)"; // Richtung wird spÃ¤ter angefÃ¼gt
                einzelbeleg = true;

                //  if (request.getParameter("Ausgabe_Einzelbeleg_Datierung") == null || !request.getParameter("Ausgabe_Einzelbeleg_Datierung").equals("on")) {
                fields.add("VON_JAHR_JHDT(einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisJahrhundert) AS einzelbelegBerJahr");
                fieldNames.add("einzelbelegBerJahr");
                headlines.add("EB von J.");
                einzelbeleg = true;
                //	}
            } else if (request.getParameter("order" + i).equals("OrderDatQuelle")) {
                orderV[i - 1] = "quelleBerJahr";
                int zeitraum = 25;
                try {
                    zeitraum = Integer.parseInt(request.getParameter("order" + i + "zeit"));
                } catch (Exception ex) {
                }
                order += " (VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) DIV " + zeitraum + "), VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert)"; // Richtung wird spÃ¤ter angefÃ¼gt
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
            } else if (request.getParameter("order" + i).equals("OrderAemter")) {

            }
            if (request.getParameter("order" + i + "ASCDESC") != null) {
                order += " " + request.getParameter("order" + i + "ASCDESC");
            } else {
                order += " ASC";
            }
        } else {
            orderV[i] = "-";
        }
        /*
        Keine Einzelbelege ausgeben die mit einem Lemma verküpft sind welches Constants.forbiddenLemmaSubstring enthält
        */
        if (einzelbeleg) {
            conditions.add("(mgh_lemma.MGHLemma NOT LIKE '%"+AbstractBase.escape(Constants.forbiddenLemmaSubstring,AbstractBase.sqlEscapesSingleQuotes)+"%')");
            mghlemma = true;
        }

        //  out.println(order);
        // end if
    } // end for
    // ######### ORDER BY ##########

    // ######### EXPORT ##########
    String export = "browse";
    if (request.getParameter("export") != null) {
        export = request.getParameter("export");
    }
    // ######### EXPORT ##########

    // ######### Grundtabellen ##########
    String tablePreString = "";
    if (einzelbeleg || (person && namenkommentar) || (person && mghlemma) || (namenkommentar && mghlemma)) {
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

    } else if (person) {
        tablePreString = "person";
    } else if (namenkommentar) {
        tablePreString = "namenkommentar";
    } else if (mghlemma) {
        tablePreString = "mgh_lemma";
    }
    tableString = tablePreString + tableString;
    // ######### Grundtabellen ##########

    if (true) {
        conditions = removeDuplicates(conditions);
        fields = removeDuplicates(fields);
        tables = removeDuplicates(tables);

        joins = removeDuplicates(joins);

        // Bedingungen
        String conditionsString = "";

        String andPart = "";
        if (conditions.size() > 0) {
            andPart += conditions.get(0);
            for (int i = 1; i < conditions.size(); i++) {
                andPart += " AND " + conditions.get(i);
            }
        }

        String orPart = "";
        if (orConditions.size() > 0) {
            orPart += orConditions.get(0);
            for (int i = 1; i < orConditions.size(); i++) {
                orPart += " OR " + orConditions.get(i);
            }
            orPart = "(" + orPart + ")";
        }

        if (!andPart.isEmpty() && !orPart.isEmpty()) {
            conditionsString = andPart + " AND " + orPart;
        } else if (!andPart.isEmpty()) {
            conditionsString = andPart;
        } else if (!orPart.isEmpty()) {
            conditionsString = orPart;
        } else {
            conditionsString += "1";
        }

        // Ausgabefelder
        String fieldsString = "";
        if (fields.size() > 0) {
            fieldsString += fields.get(0);
            for (int i = 1; i < fields.size(); i++) {
                if (fields.get(i).contains(" AS ")) {
                    fieldsString += ", " + fields.get(i);
                } else {
                    fieldsString += ", " + QueryHelper.getFieldAliasSelect(fields.get(i));
                }
            }
        }

        // ZÃ¤hlfelder
        String countString = "";
        if (count.size() > 0) {
            countString += "count(DISTINCT " + count.get(0) + ")";
            for (int i = 1; i < count.size(); i++) {
                countString += ", count(DISTINCT " + count.get(i) + ")";
            }
        }

        // Tabellen
        String tablesString = "";
        if (tables.size() > 0) {
            tablesString += tables.get(0);
            for (int i = 1; i < tables.size(); i++) {
                tablesString += ", " + tables.get(i);
            }
        }

        // Joins
        String joinsString = "";
        if (joins.size() > 0) {
            joinsString += joins.get(0);
            for (int i = 1; i < joins.size(); i++) {
                joinsString += " " + joins.get(i);
            }
        }

        tablesString = tableString;

        int linecount = SucheDB.getLinecount(tablesString, conditionsString);

        int pageoffset = 0;
        if (request.getParameter("pageoffset") != null) {
            pageoffset = Integer.parseInt(request.getParameter("pageoffset"));
        }

        offset = pageoffset * pageLimitX;  // pageLimitX ist die Anzahl der Ergebnisse pro Seite

        if (fields.size() == 0) {
            out.println(Language.getTextfield(session, "freie_suche", "BitteSchritt2"));
            return;
        }

        String sql = "SELECT " + countString + " FROM " + tablesString + " WHERE (" + conditionsString + ")"; // GROUP BY "+fieldsString;
        if (!countString.equals("")) {
            java.util.List<Object[]> resultList = DatenbankDB.getListNative(sql);

            if (!resultList.isEmpty()) {
                Object firstResult = resultList.get(0); // Erstes Element aus der Ergebnisliste abrufen

                if (firstResult instanceof Object[]) {
                    Object[] innerArray = (Object[]) firstResult;
                    StringBuilder output = new StringBuilder();

                    for (int i = 0; i < count.size(); i++) {
                        if (innerArray[i] instanceof Number) {
                            int countValue = ((Number) innerArray[i]).intValue();  //Zählererbnis

                            if (countValue >= 0) {
                                output.append(Language.getTextfield(session, "freie_suche", "Insgesamt") + " ");
                                output.append(countValue).append(" ");

                                // Spezifische Ausgabe basierend auf dem Titel
                                if (count.get(i).startsWith("namenkommentar")) {
                                    if (countValue > 1 || countValue == 0) {
                                        output.append(Language.getTextfield(session, "namenkommentar", "Namenkommentare"));
                                    } else {
                                        output.append(Language.getTextfield(session, "namenkommentar", "Namenkommentar"));
                                    }
                                } else if (count.get(i).startsWith("mgh_lemma")) {
                                    if (countValue > 1 || countValue == 0) {
                                        output.append(Language.getTextfield(session, "mgh_lemma", "Lemmata"));
                                    } else {
                                        output.append(Language.getTextfield(session, "mgh_lemma", "Titel"));
                                    }
                                } else if (count.get(i).startsWith("person")) {
                                    if (countValue > 1 || countValue == 0) {
                                        output.append(Language.getTextfield(session, "person", "Titel"));
                                    } else {
                                        output.append(Language.getTextfield(session, "person", "Person"));
                                    }
                                } else if (count.get(i).startsWith("quelle")) {
                                    if (countValue > 1 || countValue == 0) {
                                        output.append(Language.getTextfield(session, "quelle", "Titel"));
                                    } else {
                                        output.append(Language.getTextfield(session, "quelle", "Quelle"));
                                    }
                                } else if (count.get(i).startsWith("einzelbeleg")) {
                                    if (countValue > 1 || countValue == 0) {
                                        output.append(Language.getTextfield(session, "einzelbeleg", "Titel"));
                                    } else {
                                        output.append(Language.getTextfield(session, "einzelbeleg", "Einzelbeleg"));
                                    }
                                }

                                output.append(", ");
                            }
                        }
                    }

                    // Ausgabe der Gesamtanzahl und Entfernen des letzten Kommas
                    String totalCountOutput = output.toString();
                    if (!totalCountOutput.isEmpty()) {
                        totalCountOutput = totalCountOutput.substring(0, totalCountOutput.length() - 2); // Letztes Komma entfernen
                        out.println(totalCountOutput);
                    }
                } else {

                    int countValue = ((Number) firstResult).intValue();
                    if (countValue > 0) {
                        // Erstelle eine Ausgabe für das einzelne Ergebnis
                        StringBuilder output = new StringBuilder("Insgesamt ");
                        output.append(countValue).append(" ");

                        if (count.get(0).startsWith("namenkommentar")) {
                            if (countValue > 1 || countValue == 0) {
                                output.append(Language.getTextfield(session, "namenkommentar", "Namenkommentare"));
                            } else {
                                output.append(Language.getTextfield(session, "namenkommentar", "Namenkommentar"));
                            }
                        } else if (count.get(0).startsWith("mgh_lemma")) {
                            if (countValue > 1 || countValue == 0) {
                                output.append(Language.getTextfield(session, "mgh_lemma", "Lemmata"));
                            } else {
                                output.append(Language.getTextfield(session, "mgh_lemma", "Titel"));
                            }
                        } else if (count.get(0).startsWith("person")) {
                            if (countValue > 1 || countValue == 0) {
                                output.append(Language.getTextfield(session, "person", "Titel"));
                            } else {
                                output.append(Language.getTextfield(session, "person", "Person"));
                            }
                        } else if (count.get(0).startsWith("quelle")) {
                            if (countValue > 1 || countValue == 0) {
                                output.append(Language.getTextfield(session, "quelle", "Titel"));
                            } else {
                                output.append(Language.getTextfield(session, "quelle", "Quelle"));
                            }
                        } else if (count.get(0).startsWith("einzelbeleg")) {
                            if (countValue > 1 || countValue == 0) {
                                output.append(Language.getTextfield(session, "einzelbeleg", "Titel"));
                            } else {
                                output.append(Language.getTextfield(session, "einzelbeleg", "Einzelbeleg"));
                            }
                        }

                        output.append(", ");

                        // Ausgabe der Gesamtanzahl
                        String totalCountOutput = output.toString();
                        totalCountOutput = totalCountOutput.substring(0, totalCountOutput.length() - 2); // Letztes Komma entfernen
                        out.println(totalCountOutput);
                    }
                }
            }
        }

        sql = "SELECT DISTINCT " + fieldsString + " FROM " + tablesString + " WHERE (" + conditionsString + ") " + order; //GROUP BY "+fieldsString+"
        //    if (export.equals("liste") || export.equals("browse"))
        //      sql += " LIMIT "+(pageoffset*pageLimit)+", "+pageLimit;

//out.println(sql);
        List<Map> rowlist = SucheDB.getMappedList(sql);

        //    out.println("<p><i>insgesamt <b>"+linecount+"</b> Treffer</i></p>");
        int orderSize = 0;
        for (int z = 0; z < orderV.length; z++) {
            if (orderV[z] != null && !orderV[z].equals("-")) {
                orderSize++;
            }
        }
        boolean[] first = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true};
        String oldValue[] = new String[15];

        // ########## SEITENNAVIGATION #########
        if ("".equals(order)) {
            PrintPagination.printPageNavigation(out, request, pageoffset, pageLimitX, linecount, export);
        }
        // ########## SEITENNAVIGATION #########

        // ########## LISTE/BROWSE ##########
        if ("liste".equals(export) || "browse".equals(export)) {

            String header = "";

            String aufklappen = Language.getTextfield(session, "gast_freie_suche", "EbeneAufklappen");
            String zuklappen = Language.getTextfield(session, "gast_freie_suche", "EbeneZuklappen");

            if (!"true".equals(einzelbelegeVonQuelle) && !"".equals(order)) {
                out.println("<div id=\"level-functions\">");
                out.println("<button class=\"ut-btn \" type=\"button\" aria-label=\"" + aufklappen + "\" onClick=\"expandNextLevel('complete')\"><img src=\"layout/images/open_next_level.png\" alt=\"Aufklappen\" style=\"vertical-align: middle;height: 23px; width: 30px; margin-right: 5px;\">" + aufklappen + "</button>");
                out.println("<button class=\"ut-btn \" type=\"button\" aria-label=\"" + zuklappen + "\" onClick=\"collapseNextLevel('complete')\"><img src=\"layout/images/close_next_level.png\" style=\"vertical-align: middle;height: 23px; width: 30px; margin-right: 5px;\">" + zuklappen + "</button>");
                out.println("</div>");
            }

            header += "<thead class=\"ut-table__header \">";
            header += "<tr class=\"ut-table__row\">";
            int startIndex = 0;
            for (int i = startIndex; i < headlines.size(); i++) {
                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                    header += "<th class=\"ut-table__item ut-table__header__item\" scope=\"col\">";
                    String direction = "";
                    if (order.contains(fieldNames.get(i))) {
                        direction = order.substring(order.indexOf(fieldNames.get(i) + " ") + fieldNames.get(i).length() + 1, Math.min(order.length(), order.indexOf(fieldNames.get(i) + " ") + fieldNames.get(i).length() + 5));
                        if (direction.contains("DESC")) {
                            direction = "DESC";
                        } else {
                            direction = "ASC";
                        }
                    }

                    String parameter = "?neworder=" + fieldNames.get(i);
                    if (direction.equals("ASC")) {
                        parameter += "&newdirection=DESC";
                    } else {
                        parameter += "&newdirection=ASC";
                    }

                    for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
                        String paramName = e.nextElement();
                        if (!paramName.contains("order") && !paramName.equals("newdirection")) {
                            parameter += "&" + paramName + "=" + urlEncode(request.getParameter(paramName));
                        }
                    }

                    header += headlines.get(i);

                    header += "</th>";
                }
            }
            // out.println("</thead>");

            boolean even = false;
            header += "</tr>";
            header += "</thead>";
            out.print("<p id='result-loading'>Suchergebnis lädt...</p>");
            out.print("<ul class=\"mktree\" id=\"complete\" style='display:none'>");

            if (orderSize == 0) {
                out.print("<table class=\"ut-table ut-table--striped ut-table--striped--color-primary-3 \">" + header + "<tbody class=\"ut-table__body \">" + "<tr class=\"ut-table__row\">");
            }

            boolean found = false;

            List<Map<String, String>> searchRes;

            if ("".equals(order)) {
                searchRes = FrontendExtendedSearch.getSearchResult(
                        fieldsString, tablesString, conditionsString, order,
                        fields.toArray(new String[fields.size()]),
                        pageLimitX, offset
                );
            } else {
                searchRes = FrontendExtendedSearch.getSearchResult(fieldsString, tablesString, conditionsString, order, fields.toArray(new String[fields.size()]));
            }

            for (java.util.Map row : searchRes) {
                found = true;

                for (int z = 0; z < orderSize; z++) {
                    int jahr = 0;
                    String jahrV = Utils.safeToString(row.get(orderV[z]));

                    int zeitraum = 0;
                    if (orderV[z].endsWith("Jahr")) {
                        try {
                            zeitraum = Integer.parseInt(request.getParameter("order" + (z + 1) + "zeit"));
                        } catch (Exception ex) {
                            zeitraum = 25;
                        }
                        if (jahrV.isEmpty()) {
                            jahr = 0;
                        } else {
                            jahr = Integer.parseInt(jahrV);
                        }
                        if (zeitraum != 0) {
                            jahr = jahr / zeitraum;
                        }
                        jahrV = String.valueOf(jahr);
                    }

                    if (first[z] || row.get(orderV[z]) != null && !jahrV.equalsIgnoreCase(oldValue[z])) {
                        oldValue[z] = jahrV;
                        if (!first[z]) {
                            out.print("</tbody>");
                            out.print("</table>");
                            for (int z2 = z; z2 < orderSize; z2++) {
                                out.print("</ul></li>");
                            }
                        }
                        first[z] = false;
                        for (int z2 = z + 1; z2 < orderSize; z2++) {
                            first[z2] = true;
                        }

                        if (z > 0) {
                            out.print("<li class=\"liClosed\" style=\"font-size:medium\">");
                        } else {
                            out.print("<li class=\"liOpen\" style=\"font-size:large\">");
                        }

                        String text = "";
                        //uses escapeHTML
                        text = Utils.safeToString(row.get(orderV[z]), "-");

                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            text = Utils.safeToString(row.get("einzelbeleg.Belegform"), "-");
                        }
                        if (orderV[z].startsWith("person.ID")) {
                            text = Utils.safeToString(row.get("person.Standardname"), "-");
                        }
                        if (orderV[z] != null && (orderV[z].startsWith("Zweitglied") || orderV[z].equals("Zweitglied"))) {
                            text = Utils.safeToString(row.get("Zweitglied"), "-");
                        }
                        if (orderV[z] != null && (orderV[z].startsWith("Erstglied") || orderV[z].equals("Erstglied"))) {
                            text = Utils.safeToString(row.get("Erstglied"), "-");
                        }

                        String titel = orderV[z];

                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            titel = "einzelbeleg.Belegform";
                        }
                        if (orderV[z].startsWith("person.ID")) {
                            titel = "person.Standardname";
                        }

                        if (orderV[z].startsWith("Zweitglied")) {
                            titel = "Zweitglied";
                        }
                        if (orderV[z].startsWith("Erstglied")) {
                            titel = "Erstglied";
                        }

                        titel = headlines.get(fieldNames.indexOf(titel));

                        out.print(titel + ": ");
                        boolean link = false;
                        if (export.equals("browse") && !text.equals("-")) {
                            if (orderV[z].equals("einzelbeleg.ID")) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "B" + row.get("einzelbelegID")) + "\">");
                                link = true;
                            } else if ((orderV[z].equals("person.Standardname") || orderV[z].equals("person.ID")) && row.get("personID") != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + row.get("personID")) + "\">");
                                link = true;
                            } else if (orderV[z].equals("perszu.Standardname")) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + row.get("perszuID")) + "\">");
                                link = true;
                            } else if (orderV[z].equals("namenkommentar.PLemma")) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "N" + row.get("namenkommentarID")) + "\">");
                                link = true;
                            } else if (orderV[z].equals("mgh_lemma.MGHLemma")) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "M" + row.get("mgh_lemmaID")) + "\">");
                                link = true;
                            } else if (orderV[z].equals("quelle.Bezeichnung")) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "Q" + row.get("quelleID")) + "\">");
                                link = true;
                            } else if (orderV[z].equals("edition.Zitierweise")) {
                                try {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "E" + row.get("edition.ID")) + "\">");
                                    link = true;
                                } catch (Exception e) {
                                    link = false;
                                }
                            } else if (orderV[z].contains("ID")) {
                                out.print("<a class=\"ut-link\" href=\"" + formular + "?ID=" + row.get(formular + ".ID") + "\">Gehe zu: ");
                                link = true;
                            }
                        }

                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            //already escaped
                            out.print(format(text, "einzelbeleg.Belegform"));
                        } else if (orderV[z].endsWith("Jahr")) {
                            int ja = Integer.parseInt(oldValue[z]);
                            out.print("" + (ja * zeitraum) + "-" + ((ja + 1) * zeitraum - 1));
                        } else {

                            String format = orderV[z];
                            if (orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) {
                                format = "PLemma";
                            }
                            //already escaped
                            out.print(format(text, format));
                        }
                        if (link) {
                            out.print("</a> &nbsp;");
                        } else {
                            out.print(" ");
                        }

                        if (z == orderSize - 1) {
                            out.print("<ul><table class=\"ut-table ut-table--striped ut-table--striped--color-primary-3  \">" + header + "<tbody class=\"ut-table__body \">" + "<tr class=\"ut-table__row\">");
                        } else {
                            out.print("<ul>");
                        }
                    }
                }

                //out.print("<tr class=\"" + (even ? "" : "un") + "even\">");
                // out.print("<tr class=\"" + (even ? "" : "un") + "even ut-table__row\">");
                out.print("<tr class=\"ut-table__row\">");

                if (!formular.equals("favorit") && !formular.equals("freie_suche") && !formular.equals("namenkommentar") && !formular.equals("literatur")) {
                    out.print("<td class=\"ut-table__item ut-table__body__item\" valign=\"top\" align=\"center\"><a class=\"ut-link\" href=\"" + formular + "?ID=" + row.get(formular + ".ID") + "\">Gehe zu</a></td>");
                }

                for (int i = startIndex; i < fieldNames.size(); i++) {
                    if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                        out.print("<td class=\"ut-table__item ut-table__body__item\" valign=\"top\">");
                        if (row.get(fieldNames.get(i)) != null && !DBtoHTML(row.get(fieldNames.get(i))).equals("")) {
                            String cell = DBtoHTML(row.get(fieldNames.get(i)));
                            if (export.equals("browse")) {
                                boolean link = false;
                                if (fieldNames.get(i).contains("einzelbeleg.Belegform")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "B" + row.get("einzelbelegID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("person.Standardname")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + row.get("personID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("perszu.Standardname")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + row.get("perszuID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("namenkommentar.PLemma")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "N" + row.get("namenkommentarID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("mgh_lemma.MGHLemma")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "M" + row.get("mgh_lemmaID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("quelle.Bezeichnung")) {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "Q" + row.get("quelleID")) + "\">");
                                    link = true;
                                } else if (fieldNames.get(i).contains("edition.Zitierweise")) {
                                    link = false;
                                } else if (fieldNames.get(i).contains("ID")) {
                                    out.print("<a class=\"ut-link\" href=\"" + formular + "?ID=" + row.get(formular + ".ID") + "\">Gehe zu: ");
                                    link = true;
                                }
                                if (fieldNames.get(i).endsWith("PLemma") || fieldNames.get(i).equals("Erstglied") || fieldNames.get(i).equals("Zweitglied")) {
                                    cell = format(cell, "PLemma");
                                }
                                out.print(cell);
                                if (link) {
                                    out.print("</a>");
                                }
                            } else {
                                if (fieldNames.get(i).endsWith("PLemma") || fieldNames.get(i).equals("Erstglied") || fieldNames.get(i).equals("Zweitglied")) {
                                    cell = format(cell, "PLemma");
                                }

                                out.print(cell);
                            }
                        } else {
                            out.print("&nbsp;");
                        }
                        out.print("</td>");
                    }
                }
                out.print("</tr>");
                even = !even;
            }

            out.print("</tr>");
            out.print("</tbody>");
            out.print("</table>");

            for (int z = orderSize - 1; z >= 0; z--) {
                out.print("</ul></li>");
            }

            if (!found) {
                out.println(Language.getTextfield(session, "freie_suche", "KeinEintragVorhanden"));
            }

            out.print("</ul>");

            String entry = Language.getTextfield(session, "titel_inc", "Eintrag");
            String entries = Language.getTextfield(session, "suche", "Eintraege");

%>
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function (e) {
        var result_list = document.getElementById("complete");
        var entry = "<%= entry%>";
        var entries = "<%= entries%>";

        try {
            var array = result_list.getElementsByTagName("li");
            for (var j = 0; j < array.length; j++) {
                var ul = array[j].getElementsByTagName("ul")[0].previousSibling;
                var li = array[j].getElementsByTagName("li");
                var count = 0;
                if (li.length < 1)
                    count = (array[j].getElementsByTagName("table")[0].rows.length - 2);
                else
                    count = ul.nextSibling.childNodes.length;
                if (count == 1)
                    ul.data = ul.data + "(" + count + " " + entry + ")";
                else
                    ul.data = ul.data + "(" + count + " " + entries + ")";
            }
        } catch (ex) {
        } finally {
            result_list.style.display = "block";
            document.getElementById("result-loading").style.display = "none";
        }
    });
</script>
<%                }

        // ########## LISTE/BROWSE #########
        // ########## EXCEL #########
        if (export.equals("excel")) {
            PrintWriter excel = new PrintWriter(new FileWriter(this.getServletContext().getRealPath("/") + "print\\output_" + session.getAttribute("Benutzername") + ".csv"));
            for (int z = 0; z < orderSize; z++) {
                String titel = orderV[z];
                if (orderV[z].startsWith("einzelbeleg.ID")) {
                    titel = "einzelbeleg.Belegform";
                }
                titel = headlines.get(fieldNames.indexOf(titel));
                excel.print("\"" + titel + "\";");
            }

            for (int i = 0; i < headlines.size(); i++) {
                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                    excel.print("\"" + headlines.get(i) + "\";");
                }
            }
            excel.println();

            for (Map row : rowlist) {
                for (int z = 0; z < orderSize; z++) {
                    int jahr = 0;
                    String jahrV = Utils.safeToString(row.get(orderV[z]));
                    int zeitraum = 0;
                    if (orderV[z].endsWith("Jahr")) {
                        zeitraum = Integer.parseInt(request.getParameter("order" + (z + 1) + "zeit"));
                        if (jahrV.isEmpty()) {
                            jahr = 0;
                        } else {
                            jahr = Integer.parseInt(jahrV);
                        }
                        jahr = jahr / zeitraum;
                        jahrV = "" + jahr;
                    }

                    if (first[z] || row.get(orderV[z]) != null && !jahrV.equals(oldValue[z])) {
                        oldValue[z] = jahrV;
                        if (!first[z]) {
                            excel.println();
                        }
                        first[z] = false;
                        for (int z2 = z + 1; z2 < orderSize; z2++) {
                            first[z2] = true;
                        }
                        for (int z2 = 0; z2 < z; z2++) {
                            excel.print(";");
                        }

                        String text = Utils.safeToString(row.get(orderV[z]), "-");
                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            text = Utils.safeToString(row.get("einzelbeleg.Belegform"));
                        }

                        String titel = orderV[z];

                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            titel = "einzelbeleg.Belegform";
                        }

                        if (orderV[z].endsWith("Jahr")) {
                            int ja = Integer.parseInt(oldValue[z]);
                            excel.println("\"" + (ja * zeitraum) + "-" + ((ja + 1) * zeitraum - 1) + "\";");
                        } else {
                            String format = orderV[z];
                            if (orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) {
                                format = "PLemma";
                            }
                            excel.println("\"" + text + "\";");
                        }
                    }
                }

                for (int z2 = 0; z2 < orderSize; z2++) {
                    excel.print(";");
                }

                for (String fieldName : fieldNames) {

                    if (fieldName.endsWith("Jahrhundert") || fieldName.endsWith("Jahr") || fieldName.endsWith("Monat") || fieldName.endsWith("Tag") || !order.contains(fieldName)) {

                        Object value = row.get(fieldName);
                        if (value == null || "null".equalsIgnoreCase(Utils.safeToString(value).trim())) {
                            excel.print("\"-\";");
                        } else {
                            excel.print("\"" + row.get(fieldName) + "\";");
                        }
                    }
                }
                excel.println();
            }
            excel.close();
            out.println("<a class=\"ut-link\" href='../../print/output_" + session.getAttribute("Benutzername") + ".csv'>herunterladen</a>");
        }
        // ########## EXCEL #########

        // ########## RTF #########
        if (export.equals("rtf")) {
            Document document = new Document(PageSize.A4.rotate());

            // step 2:
            // we create a writer that listens to the document
            // and directs a RTF-stream to a file
            RtfWriter2.getInstance(document, new FileOutputStream(this.getServletContext().getRealPath("/") + "print/output_" + session.getAttribute("Benutzername") + ".rtf"));

            // step 3: we open the document
            document.open();

            int tabSize = 0;

            for (int i = 0; i < headlines.size(); i++) {
                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                    tabSize++;
                }
            }

            Table tab = new Table(tabSize);
            for (int i = 0; i < headlines.size(); i++) {
                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                    tab.addCell(new Cell(new Paragraph(headlines.get(i), new Font(Font.TIMES_ROMAN, 10, Font.BOLD, new Color(0, 0, 0)))));
                }
            }

            for (Map row : rowlist) {
                for (int z = 0; z < orderSize; z++) {
                    int jahr = 0;
                    String jahrV = Utils.safeToString(row.get(orderV[z]));
                    int zeitraum = 0;
                    if (orderV[z].endsWith("Jahr")) {
                        zeitraum = Integer.parseInt(request.getParameter("order" + (z + 1) + "zeit"));
                        if (jahrV.isEmpty()) {
                            jahr = 0;
                        } else {
                            jahr = Integer.parseInt(jahrV);
                        }
                        jahr = jahr / zeitraum;
                        jahrV = "" + jahr;
                    }

                    if (first[z] || row.get(orderV[z]) != null && !jahrV.equals(oldValue[z])) {
                        oldValue[z] = jahrV;
                        String t = "";
                        if (!first[z]) {
                            document.add(tab);
                            tab = new Table(tabSize);

                            for (int i = 0; i < headlines.size(); i++) {
                                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                                    tab.addCell(new Cell(new Paragraph(headlines.get(i), new Font(Font.TIMES_ROMAN, 10, Font.BOLD, new Color(0, 0, 0)))));
                                }
                            }

                        }
                        first[z] = false;
                        for (int z2 = z + 1; z2 < orderSize; z2++) {
                            first[z2] = true;
                        }
                        for (int z2 = 0; z2 < z; z2++) {
                            t += "\t";
                        }

                        String text = Utils.safeToString(row.get(orderV[z]), "-");
                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            text = Utils.safeToString(row.get("einzelbeleg.Belegform"));
                        }

                        String titel = orderV[z];
                        //     out.println(z + "::" + orderV[z]);

                        if (orderV[z].startsWith("einzelbeleg.ID")) {
                            titel = "einzelbeleg.Belegform";
                        }
                        titel = headlines.get(fieldNames.indexOf(titel));

                        int fontsize = 16 - 2 * z;
                        if (fontsize < 10) {
                            fontsize = 10;
                        }

                        if (orderV[z].endsWith("Jahr")) {
                            int ja = Integer.parseInt(oldValue[z]);
                            document.add(new Paragraph(t + titel + ":" + (ja * zeitraum) + "-" + ((ja + 1) * zeitraum - 1), new Font(Font.TIMES_ROMAN, fontsize, Font.NORMAL, new Color(0, 0, 0))));
                        } else {
                            String format = orderV[z];
                            if (orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) {
                                format = "PLemma";
                            }
                            document.add(new Paragraph(t + titel + ":" + text, new Font(Font.TIMES_ROMAN, fontsize, Font.NORMAL, new Color(0, 0, 0))));
                        }
                    }
                }

                for (int i = 0; i < fieldNames.size(); i++) {

                    if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {

                        Object value = row.get(fieldNames.get(i));
                        if (value == null || "null".equalsIgnoreCase(Utils.safeToString(value).trim())) {
                            tab.addCell(new Cell(new Paragraph("-", new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, new Color(0, 0, 0)))));
                        } else {
                            tab.addCell(new Cell(new Paragraph(Utils.safeToString(row.get(fieldNames.get(i))), new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, new Color(0, 0, 0)))));
                        }
                    }
                }
            }
            document.add(tab);
            document.close();

            out.println("<a class=\"ut-link\" href='../../print/output_" + session.getAttribute("Benutzername") + ".rtf'>herunterladen</a>");
        }
        // ########## rtf #########
        // ########## SEITENNAVIGATION #########
        if ("".equals(order)) {
            PrintPagination.printPageNavigation(out, request, pageoffset, pageLimitX, linecount, export);
        }
        // ########## SEITENNAVIGATION #########
    }
%>
