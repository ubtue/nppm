<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%
    if (feldtyp.equals("select") && array) {

        List<Map> rowlist = AbstractBase.getMappedList("SELECT ID, " + zielAttribut
                + " FROM " + zielTabelle
                + " WHERE " + formular + "ID='" + id + "'"
                + " ORDER BY ID ASC");

        if ((rowlist != null && !rowlist.isEmpty()) || !isReadOnly) {

            out.println("<table class=\"ut-table \">");
            out.println("<tbody class=\"ut-table__body\">");
            boolean repeat = true;
            int i = 0;
            while (repeat) {
                Map row = null;

                int selected = -1;
                if (rowlist.size() > i) {
                    row = rowlist.get(i);
                    selected = Integer.parseInt(String.valueOf(row.get(zielAttribut)));
                    out.println("<input type=\"hidden\" name =\"" + datenfeld + "[" + i + "]" + "_entryid\" value=\"" + String.valueOf(row.get("ID")) + "\">");
                } else {
                    repeat = false;
                }

                out.println("<tr class=\"ut-table__row\">");
                out.println("<td class=\"ut-table__item ut-table__body__item\">");


                if (!isReadOnly) {
                    out.println("<select name='" + datenfeld + "[" + i + "]'>");
                }
                List<Map> rowlist2 = AbstractBase.getMappedList("SELECT * FROM " + auswahlherkunft + " ORDER BY Bezeichnung ASC");
                for (Map row2 : rowlist2) {
                    if (!isReadOnly) {
                        out.println("<option value='" + String.valueOf(row2.get("ID")) + "' " + (Integer.parseInt(String.valueOf(row2.get("ID"))) == selected ? "selected" : "") + ">" + Utils.safeToString(row2.get("Bezeichnung")) + "</option>");
                    } else if (repeat && Integer.parseInt(String.valueOf(row2.get("ID"))) == selected) {
                        out.println(Utils.safeToString(row2.get("Bezeichnung")));
                    }
                }
                if (!isReadOnly) {
                    out.println("</select>");
                }
                out.println("</td>");
                if (repeat) {
                    String href = "javascript:deleteEntry('" + zielTabelle + "', '" + String.valueOf(row.get("ID")) + "', '" + returnpage + "', '" + id + "');";

                    if (!isReadOnly) {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">");
                        out.println("<a href=\"" + href + "\">");
                        out.println(txt_delete);
                        out.println("</a>");
                        out.println("</td>");
                    }
                }
                out.println("</tr>");
                i++;
            }
            out.println("</tbody>");
            out.println("</table>");
        }
    }
%>
