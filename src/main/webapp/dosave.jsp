<%@ page import="java.text.SimpleDateFormat" isThreadSafe="false" %>
<%@ page import="java.util.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>

<%
    String belegform = "keine Belegform";
    String form = request.getParameter("form");
    int id = -1;
    try {
        if (request.getParameter("ID").equals("-1")) {
            id = SaveHelper.getMaxId(form) + 1;
        } else {
            id = Integer.parseInt(request.getParameter("ID"));
    }
}catch (Exception e) {
        out.println(e);
    }


    if (request.getParameter("speichern") != null && request.getParameter("speichern").equals(Language.getTextfield(session, "navigation", "Speichern"))) {

        boolean exist = SaveHelper.existForm(form, id);
        if (!form.equals("urkunde") && !exist) {
            SaveHelper.insertMetaData(form, id, (int) session.getAttribute("BenutzerID"), (int) session.getAttribute("GruppeID"));
        } else if (!form.equals("urkunde")) {
            SaveHelper.updateMetaData(form, id, (int) session.getAttribute("BenutzerID"));
        }

        List<DatenbankMapping> lst = SaveHelper.getMapping(form);

        for (DatenbankMapping mapping : lst) {
            // Textfield, Textarea, select, addselect
            String feldtyp = mapping.getFeldtyp();
            Boolean isArray = mapping.getArray();
            String zielAttribut = mapping.getZielAttribut();
            String zieltabelle = mapping.getZielTabelle();
            String datenfeld = mapping.getDatenfeld();
            String formularAttribut = mapping.getFormularAttribut();
            String combFeldnamen = mapping.getCombinedFeldnamen();
            String combFeldtyp = mapping.getCombinedFeldtypen();
            if (feldtyp != null && (feldtyp.equals("textfield")
                    || feldtyp.equals("textarea")
                    || feldtyp.equals("select")
                    || feldtyp.equals("addselect")
                    || feldtyp.equals("addselectandtext")
                    || feldtyp.equals("sqlselect"))) {
                // KEIN ARRAY
                if (isArray != null && !isArray && zielAttribut != null && zieltabelle != null) {
                    try {
                        String attrVal = AbstractBase.getSingleField(zielAttribut, zieltabelle, id);
                        // Datensatz ändern
                        if (((request.getParameter(datenfeld) != null && attrVal != null && !attrVal.equals(DBtoDB(request.getParameter(datenfeld))))
                                || (request.getParameter(datenfeld) != null && attrVal == null && !request.getParameter(datenfeld).equals("")))) {

                            Map<String, String> condMap = new HashMap<>();
                            condMap.put("ID", String.valueOf(id));
                            AbstractBase.update(zieltabelle, zielAttribut, request.getParameter(datenfeld).trim(), condMap);
                        } // ENDE Datensatz ändern
                    } catch (Exception e) {
                        if ("QuelleID".equals(zielAttribut)) {
                            throw new IdNotFoundException(Language.getTextfield(session, "error", "QuellenID"));
                        }
                    }

                } // ENDE kein Array
                // ARRAY
                else if (isArray != null && isArray && zielAttribut != null && zieltabelle != null) {
                    for (int i = 0; request.getParameter(datenfeld + "[" + i + "]") != null; i++) {
                        // Prüfen, ob aktueller Eintrag bereits vorhanden
                        if (request.getParameter(datenfeld + "[" + i + "]_entryid") != null) {
                            // Prüfen, ob Datensatz geändert wurde
                            String attrVal = AbstractBase.getSingleField(zielAttribut, zieltabelle, Integer.valueOf(request.getParameter(datenfeld + "[" + i + "]_entryid")));
                            if (attrVal != null && !attrVal.equals(DBtoDB(request.getParameter(datenfeld + "[" + i + "]")))) {

                                String temp_id = request.getParameter(datenfeld + "[" + i + "]_entryid");
                                String temp_value = request.getParameter(datenfeld + "[" + i + "]").trim();

                                Map<String, String> condMap = new HashMap<>();
                                condMap.put("ID", temp_id);
                                AbstractBase.update(zieltabelle, zielAttribut, temp_value, condMap);
                            }
                        } else {
                            // Wenn etwas eingetragen ist, in die Datenbank einfügen
                            if (formularAttribut != null && request.getParameter(datenfeld + "[" + i + "]") != null && !request.getParameter(datenfeld + "[" + i + "]").equals("") && !request.getParameter(datenfeld + "[" + i + "]").equals("-1")) {

                                String tempValue = request.getParameter(datenfeld + "[" + i + "]").trim();

                                Map<String, String> columnsAndValues = new HashMap<>();
                                columnsAndValues.put(formularAttribut, String.valueOf(id));
                                columnsAndValues.put(zielAttribut, tempValue);

                                SaveHelper.insert(zieltabelle, columnsAndValues);
                            }
                        }
                    }
                } // ENDE Array
            } //ENDE Textfield, Textarea, select, addselect
            // checkbox
            else if (feldtyp != null && feldtyp.equals("checkbox") && zielAttribut != null && zieltabelle != null) {
                // KEIN ARRAY
                if (!isArray) {
                    String checkbox = "false";
                    Map<String, String> condMap = new HashMap<>();
                    condMap.put("ID", String.valueOf(id));

                    String temp = checkbox;

                    if (request.getParameter(datenfeld) != null && request.getParameter(datenfeld).equals("on")) {
                        AbstractBase.update(zieltabelle, zielAttribut, "1", condMap);
                    } else {
                        AbstractBase.update(zieltabelle, zielAttribut, "0", condMap);
                    }
                } // ENDE kein Array
            } //ENDE checkbox
            // Datum
            else if (feldtyp != null && feldtyp.equals("date") && zielAttribut != null && zieltabelle != null) {
                // Datensatz geändert?
                String[] zielattributArray = {""};
                String[] combinedFeldnamenArray = {""};

                if (zielAttribut.contains(";")) {
                    zielattributArray = zielAttribut.split(";");
                    for (int j = 0; j < zielattributArray.length; j++) {
                        zielattributArray[j] = zielattributArray[j].trim();
                    }
                }
                String zielattribute = zielattributArray[0];
                for (int i = 1; i < zielattributArray.length; i++) {
                    zielattribute += ", " + zielattributArray[i];
                }

                if (combFeldnamen != null && combFeldnamen.contains(";")) {
                    combinedFeldnamenArray = combFeldnamen.split(";");
                    for (int j = 0; j < combinedFeldnamenArray.length; j++) {
                        combinedFeldnamenArray[j] = combinedFeldnamenArray[j].trim();
                    }
                }

                String zielAttributStr = "";
                for (int i = 0; i < zielattributArray.length; i++) {
                    if (i > 0) {
                        zielAttributStr += ", ";
                    }
                    zielAttributStr += zielattributArray[i] + ", Genauigkeit" + zielattributArray[i];
                }

                List<Map> attributes = SaveHelper.getAttributeMap(zieltabelle, zielAttributStr, id);
                if (attributes.size() > 0) {
                    Map attr = attributes.iterator().next();
                    boolean changed = false;
                    for (int i = 0; i < zielattributArray.length; i++) {
                        if (attr.get(zielattributArray[i]) != null) {
                            if (!attr.get(zielattributArray[i]).equals(request.getParameter(combinedFeldnamenArray[i]))) {

                                changed = true;
                            } else;
                        } else {
                            changed = true;
                        }
                        if (attr.get("Genauigkeit" + zielattributArray[i]) != null) {
                            if (!attr.get("Genauigkeit" + zielattributArray[i]).equals(request.getParameter("Genauigkeit" + combinedFeldnamenArray[i]))) {

                                changed = true;
                            } else;
                        } else {
                            changed = true;
                        }
                    }

                    if (changed) {
                        Map<String, String> attributesAndValuesMap = new HashMap<>();

                        for (int i = 0; i < zielattributArray.length; i++) {
                            String fieldValue = request.getParameter(combinedFeldnamenArray[i]);
                            String genauigkeitValue = request.getParameter("Genauigkeit" + combinedFeldnamenArray[i]);

                            // Überprüfen, ob das Feld leer ist und den Wert entsprechend festlegen
                            if (fieldValue != null && !fieldValue.isEmpty()) {
                                attributesAndValuesMap.put(zielattributArray[i], fieldValue);
                            } else {
                                attributesAndValuesMap.put(zielattributArray[i], null);
                            }

                            // Überprüfen, ob Genauigkeitsfeld leer ist und den Wert entsprechend festlegen
                            if (genauigkeitValue != null && !genauigkeitValue.isEmpty()) {
                                attributesAndValuesMap.put("Genauigkeit" + zielattributArray[i], genauigkeitValue);
                            } else {
                                attributesAndValuesMap.put("Genauigkeit" + zielattributArray[i], "-1");
                            }
                        }

                        Map<String, String> condMap = new HashMap<>();
                        condMap.put("ID", String.valueOf(id));

                        // From the table einzelbeleg and quelle the only exceptions are e.g. QuelleBisJahrhundert = "9Jh2"
                        List<String> stringColumns = new ArrayList<>();
                        stringColumns.add("QuelleBisJahrhundert");
                        stringColumns.add("QuelleVonJahrhundert");
                        stringColumns.add("VonJahrhundert");
                        stringColumns.add("BisJahrhundert");

                        AbstractBase.update(zieltabelle, attributesAndValuesMap, condMap, stringColumns);
                    }
                }
            } // ENDE Datum
            // Bemerkungsfeld
            else if (feldtyp != null && feldtyp.equals("note") && zielAttribut != null && zieltabelle != null) {
                int temp_BenutzerId = Integer.parseInt(session.getAttribute("BenutzerID").toString());
                Map<String, String> condMap = new HashMap<>();
                condMap.put(formularAttribut, String.valueOf(id));
                if (datenfeld.equals("BemerkungAlle")) {
                    condMap.put("GruppeID", null);
                    condMap.put("BenutzerID", null);
                } else if (datenfeld.equals("BemerkungGruppe")) {
                    condMap.put("GruppeID", session.getAttribute("GruppeID").toString());
                    condMap.put("BenutzerID", null);
                } else if (datenfeld.equals("BemerkungPrivat")) {
                    condMap.put("GruppeID", null);
                    condMap.put("BenutzerID", Integer.toString(temp_BenutzerId));
                }

                // Datensatz ändern
                List<Map> attributes = SaveHelper.getAttribute(zieltabelle, zielAttribut, condMap);
                if (formularAttribut != null && zieltabelle != null && (attributes.size() > 0 && request.getParameter(datenfeld) != null)) {

                    if (attributes.size() > 0 && request.getParameter(datenfeld) != null) {
                        Map attr = attributes.iterator().next();
                        if (request.getParameter(datenfeld).equals("")) {
                            SaveHelper.deleteAttribute(zieltabelle, condMap);
                        } // ENDE löschen
                        else if (!request.getParameter(datenfeld).equals("") && !DBtoDB(request.getParameter(datenfeld)).equals(attr.get(zielAttribut))) {

                            AbstractBase.update(zieltabelle, zielAttribut, request.getParameter(datenfeld).trim(), condMap);

                        } // ENDE ändern
                    } // ENDE Datensatz ändern

                } // Datensatz neu
                else if (request.getParameter(datenfeld) != null && !request.getParameter(datenfeld).equals("")) {
                    String field = "";
                    String value = "";
                    if (datenfeld.equals("BemerkungGruppe")) {
                        field = "GruppeID";
                        value = String.valueOf(session.getAttribute("GruppeID"));
                    } else if (datenfeld.equals("BemerkungPrivat")) {
                        field = "BenutzerID";
                        value = String.valueOf(session.getAttribute("BenutzerID"));
                    }
                    if (formularAttribut != null && zieltabelle != null) {

                        Map<String, String> columnsAndValues = new HashMap<>();
                        columnsAndValues.put(zielAttribut, request.getParameter(datenfeld).trim());     //Bemerkung
                        columnsAndValues.put(formularAttribut, String.valueOf(id));             //EinzelbelegID
                        columnsAndValues.put(field, value);                                     //GruppeID oder BenutzerID

                        SaveHelper.insert(zieltabelle, columnsAndValues);
                    }
                } // ENDE Datensatz neu
            } // ENDE Bemerkungsfeld
            // Namenkommentar Editor
            else if (feldtyp != null && feldtyp.equals("nkeditor") && zieltabelle != null) {
                String temp_datenfeld = request.getParameter(datenfeld);

                if (temp_datenfeld != null && temp_datenfeld.equals("on")) {

                    Date d = new Date();
                    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String formattedDate = sf.format(d);

                    Map<String, String> valueMap = new HashMap<>();

                    if (formularAttribut.equals("NamenkommentarID")) {
                        valueMap.put("NamenkommentarID", String.valueOf(id));
                    } else if (formularAttribut.equals("MGHLemmaID")) {
                        valueMap.put("MGHLemmaID", String.valueOf(id));
                    }

                    valueMap.put("BenutzerID", String.valueOf(session.getAttribute("BenutzerID")));
                    valueMap.put("Zeitstempel", formattedDate);
                    SaveHelper.insert(zieltabelle, valueMap);
                }
            } // ENDE NamenkommentarEditor
            // combined
            else if (feldtyp != null && feldtyp.equals("combined") && zieltabelle != null && zielAttribut != null && combFeldnamen != null && combFeldtyp != null) {
            try {
                    String[] zielattributArray = Arrays.stream(zielAttribut.split(";")).map(String::trim).toArray(String[]::new);

                    String[] combinedFeldnamenArray = Arrays.stream(combFeldnamen.split(";")).map(String::trim).toArray(String[]::new);

                    String[] combinedFeldtypenArray = Arrays.stream(combFeldtyp.split(";")).map(String::trim).toArray(String[]::new);
                    if (combinedFeldtypenArray.length == combinedFeldtypenArray.length) {
                        for (int i = 0; request.getParameter(combinedFeldnamenArray[0] + "[" + i + "]") != null; i++) {

                            // Datensatz ändern
                            if (request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid") != null) {
                                boolean aenderung = false;

                                int mapId = Integer.parseInt(request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid"));
                                List<Map> attributes = SaveHelper.getMapField(zieltabelle, mapId);
                                if (attributes.size() > 0) {
                                    Map attr = attributes.iterator().next();
                                    for (int j = 0; j < combinedFeldnamenArray.length; j++) {
                                        if (combinedFeldtypenArray[j].equals("subtable")) {
                                            for (int j2 = 0; request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]" + "[" + j2 + "]") != null; j2++) {
                                                if (request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid") != null) {

                                                    Map<String, String> condMap = new HashMap<>();
                                                    condMap.put("editionID", request.getParameter(combinedFeldnamenArray[j] + "_ed[" + i + "]" + "[" + j2 + "]"));
                                                    condMap.put("ueberlieferungID", request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid"));

                                                    List<Map> ueberlieferungEdition = SaveHelper.getAttribute("ueberlieferung_edition", "*", condMap);

                                                    if (ueberlieferungEdition.size() > 0) {

                                                        String value = request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]" + "[" + j2 + "]");
                                                        Map<String, String> condMap2 = new HashMap<>();
                                                        condMap2.put("editionID", request.getParameter(combinedFeldnamenArray[j] + "_ed[" + i + "]" + "[" + j2 + "]"));
                                                        condMap2.put("ueberlieferungID", request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid"));

                                                        AbstractBase.update("ueberlieferung_edition", "sigle", value, condMap2);

                                                    } else {
                                                        int value_one = Integer.parseInt(request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid"));
                                                        int value_two = Integer.parseInt(request.getParameter(combinedFeldnamenArray[j] + "_ed[" + i + "]" + "[" + j2 + "]"));
                                                        String value_three = request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]" + "[" + j2 + "]").trim();

                                                        Map<String, String> condMap2 = new HashMap<>();
                                                        condMap2.put("UeberlieferungID", String.valueOf(value_one));
                                                        condMap2.put("EditionID", String.valueOf(value_two));
                                                        condMap2.put("Sigle", value_three);

                                                        SaveHelper.insert("ueberlieferung_edition", condMap2);
                                                    }
                                                }
                                            }
                                        } else if (combinedFeldtypenArray[j].equals("textfield")
                                                || combinedFeldtypenArray[j].equals("textarea")
                                                || combinedFeldtypenArray[j].equals("select")
                                                || combinedFeldtypenArray[j].equals("sqlselect")
                                                || combinedFeldtypenArray[j].equals("addselect") || combinedFeldtypenArray[j].equals("addselectandtext")) {
                                            if (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]") != null
                                                    && ((!request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals("") && attr.get(zielattributArray[j]) == null)
                                                    || (!request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals(attr.get(zielattributArray[j]))))) {
                                                aenderung = true;
                                            }
                                        } else if (combinedFeldtypenArray[j].equals("checkbox")) {
                                            if (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]") != null
                                                    && request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals("on")
                                                    && (attr.get(zielattributArray[j]) == null || attr.get(zielattributArray[j]).equals("0"))) {
                                                aenderung = true;
                                            } else if (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]") == null
                                                    && (attr.get(zielattributArray[j]) != null && attr.get(zielattributArray[j]).equals("1"))) {
                                                aenderung = true;
                                            }
                                        }
                                    }
                                }
                                if (aenderung && zieltabelle != null) {
                                    String sql = "UPDATE " + zieltabelle + " SET ";
                                    String ed = "";
                                    for (int j = 0; j < combinedFeldnamenArray.length; j++) {
                                        if (combinedFeldtypenArray[j].equals("textfield")
                                                || combinedFeldtypenArray[j].equals("textarea")
                                                || combinedFeldtypenArray[j].equals("select")
                                                || combinedFeldtypenArray[j].equals("sqlselect")
                                                || combinedFeldtypenArray[j].equals("addselect") || combinedFeldtypenArray[j].equals("addselectandtext")) {
                                            //Dont Quote NULL values
                                            if (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").compareTo("NULL") == 0) {
                                                sql += zielattributArray[j] + " = " + DBtoDB(request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").trim()) + ", ";
                                            } else {
                                                sql += zielattributArray[j] + " = '" + DBtoDB(request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").trim()) + "', ";
                                            }

                                            if (zieltabelle.equals("quelle_inedition") && zielattributArray[j].equals("EditionID")) {
                                                ed = DBtoDB(request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").trim());
                                            }
                                        } else if (combinedFeldtypenArray[j].equals("checkbox")) {
                                            sql += zielattributArray[j] + " = '" + (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]") != null && request.getParameter(combinedFeldnamenArray[j]
                                                    + "[" + i + "]").equals("on") ? "1" : "0") + "', ";
                                        }
                                    }
                                    sql = sql.substring(0, sql.length() - 2);
                                    sql += " WHERE ID='" + request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid") + "';";
                                    String old_ed = "";
                                    if (!ed.equals("")) {
                                        List<Map> editionLst = SaveHelper.getMappedList("select EditionID from quelle_inedition WHERE ID='" + request.getParameter(datenfeld.toLowerCase()
                                                + "[" + i + "]_entryid") + "';");

                                        if (editionLst.size() > 0) {
                                            old_ed = editionLst.get(editionLst.size() - 1).get("EditionID").toString();
                                        }
                                    }
                                    SaveHelper.insertOrUpdateSql(sql);
                                    if (!ed.equals("")) {
                                        SaveHelper.insertOrUpdateSql("Update ueberlieferung_edition set EditionID='" + ed + "' where EditionID=" + old_ed
                                                + " and UeberlieferungID in (select h_u.ID from handschrift_ueberlieferung h_u, quelle_inedition q_i where q_i.ID="
                                                + request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid").trim() + " and q_i.QuelleID=h_u.QuelleID)"
                                        );

                                        SaveHelper.insertOrUpdateSql("Update einzelbeleg_textkritik set EditionID='" + ed + "' where EditionID=" + old_ed
                                                + " and HandschriftID in (select h_u.ID from handschrift_ueberlieferung h_u, quelle_inedition q_i where q_i.ID=" + request.getParameter(datenfeld.toLowerCase().trim()
                                                        + "[" + i + "]_entryid") + " and q_i.QuelleID=h_u.QuelleID)"
                                        );

                                        SaveHelper.insertOrUpdateSql(" Update einzelbeleg set EditionID ='" + ed + "' where EditionID=" + old_ed
                                                + " and ID in (select e_t.EinzelbelegID from handschrift_ueberlieferung h_u, quelle_inedition q_i, einzelbeleg_textkritik e_t where e_t.HandschriftID=h_u.ID and q_i.ID="
                                                + request.getParameter(datenfeld.toLowerCase() + "[" + i + "]_entryid").trim() + " and q_i.QuelleID=h_u.QuelleID)"
                                        );
                                    }
                                }
                            } // Datensatz neu
                            else if (zieltabelle != null && formularAttribut != null) {
                                boolean aenderung = false;
                                for (int j = 0; j < combinedFeldnamenArray.length; j++) {
                                    if (request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]") != null
                                            && !request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals("")
                                            && !request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals("-1")
                                            && !request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]").equals("NULL")) {
                                        aenderung = true;
                                    }
                                }
                                if (aenderung) {
                                    String sql = "INSERT INTO " + zieltabelle + " SET " + formularAttribut + " = '" + id + "'";
                                    for (int j = 0; j < combinedFeldnamenArray.length; j++) {
                                        if (!combinedFeldnamenArray[j].equals("")) {
                                            if (combinedFeldtypenArray[j].equals("textfield")
                                                    || combinedFeldtypenArray[j].equals("textarea")
                                                    || combinedFeldtypenArray[j].equals("select")
                                                    || combinedFeldtypenArray[j].equals("sqlselect")
                                                    || combinedFeldtypenArray[j].equals("addselect") || combinedFeldtypenArray[j].equals("addselectandtext")) {

                                                String parameterValue = request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]");
                                                if (parameterValue != null) {
                                                    if (parameterValue.equals("NULL")) {
                                                        sql += ", " + zielattributArray[j] + " = NULL";
                                                    } else {
                                                        sql += ", " + zielattributArray[j] + " = '" + DBtoDB(parameterValue.trim()) + "'";
                                                    }
                                                }
                                            } else if (combinedFeldtypenArray[j].equals("checkbox")) {
                                                String checkboxValue = request.getParameter(combinedFeldnamenArray[j] + "[" + i + "]");
                                                if (checkboxValue != null) {
                                                    sql += ", " + zielattributArray[j] + " = '" + (checkboxValue.equals("on") ? "1" : "0") + "'";
                                                }
                                            }
                                        }
                                    }
                                    SaveHelper.insertOrUpdateSql(sql);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    if (e.getMessage() != null && e.getMessage().contains("NamenkommentarID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "PhilologischerKommentarID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("MGHLemmaID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "LemmaID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("PersonID") && e.getMessage().contains("EinzelbelegID")) {

                        int personIdIndex = e.getMessage().indexOf("PersonID");
                        int einzelbelegIdIndex = e.getMessage().indexOf("EinzelbelegID");

                        if (personIdIndex < einzelbelegIdIndex) {
                            throw new IdNotFoundException(Language.getTextfield(session, "error", "EinzelbelegID"));
                        } else if (personIdIndex > einzelbelegIdIndex) {
                            throw new IdNotFoundException(Language.getTextfield(session, "error", "PersonID"));
                        }
                    } else if (e.getMessage() != null && e.getMessage().contains("PersonID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "PersonID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("PersonIDzu")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "PersonID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("EinzelbelegID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "EinzelbelegID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("quelle_inedition") && e.getMessage().contains("EditionID") && e.getMessage().contains("QuelleID") && e.getMessage().contains("Seiten") && e.getMessage().contains("Nummer")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "EditionID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("EditionID") && e.getMessage().contains("QuelleID") && e.getMessage().contains("Seiten") && e.getMessage().contains("Nummer")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "QuellenID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("EditionID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "EditionID"));
                    } else if (e.getMessage() != null && e.getMessage().contains("QuelleID")) {
                        throw new IdNotFoundException(Language.getTextfield(session, "error", "QuellenID"));
                    }
                }
            } // ENDE combined
        } // ENDE while

        if (request.getParameter("ID").equals("-1") && !form.equals("urkunde")) {
%>


<script language="JavaScript">
<!--
    location.replace('?ID=<%= id%>');
//-->
</script>
<noscript></noscript>
<%
        }
    } // ENDE if (speichern)

