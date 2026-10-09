<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Gastquelle"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.SelektionDB"%>
<%@page import="java.util.List"%>
<%
    if (feldtyp.equals("array.selektion.multiselect") && !array) {
        out.println("<div id=\"" + datenfeld + "-wrapper\" class=\"select-wrapper\">");

        // Erster Select-Feldblock
        out.println("<div class=\"select-block\">");
        out.println("<select name=\"" + datenfeld + "[]\">");

        List<Gastquelle> rows2 = SelektionDB.getAllGastquelle();
        for (Gastquelle columns2 : rows2) {
            int value2_id = Integer.parseInt(String.valueOf(columns2.getId()));
            String value2_Bezeichnung = Utils.safeToString(columns2.getBezeichnung());
            out.println("<option value=\"" + value2_id + "\">" + value2_Bezeichnung + "</option>");
        }

        out.println("</select>");
        out.println("<button type=\"button\" class=\"add-select\">+</button>");
        out.println("<button type=\"button\" class=\"remove-select\">–</button>");
        out.println("</div>"); // .select-block

        out.println("</div>"); // .select-wrapper
        out.println("<script src=\"assets/js/multiselect-dynamic.js\"></script>");
    }
%>
