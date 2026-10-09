<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>

<%
    if (feldtyp.equals("date") && !array) {
        out.println("<table>\n");
        out.println("<tr>\n");
        for (int i = 0; i < combinedAnzeigenamen.length; i++) {
            if (!isReadOnly) {
                out.println("<th width=\"90\">" + combinedAnzeigenamen[i] + "</th>\n");
            }
        }
        out.println("</tr>\n");

        String[] zielattributArray = zielAttribut.split(";");
        for (int i = 0; i < zielattributArray.length; i++) {
            zielattributArray[i] = zielattributArray[i].trim();
        }

        String[] auswahlherkunftArray = auswahlherkunft.split(";");
        for (int i = 0; i < auswahlherkunftArray.length; i++) {
            auswahlherkunftArray[i] = auswahlherkunftArray[i].trim();
        }

        String zielattribute = "Genauigkeit" + zielattributArray[0] + ", " + zielattributArray[0];
        for (int i = 1; i < zielattributArray.length; i++) {
            zielattribute += ", Genauigkeit" + zielattributArray[i] + ", " + zielattributArray[i];
        }

        Map row = AbstractBase.getMappedRow("SELECT " + zielattribute + " FROM " + zielTabelle + " WHERE ID ='" + id + "'");
        List<Map> rowlist2 = AbstractBase.getMappedList("SELECT * FROM " + auswahlherkunft + " ORDER by Bezeichnung");

        out.println("<tr>");

        if (row != null) {
            boolean empty = true;
            for (int j = 0; j < combinedFeldnamen.length; j++) {
                String accuracyIndex = "Genauigkeit" + zielattributArray[j]; // e.g. GenauigkeitVonJahr
                String valueIndex = zielattributArray[j]; // e.g. VonJahr
                if (row.get(accuracyIndex) != null && !Utils.safeToString(row.get(accuracyIndex)).equals("-1") || (row.get(valueIndex) != null && !Utils.safeToString(row.get(valueIndex)).equals("0"))) {
                    empty = false;
                    break;
                }
            }
            if (empty && defaultValues != null && defaultValues.length > 0) {
                row = AbstractBase.getMappedRow(defaultValues[0].replaceAll("%id%", id));
            }
            for (int j = 0; j < combinedFeldnamen.length; j++) {
                String accuracyIndex = "Genauigkeit" + zielattributArray[j]; // e.g. GenauigkeitVonJahr
                String valueIndex = zielattributArray[j]; // e.g. VonJahr
                out.println("<td>");
                int selected = -1;
                if ((!empty || row != null) && row.get(accuracyIndex) != null) {
                    selected = Integer.parseInt(String.valueOf(row.get(accuracyIndex)));
                }
                if (!isReadOnly) {
                    out.println("<select name=\"Genauigkeit" + combinedFeldnamen[j] + "\">");
                    out.println("<option value=\"-1\">nicht bearbeitet</option>");
                }

                for (Map row2 : rowlist2) {
                    if (!isReadOnly) {
                        out.println("<option value=\"" + String.valueOf(row2.get("ID")) + "\" " + (Integer.parseInt(String.valueOf(row2.get("ID"))) == selected ? "selected" : "") + ">" + Utils.safeToString(row2.get("Bezeichnung")) + "</option>");
                    } else if (Integer.parseInt(String.valueOf(row2.get("ID"))) == selected) {
                        String bez = Utils.safeToString(row2.get("Bezeichnung"), "--");
                        if (!bez.equals("--")) {
                            out.println(DBtoHTML(bez));
                        }
                    }
                }
                if (!isReadOnly) {
                    out.println("</select>");
                }

                if (!isReadOnly) {
                    out.println("<input name=\"" + combinedFeldnamen[j] + "\""
                            + " value=\"" + ((!empty || row != null) && row.get(valueIndex) != null ? String.valueOf(row.get(valueIndex)) : "") + "\""
                            + " size=\"10\""
                            + " " + (j == 2 ? "onblur=\"javascript:makeCentury('" + combinedFeldnamen[j] + "', '" + combinedFeldnamen[j + 1] + "')\"" : "")
                            + " />");
                } else {
                    out.println(((!empty || row != null) && row.get(valueIndex) != null ? String.valueOf(row.get(valueIndex)) : ""));
                }
                out.println("</td>");
            }
        } else {
            for (int j = 0; j < combinedFeldnamen.length; j++) {
                out.println("<td>");
                if (!isReadOnly) {
                    out.println("<select name=\"Genauigkeit" + combinedFeldnamen[j] + "\">");
                    out.println("<option value=\"-1\">nicht bearbeitet</option>");
                }

                for (Map row2 : rowlist2) {
                    if (!isReadOnly) {
                        out.println("<option value=\"" + String.valueOf(row2.get("ID")) + "\" >" + Utils.safeToString(row2.get("Bezeichnung")) + "</option>");
                    }
                }
                if (!isReadOnly) {
                    out.println("</select>");
                }
                if (!isReadOnly) {
                    out.println("<input name=\"" + combinedFeldnamen[j] + "\""
                            + " value=\"" + "\""
                            + " maxlength=\"" + AbstractBase.getMaxCharacterLength(zielTabelle, zielattributArray[j]) + "\" "
                            + " size=\"10\""
                            + " " + (j == 2 ? "onblur=\"javascript:makeCentury('" + combinedFeldnamen[j] + "', '" + combinedFeldnamen[j + 1] + "')\"" : "")
                            + " >");
                }
                out.println("</td>");
            }
        }
        out.println("</tr>");

        out.println("</table>\n");
    }
%>
