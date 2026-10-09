<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("checkbox") && !array) {
        out.print("<input name=\"" + datenfeld + "\" ");
        out.print("type=\"checkbox\"");
        String cssClass = "ut-icon ut-icon-uncheck";
        if (zielAttribut != null && zielTabelle != null) {
            String checked = AbstractBase.getStringNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
            if (checked != null && (checked.equals("true") || checked.equals("1"))) {
                out.print(" checked ");
                cssClass = "ut-icon ut-icon-check";
            }
            if (isReadOnly) {
                out.print(" disabled ");
            }
        }
        out.print(" class=\"" + cssClass + "\" ");
        out.println("/>");
    }
%>
