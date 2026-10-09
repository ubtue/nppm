<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("addselect") && array) {

        List<Object[]> rowlist = AbstractBase.getListNative("SELECT ID, " + zielAttribut + " FROM " + zielTabelle + " WHERE " + formular + "ID=\"" + id + "\"");

       if ((rowlist != null && !rowlist.isEmpty()) || !isReadOnly) {

            String selected = "-1";
            int i = 0;
            out.println("<table class=\"ut-table \">");
            out.println("<tbody class=\"ut-table__body\">");
            for (Object[] columns : rowlist) {
                out.println("<tr class=\"ut-table__row\">");
                out.println("<td class=\"ut-table__item ut-table__body__item\">");

                String value_id = Utils.safeToString(columns[0]);
                String value_zielAttribut = Utils.safeToString(columns[1]);
                selected = value_zielAttribut;

                if (!isReadOnly) {
                    out.println("<input type=\"hidden\" name =\"" + datenfeld + "[" + i + "]" + "_entryid\" value=\"" + value_id + "\">");
                    out.println("<select name=\"" + datenfeld + "[" + i + "]\" id=\"" + datenfeld + "[" + i + "]\">");
                }

                List<Object[]> rowlist2 = AbstractBase.getListNative("SELECT ID, Bezeichnung FROM " + auswahlherkunft + " ORDER BY Bezeichnung ASC");
                for (Object[] columns2 : rowlist2) {
                    String value2_id = Utils.safeToString(columns2[0]);
                    String value2_Bezeichnung = Utils.safeToString(columns2[1]);

                    if (!isReadOnly) {
                        out.println("<option value=\"" + value2_id + "\" " + (value2_id.equals(selected) ? "selected" : "") + ">" + value2_Bezeichnung + "</option>");
                    } else if (value2_id.equals(selected)) {
                        out.println(value2_Bezeichnung);
                    }
                }

                if (!isReadOnly) {
                    out.println("</select>");
                }
                out.println("</td>");

                if (!isReadOnly) {

                    if (!selected.equals("-1")) {
                        String href = "";
                        if (returnId.equals("-1")) {
                            href = "javascript:deleteEntry('" + zielTabelle + "', '" + value_id + "', '" + returnpage + "', '" + id + "');";
                        } else {
                            href = "javascript:deleteEntry('" + zielTabelle + "', '" + value_id + "', '" + returnpage + "', '" + returnId + "');";
                        }

                        out.println("<td>");
                        out.println("<a href=\"" + href + "\">");
                        out.println(txt_delete);
                        out.println("</a>");
                        out.println("</td>");
                    } else {
                        out.println("<td>&nbsp;</td><td><a href=\"javascript:popup('addselect', this, '" + auswahlherkunft + "', '" + datenfeld + "[" + i + "]', '');\">" + txt_newentry + "</a></td>");
                    }
                }

                out.println("</tr>");
                i++;
            }

            //Create new drop down list when Backend/Admin, not Guest
            if (!isReadOnly) {

                out.println("<tr>");
                out.println("<td>");
                out.println("<select name=\"" + datenfeld + "[" + i + "]\" id=\"" + datenfeld + "[" + i + "]\">");

                List<Object[]> rowlist3 = AbstractBase.getListNative("SELECT ID, Bezeichnung FROM " + auswahlherkunft + " ORDER BY "
                        + "CASE "
                        + "    WHEN id = -1 THEN 0 "
                        + "    WHEN id = 1 THEN 1 "
                        + "    ELSE 2 "
                        + "END, "
                        + "Bezeichnung ASC;");

                for (Object[] columns2 : rowlist3) {
                    String value2_id = Utils.safeToString(columns2[0]);
                    String value2_Bezeichnung = Utils.safeToString(columns2[1]);
                    out.print("<option value=\"" + value2_id + "\">" + value2_Bezeichnung + "</option>");
                }
                out.println("</select>");
                out.println("<td>&nbsp;</td><td><a href=\"javascript:popup('addselect', this, '" + auswahlherkunft + "', '" + datenfeld + "[" + i + "]', '');\">" + txt_newentry + "</a></td>");
            }

            out.println("</td>");
            out.println("</tr>");
            out.println("</table>");

        }
    }
%>
