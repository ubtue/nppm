<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%
    if (feldtyp.equals("addselectandtext") && array) {
        List<Map> rowlist = AbstractBase.getMappedList("SELECT " + zielTabelle + ".ID, " + auswahlherkunft + ".Bezeichnung, " + auswahlherkunft + ".ID value FROM " + zielTabelle + ", " + auswahlherkunft + " WHERE " + zielTabelle + "." + formular + "ID=" + id + " AND " + zielTabelle + "." + zielAttribut + "=" + auswahlherkunft + ".ID ORDER BY " + auswahlherkunft + ".Bezeichnung");
        out.println("<table>");
        int i = 0;
        for (Map row : rowlist) {
            out.println("<tr>");
            out.println("<input type=\"hidden\" name =\"" + datenfeld + "[" + i + "]" + "_entryid\" value=\"" + Utils.safeToString(row.get("ID")) + "\">");


                out.println("<input type=\"hidden\" name=\"" + datenfeld + "[" + i + "]\" value=\"" + Utils.safeToString(row.get("value")) + "\" />");
                out.println("<td>" +  Utils.safeToString(row.get(auswahlherkunft + ".Bezeichnung")) + "</td>");;
                String href = "javascript:deleteEntry('" + zielTabelle + "', '" + Utils.safeToString(row.get(zielTabelle + ".ID")) + "', '" + returnpage + "', '" + id + "');";
                out.println("<td>");
                out.println("<a href=\"" + href + "\">");
                out.println(txt_delete);
                out.println("</a>");
                out.println("</td>");

            out.println("</tr>");
            i++;
        }

        out.println("<tr>");
        out.println("<td>");
        out.println("<select name=\"" + datenfeld + "[" + i + "]\">");
        List<Map> rowlist2 = AbstractBase.getMappedList("SELECT * FROM " + auswahlherkunft + " ORDER BY Bezeichnung ASC");
        for (Map row2 : rowlist2) {
            out.println("<option value=\"" + Utils.safeToString(row2.get("ID")) + "\" " + (Utils.safeToString(row2.get("ID")).equals("-1") ? "selected" : "") + ">" + Utils.safeToString(row2.get("Bezeichnung")) + "</option>");
        }
        out.println("</select>");
        out.println("</td>");
        out.println("<td>&nbsp;</td><td><a href=\"javascript:popup('addselect', this, '" + auswahlherkunft + "', '" + datenfeld + "[" + i + "]', '');\">" + txt_newentry + "</a></td>");
        out.println("</tr>");

        out.println("</table>");

    }
%>
