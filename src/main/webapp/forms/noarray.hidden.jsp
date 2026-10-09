<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("hidden") && !array) {
        Object[] columns = AbstractBase.getRowNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
        out.print("<input type='hidden' name=\"" + datenfeld + "\" ");
        if (columns != null && columns.length > 0) {
            out.print("value=\"" + String.valueOf(columns[0]) + "\" ");
        }
        out.println(" />");
    }
%>
