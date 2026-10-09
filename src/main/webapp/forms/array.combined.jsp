<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.ArrayList" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%
    if (feldtyp.equals("combined") && array) {

        String doCount = String.valueOf(request.getParameter("CountRow"));

        List<Map> rowlist = AbstractBase.getMappedList("SELECT * FROM " + zielTabelle
                + " WHERE " + formularAttribut + "=\"" + id + "\"");

        if ((rowlist != null && !rowlist.isEmpty()) || !isReadOnly) {

            int count = 0;
            out.println("<table class=\"ut-table\" " + (isReadOnly ? "width=\"100%\"" : "") + ">\n");
            out.println("<tbody class=\"ut-table__body\">");
            out.println("<tr class=\"ut-table__row\">\n");
            for (int i = 0; i < combinedAnzeigenamen.length; i++) {

                if (!isReadOnly || combinedFeldtypen[i].equals("sqlselect")
                        || combinedFeldtypen[i].equals("select")
                        || combinedFeldtypen[i].equals("textfield")
                        || combinedFeldtypen[i].equals("textarea")
                        || combinedFeldtypen[i].contains("link")
                        || combinedFeldtypen[i].contains("info")
                        || combinedFeldtypen[i].contains("list")) {
                    out.println("<th>");
                    out.println(combinedAnzeigenamen[i] + "\n");
                    out.println("</th>");
                }
            }
            out.println("</tr>\n");

            String[] zielattributArray = zielAttribut.split(";");
            for (int i = 0; i < zielattributArray.length; i++) {
                zielattributArray[i] = zielattributArray[i].trim();
            }

            if (auswahlherkunft == null) {
                auswahlherkunft = "";
            }
            String[] auswahlherkunftArray = auswahlherkunft.split(";");
            for (int i = 0; i < auswahlherkunftArray.length; i++) {
                auswahlherkunftArray[i] = auswahlherkunftArray[i].trim();
            }

            boolean repeat = true;
            boolean alreadyOne = false;
            int i = 0;
            while (repeat) {
                Map row = null;
                if (i < rowlist.size()) {
                    row = rowlist.get(i);
                    out.println("<input type=\"hidden\" name=\""
                            + datenfeld.toLowerCase() + "[" + i
                            + "]_entryid\" value=\"" + String.valueOf(row.get("ID"))
                            + "\">");
                    alreadyOne = true;
                } else {
                    repeat = false;
                }

                if("noCount".equals(doCount)){
                    out.println("<tr class=\"ut-table__row\">");
                }else{
                    count++;
                    if (count % 2 == 0) {
                        out.println("<tr>");
                    } else {
                        out.println("<tr bgcolor='#AACCDD'>");
                    }
                }

                for (int j = 0; j < combinedFeldtypen.length; j++) {
                    if (combinedFeldtypen[j].equals("dateinfo")
                            || combinedFeldtypen[j].equals("addselect")) {
                        out.println("<td class=\"ut-table__item ut-table__body__item\" nowrap>");
                    } else {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">");
                    }

                   if (combinedFeldtypen[j].equals("textfield")) {
                        if (!isReadOnly) {
                            out.println("<input name=\""
                                    + combinedFeldnamen[j]
                                    + "["
                                    + i
                                    + "]\""
                                    + " value=\""
                                    + (row != null && row.get(zielattributArray[j]) != null ? DBtoHTML(String.valueOf(row
                                    .get(zielattributArray[j])))
                                    : "")
                                    + "\""
                                    + " maxlength=\""
                                    + AbstractBase.getMaxCharacterLength(zielTabelle, zielattributArray[j])
                                    + "\" "
                                    + (combinedFeldnamen[j]
                                            .endsWith("ID") ? " size=\"5\""
                                    : " size=\"10\"")
                                    + " />");
                        } else {
                            out.println(row != null && row
                                    .get(zielattributArray[j]) != null ? DBtoHTML(String.valueOf(row
                                    .get(zielattributArray[j])))
                                    : (alreadyOne ? "" : "-"));
                        }
                    } else if (combinedFeldtypen[j].equals("textarea")) {
                        if (!isReadOnly) {
                            out.println("<textarea name=\"" + combinedFeldnamen[j]
                                    + "["
                                    + i
                                    + "]\"" + disabled + ">"
                                    + (row != null && row.get(zielattributArray[j]) != null ? DBtoHTML(String.valueOf(row
                                    .get(zielattributArray[j])))
                                    : "")
                                    + "</textarea>");
                        } else {
                            out.println((row != null && row
                                    .get(zielattributArray[j]) != null ? DBtoHTML(String.valueOf(row
                                    .get(zielattributArray[j])))
                                    : (alreadyOne ? "" : "-")));
                        }
                    } else if (combinedFeldtypen[j].equals("addselect")) {
                        int selected = (row != null && row.get(zielattributArray[j]) != null ? Integer.parseInt(String.valueOf(row
                                .get(zielattributArray[j])))
                                : -1);
                        out.println("<select name=\""
                                + combinedFeldnamen[j] + "[" + i
                                + "]\" id=\"" + combinedFeldnamen[j]
                                + "[" + i + "]\" style=\"width:6em\">");

                        List<Map> rowlist2 = AbstractBase.getMappedList("SELECT * FROM "
                                + auswahlherkunftArray[j]
                                + " ORDER BY Bezeichnung ASC");
                        for (Map row2 : rowlist2) {
                            out.println("<option value=\""
                                    + String.valueOf(row2.get("ID"))
                                    + "\" "
                                    + (Integer.parseInt(String.valueOf(row2.get("ID"))) == selected ? "selected"
                                    : "")
                                    + ">"
                                    + Utils.safeToString(row2
                                            .get("Bezeichnung"))
                                    + "</option>");
                        }
                        out.print("</select>");
                        out.println("<a href=\"javascript:popup('addselect', this, '"
                                + auswahlherkunftArray[j]
                                        .substring(10)
                                + "', '"
                                + combinedFeldnamen[j]
                                + "["
                                + i
                                + "]', '');\">"
                                + txt_newentry + "</a>");

                    } else if (combinedFeldtypen[j].equals("addselectandtext")) {

                        out.println("<select name=\""
                                + combinedFeldnamen[j] + "[" + i
                                + "]\" id=\""
                                + combinedFeldnamen[j] + "[" + i
                                + "]\" style=\"width:6em\">");

                        List<Map> rowlist2 = AbstractBase.getMappedList(
                                "SELECT * FROM "
                                + auswahlherkunftArray[j]
                                + " ORDER BY Bezeichnung ASC");
                        for (Map row2 : rowlist2) {
                            out.println("<option value=\""
                                    + String.valueOf(row2.get("ID"))
                                    + "\""
                                    + (Integer.parseInt(String.valueOf(row2.get("ID"))) == -1 ? "selected"
                                    : "")
                                    + ">"
                                    + Utils.safeToString(row2.get("Bezeichnung"))
                                    + "</option>");
                        }
                        out.print("</select>");
                        out.println("<a href=\"javascript:popup('addselect', this, '"
                                + auswahlherkunftArray[j]
                                        .substring(10)
                                + "', '"
                                + combinedFeldnamen[j]
                                + "["
                                + i
                                + "]', '');\">"
                                + txt_newentry + "</a>");

                    } else if (combinedFeldtypen[j].equals("select")) {
                        if (!isReadOnly) {
                            out.println("<select name=\""
                                    + combinedFeldnamen[j] + "[" + i
                                    + "]\" style=\"width:8em\">");
                        }

                        List<Map> rowlist2 = AbstractBase.getMappedList(
                                "SELECT * FROM "
                                + auswahlherkunftArray[j]
                                + " ORDER BY Bezeichnung ASC");
                        int selected = (row != null && row.get(zielattributArray[j]) != null ? Integer.parseInt(String.valueOf(row
                                .get(zielattributArray[j])))
                                : -1);
                        for (Map row2 : rowlist2) {
                            int currentId = Integer.parseInt(String.valueOf(row2.get("ID")));
                            if (!isReadOnly) {
                                out
                                        .println("<option value='"
                                                + String.valueOf(row2.get("ID"))
                                                + "' "
                                                + (currentId == selected ? "selected"
                                                        : "")
                                                + ">"
                                                + Utils.safeToString(row2.get("Bezeichnung"))
                                                + "</option>");
                            } else if (currentId == selected) {
                                if (repeat) {
                                    out.println(Utils.safeToString(row2.get("Bezeichnung")));
                                } else if (!alreadyOne) {
                                    out.println("-");
                                }
                            }
                        }

                        if (!isReadOnly) {
                            out.println("</select>");
                        }
                    } else if (combinedFeldtypen[j].equals("subtable")) {
                        if (row != null) {
                            out.println("<table>");
                            String sql = "SELECT edition.ID, edition.Zitierweise Bezeichnung FROM quelle_inedition, edition WHERE quelle_inedition.QuelleID=  "
                                    + String.valueOf(row.get("QuelleID"))
                                    + " AND quelle_inedition.editionID=edition.ID ORDER BY Bezeichnung ASC";

                            List<Map> rowlist2 = AbstractBase.getMappedList(sql);

                            int i2 = 0;

                            for (Map row2 : rowlist2) {
                                Map row3 = AbstractBase.getMappedRow("SELECT Sigle FROM ueberlieferung_edition WHERE ueberlieferung_edition.editionID="
                                        + String.valueOf(row2.get("ID"))
                                        + " AND ueberlieferung_edition.ueberlieferungID="
                                        + String.valueOf(row.get("ID")));

                                out.println("<tr><td><a href=\"edition?ID="
                                        + String.valueOf(row2.get("ID"))
                                        + "\">"
                                        + Utils.safeToString(row2.get("Bezeichnung"))
                                        + "</a><input type=\"hidden\" name=\""
                                        + combinedFeldnamen[j]
                                        + "_ed["
                                        + i
                                        + "]["
                                        + i2
                                        + "]\""
                                        + " value=\""
                                        + String.valueOf(row2.get("ID"))
                                        + "\"/></td><td><input name=\""
                                        + combinedFeldnamen[j]
                                        + "["
                                        + i
                                        + "]["
                                        + i2
                                        + "]\""
                                        + " value=\""
                                        + DBtoHTML(row3 != null && row3.get("Sigle") != null ? String.valueOf(row3.get("Sigle")) : "")
                                        + "\""
                                        + " maxlength=\""
                                        + "\" "
                                        + (combinedFeldnamen[j]
                                                .endsWith("ID") ? " size=\"5\""
                                        : " size=\"10\"")
                                        + " /></td></tr>");
                                i2++;
                            }
                            out.println("</table>");
                        }

                    } else if (combinedFeldtypen[j].equals("checkbox")) {
                        if (!isReadOnly) {
                            out.println("<input name=\""
                                    + combinedFeldnamen[j]
                                    + "["
                                    + i
                                    + "]\""
                                    + " type=\"checkbox\""
                                    + (row != null && row.get(zielattributArray[j]) != null && Integer.parseInt(String.valueOf(row.get(zielattributArray[j]))) == 1 ? " checked"
                                    : "") + " />");
                        }

                    } else if (combinedFeldtypen[j].equals("sqlselect")) {
                        String sql = "";

                        if (!isReadOnly) {
                            out.println("<select name=\""
                                    + combinedFeldnamen[j] + "[" + i
                                    + "]\" style=\"width:8em\">");
                        }

                        if (combinedFeldnamen[j].equals("TKHandschrift") && row != null && row.get("EditionID") != null) {
                            sql = "SELECT handschrift_ueberlieferung.ID, ueberlieferung_edition.Sigle Bezeichnung FROM handschrift_ueberlieferung, einzelbeleg, ueberlieferung_edition WHERE handschrift_ueberlieferung.ID=ueberlieferung_edition.UeberlieferungID and ueberlieferung_edition.EditionID= "
                                    + String.valueOf(row.get("EditionID"))
                                    + " AND handschrift_ueberlieferung.QuelleID=einzelbeleg.QuelleID AND einzelbeleg.ID="
                                    + id
                                    + " ORDER BY Bezeichnung ASC";
                        }
                        if (combinedFeldnamen[j]
                                .equals("TKEditionID")) {
                            sql = "SELECT edition.ID, edition.Zitierweise Bezeichnung FROM quelle_inedition, edition, einzelbeleg WHERE quelle_inedition.QuelleID = einzelbeleg.QuelleID AND quelle_inedition.editionID=edition.ID AND einzelbeleg.ID = "
                                    + id
                                    + " ORDER BY Bezeichnung ASC";
                        }
                        if (combinedFeldnamen[j].equals("HSEditionID") && row != null && row.get("QuelleID") != null) {
                            sql = "SELECT edition.ID, edition.Titel Bezeichnung FROM quelle_inedition, edition WHERE quelle_inedition.QuelleID=  "
                                    + String.valueOf(row.get("QuelleID"))
                                    + " AND quelle_inedition.editionID=edition.ID ORDER BY Bezeichnung ASC";
                        }

                        List<Map> rowlist2 = new ArrayList<Map>();
                        if (!sql.equals("")) {
                            rowlist2 = AbstractBase.getMappedList(sql);
                        }
                        int selected = (row != null && row.get(zielattributArray[j]) != null ? Integer.parseInt(String.valueOf(row
                                .get(zielattributArray[j])))
                                : -1);
                        //Map stores the options fields of a select form
                        //key: the value of the option
                        //value: selected attribute of the option
                        Map<Integer, String> selectForm = new HashMap<Integer, String>();
                        //init
                        selectForm.put(0, "");
                        selectForm.put(-1, "");
                        //assign
                        if (selected == 0) {
                            selectForm.put(0, "selected");
                        } else if (selected == -1) {
                            selectForm.put(-1, "selected");
                        }

                        if (!isReadOnly) {
                            out.println("<option value=\"NULL\" " + selectForm.get(-1) + ">nicht bearbeitet</option>");
                        }

                        for (Map row2 : rowlist2) {
                            // Sicherstellen, dass die Bezeichnung nicht null ist
                            String bezeichnung = Utils.safeToString(row2.get("Bezeichnung"));
                            String id_temp = String.valueOf(row2.get("ID"));

                            if (!id_temp.isEmpty() && !bezeichnung.isEmpty()) {
                                if (!isReadOnly) {
                                    out.println(String.format("<option value='%s' %s>%s</option>",
                                            id_temp,
                                            (Integer.parseInt(id_temp) == selected ? "selected" : ""),
                                            bezeichnung));
                                }
                            } else if (Integer.parseInt(id_temp) == selected && combinedFeldnamen[j].equals("TKHandschrift")) {
                                // Ausgabe nur der Bezeichnung, wenn `isReadOnly` true ist und `TKHandschrift` gew�hlt wurde
                                if (!bezeichnung.isEmpty()) {
                                    out.println(bezeichnung);
                                }
                            }
                        }

                        out.println("</select>");
                    } else if (combinedFeldtypen[j].equals("checkbox")) {
                        if (!isReadOnly) {
                            out.println("<input name=\""
                                    + combinedFeldnamen[j]
                                    + "["
                                    + i
                                    + "]\""
                                    + " type=\"checkbox\""
                                    + ((Integer.parseInt(String.valueOf(row.get(zielattributArray[j]))) == 1) ? " checked"
                                    : "") + " />");
                        }
                    } else if (combinedFeldtypen[j].startsWith("link")) {
                        String[] fields = combinedFeldtypen[j]
                                .substring(
                                        combinedFeldtypen[j]
                                                .lastIndexOf('(') + 1,
                                        combinedFeldtypen[j]
                                                .lastIndexOf(')'))
                                .split(",");

                        Map row2 = null;
                        if (row != null && row.get(fields[1]) != null) {
                            row2 = AbstractBase.getMappedRow("SELECT "
                                    + fields[2] + " FROM "
                                    + fields[0] + " WHERE ID="
                                    + String.valueOf(row.get(fields[1])));
                        }

                        if (row2 != null) {

                            String add = fields[0];
                            if (add.equals("mgh_lemma")) {
                                add = "mghlemma";
                            }

                            out.println("<a href=\""
                                    + add
                                    + "?ID="
                                    + String.valueOf(row.get(fields[1]))
                                    + "\">");
                            out.println(row2
                                    .get(fields[2]) != null ? DBtoHTML(String.valueOf(row2
                                    .get(fields[2])))
                                    : "Zum Datensatz");
                            out.println("</a>");
                        }
                    } else if (combinedFeldtypen[j].startsWith("info")) {
                        String[] fields = combinedFeldtypen[j]
                                .substring(
                                        combinedFeldtypen[j]
                                                .lastIndexOf('(') + 1,
                                        combinedFeldtypen[j]
                                                .lastIndexOf(')'))
                                .split(",");

                        if (row != null) {
                            Map row2 = AbstractBase.getMappedRow("SELECT "
                                    + fields[2] + " FROM "
                                    + fields[0] + " WHERE ID="
                                    + String.valueOf(row.get(fields[1])));

                            if (row2 != null) {
                                out.println(Utils.safeToString(row2.get(fields[2])));
                            }
                        }
                    } else if (combinedFeldtypen[j].startsWith("list")) {
                        String[] fields = combinedFeldtypen[j]
                                .substring(
                                        combinedFeldtypen[j]
                                                .lastIndexOf('(') + 1,
                                        combinedFeldtypen[j]
                                                .lastIndexOf(')'))
                                .split(",");

                        if (row != null) {
                            List<Map> rowlist2 = AbstractBase.getMappedList("SELECT Bezeichnung FROM selektion_"
                                    + fields[0] + " sel, einzelbeleg_hat" + fields[0] + " zt WHERE zt."
                                    + fields[0] + "ID=sel.ID AND zt." + fields[1] + "="
                                    + String.valueOf(row.get(fields[1])));
                            for (Map row2 : rowlist2) {
                                out.println(Utils.safeToString(row2.get("Bezeichnung")));
                                out.println("<br>");
                            }
                        }
                    } else if (combinedFeldtypen[j].startsWith("date(")) {
                        String[] fields = combinedFeldtypen[j]
                                .substring(
                                        combinedFeldtypen[j]
                                                .lastIndexOf('(') + 1,
                                        combinedFeldtypen[j]
                                                .lastIndexOf(')'))
                                .split(",");

                        if (repeat) {

                            try {
                                List<Map> rowlist2 = AbstractBase.getMappedList("SELECT e.VonTag, e.VonMonat, e.VonJahr, e.VonJahrhundert,"
                                        + " e.BisTag, e.BisMonat, e.BisJahr, e.BisJahrhundert, ehp." + fields[1] + " "
                                        + "FROM " + fields[0] + " e "
                                        + "LEFT JOIN " + fields[2] + " ehp ON e.ID = ehp." + fields[1] + " "
                                        + "WHERE e.ID = " + (Integer) row.get(fields[1]) + ";");

                                String vonTag = "";
                                String vonMonat = "";
                                String vonJahr = "";
                                String vonJhdt = "";

                                String bisTag = "";
                                String bisMonat = "";
                                String bisJahr = "";
                                String bisJhdt = "";

                                for (Map<String, Object> rowtemp : rowlist2) {

                                    vonTag = Utils.safeToString(rowtemp.get("VonTag"));
                                    vonMonat = Utils.safeToString(rowtemp.get("VonMonat"));
                                    vonJahr = Utils.safeToString(rowtemp.get("VonJahr"));
                                    vonJhdt = Utils.safeToString(rowtemp.get("VonJahrhundert"));

                                    bisTag = Utils.safeToString(rowtemp.get("BisTag"));
                                    bisMonat = Utils.safeToString(rowtemp.get("BisMonat"));
                                    bisJahr = Utils.safeToString(rowtemp.get("BisJahr"));
                                    bisJhdt = Utils.safeToString(rowtemp.get("BisJahrhundert"));
                                }

                                String von = "";

                                if (vonTag != null && !vonTag.equals("")
                                        && !vonTag.equals("0")) {
                                    von = vonTag + ".";
                                }
                                if (vonMonat != null && !vonMonat.equals("")
                                        && !vonMonat.equals("0")) {
                                    von = von + vonMonat + ".";
                                }
                                if (vonJahr != null && !vonJahr.equals("")
                                        && !vonJahr.equals("0")) {
                                    von = von + vonJahr;
                                }
                                if (von.equals("") && vonJhdt != null) {
                                    von = vonJhdt;
                                }

                                if (!von.equals("") && !von.contains("J") && !von.equals("0")
                                        && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                                        && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                                        && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                                    von = von + " Jh.";
                                }

                                String bis = "";

                                if (bisTag != null && !bisTag.equals("")
                                        && !bisTag.equals("0")) {
                                    bis = bisTag + ".";
                                }
                                if (bisMonat != null && !bisMonat.equals("")
                                        && !bisMonat.equals("0")) {
                                    bis = bis + bisMonat + ".";
                                }
                                if (bisJahr != null && !bisJahr.equals("")
                                        && !bisJahr.equals("0")) {
                                    bis = bis + bisJahr;
                                }
                                if (bis.equals("") && bisJhdt != null) {
                                    bis = bisJhdt;
                                }

                                if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                                        && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                                        && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                                        && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                                    bis = bis + " Jh.";
                                }

                                if (!bis.equals(von) && !bis.equals("")) {
                                    out.println(von + " - " + bis);
                                } else {
                                    out.println(von);
                                }

                            } catch (Exception e) {
                                out.println(e);
                            }
                        }

                    } else if (combinedFeldtypen[j].startsWith("search")) {
                        String[] fields = combinedFeldtypen[j]
                                .substring(
                                        combinedFeldtypen[j]
                                                .lastIndexOf('(') + 1,
                                        combinedFeldtypen[j]
                                                .lastIndexOf(')'))
                                .split(",");
                        if (!isReadOnly) {
                            out
                                    .println("<a href=\"javascript:popup('search', this, '"
                                            + fields[0]
                                            + "', '"
                                            + fields[2]
                                            + "["
                                            + i
                                            + "]', '"
                                            + fields[1]
                                            + "');\">"
                                            + txt_search
                                            + "</a>");
                        }
                    } else if (combinedFeldtypen[j].equals("dateinfo")) {
                        if (row != null) {
                            out.println("<label id=\"quelleDate["
                                    + i
                                    + "]\">");
                            if (row.get(combinedFeldnamen[j] + "VonJahr") != null) {
                                out.print(Utils.safeToString(row.get(combinedFeldnamen[j] + "VonJahr")));
                            } else {
                                out.println("0");
                            }
                            out.print("(");
                            if (row.get(combinedFeldnamen[j] + "VonJahrhundert") != null) {
                                out.print(Utils.safeToString(row.get(combinedFeldnamen[j] + "VonJahrhundert")));
                            } else {
                                out.println("0");
                            }
                            out.print(". Jhd)-");
                            if (row.get(combinedFeldnamen[j] + "BisJahr") != null) {
                                out.print(Utils.safeToString(row.get(combinedFeldnamen[j] + "BisJahr")));
                            } else {
                                out.println("0");
                            }
                            out.print("(");
                            if (row.get(combinedFeldnamen[j] + "BisJahrhundert") != null) {
                                out.print(Utils.safeToString(row.get(combinedFeldnamen[j] + "BisJahrhundert")));
                            } else {
                                out.println("0");
                            }
                            out.println(". Jhd)</label>");

                            out.println("<a href=\"javascript:popup('changedate', this, '', 'quelleDate["
                                    + i
                                    + "]', '");
                            if (row.get("ID") != null) {
                                out.print(Utils.safeToString(row.get("ID")));
                            }
                            out.println("');\"><img src=\"layout/icons/calendar.gif\" border=0></a>");
                        }
                    } else {
                        out.println("folgt!");
                    }
                    out.println("</td>");
                }
                if (!isReadOnly) {
                    out.println("<td>");
                    if (row != null) {
                        String href = "javascript:deleteEntry('"
                                + zielTabelle + "', '" + String.valueOf(row.get("ID"))
                                + "', '" + returnpage + "', '" + id + "');";
                        out.println("<a href=\"" + href + "\">");
                        out.println(txt_delete);
                        out.println("</a>");
                    }
                    out.println("</td>");
                }
                /*      else{
                                        out.println("<td>");
                                        out.println("<input type=\"checkbox\" name=\"" + beschriftung + "Speichern\" value=\"1\">Hinzuf&uuml;gen<br>");
                                        out.println("</td>");
                                      }*/
                out.println("</tr>");
                i++;
            }
            out.println("</tbody>");
            out.println("</table>\n");
        }
    }
%>