if (form.equals("einzelbeleg")) {

try{



Einzelbeleg lastEinzelbeleg = EinzelbelegDB.getById(id);
boolean hasLemma = lastEinzelbeleg.getMghLemma().size() > 0;
boolean hasZusatzNamenKommentar = lastEinzelbeleg.getNamenKommentar().size() > 0;
belegform = lastEinzelbeleg.getBelegform(); // z.B. Sebastianus


if (!hasZusatzNamenKommentar) { %>

    <script>
        $(function () {
            var einzelbelegID = <%= id %>;

            let ajaxUrl = '<%= Utils.getAjaxUrl(request) %>';

            // GET-Anfrage zum DetectZusatzNamenKommentar
            $.ajax({
                type: "GET",
                url: ajaxUrl,
                data: { action: "detectZusatzNamenKommentar", EinzelbelegID: einzelbelegID },
                dataType: "json",
                success: function (data) {

                    if (data.outputListZ && !<%= hasZusatzNamenKommentar %>) {
                        var output = data.outputListZ.join('\n');
                        if (confirm(output)) {
                            var postData = { action: "confirmZusatzNamenKommentar", EinzelbelegID: einzelbelegID };
                            if (data.namenkommentarID) {
                                postData.namenkommentarID = data.namenkommentarID;
                            }

                            $.ajax({
                                type: "POST",
                                url: ajaxUrl,
                                data: postData,
                                dataType: "json",
                                success: function (response) {
                                    location.reload();
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    console.error('Post Error:', textStatus, errorThrown);
                                }
                            });
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.error('Get Error:', textStatus, errorThrown);
                }
            });
        });
</script>
    <% } %>

        <% if (!hasLemma) { %>

            <script>
                $(function () {
                    var einzelbelegID = <%= id %>;

                    let ajaxUrl = '<%= Utils.getAjaxUrl(request) %>';

                    // GET-Anfrage zum DetectLemma
                    $.ajax({
                        type: "GET",
                        url: ajaxUrl,
                        data: { action: "detectLemma", EinzelbelegID: einzelbelegID },
                        dataType: "json",
                        success: function (data) {

                            // Assuming the server response is a JSON object with the key "outputList" and optionally "lemmaID"
                            if (data.outputListL && !<%= hasLemma %>) {
                                var output = data.outputListL.join('\n');
                                if (confirm(output)) {
                                    // POST-Anfrage zum ConfirmLemma
                                    var postData = { action: "confirmLemma", EinzelbelegID: einzelbelegID };
                                    if (data.lemmaID) {
                                        postData.lemmaID = data.lemmaID;
                                    }

                                    $.ajax({
                                        type: "POST",
                                        url: ajaxUrl,
                                        data: postData,
                                        dataType: "json",
                                        success: function (response) {
                                            location.reload();
                                        },
                                        error: function (jqXHR, textStatus, errorThrown) {
                                            console.error('Post Error:', textStatus, errorThrown);
                                        }
                                    });
                                }
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.error('Get Error:', textStatus, errorThrown);
                        }
                    });
                });
</script>


            <% } }catch(Exception e){

%>

<script>

        console.log("<%= e %>")

</script>

<%

}
}

%>
