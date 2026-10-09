<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("textarea") && !array) {

        String value_zielAttribut = AbstractBase.getStringNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
        if (!isReadOnly) {
            out.print("<textarea name=\"" + datenfeld + "\" "
                    + (cols > 0 ? "cols=\"" + cols + "\" " : "")
                    + (rows > 0 ? "rows=\"" + rows + "\" " : "")
                    + ">");
        } else if (value_zielAttribut != null && !value_zielAttribut.isEmpty()) {
            out.print("<div>");
        }
        if (value_zielAttribut != null) {
            out.print(DBtoHTML(value_zielAttribut));
        }
        if (!isReadOnly) {
            out.println("</textarea>");
        } else if (value_zielAttribut != null && !value_zielAttribut.isEmpty()) {
            out.println("</div>");
        }
    }
%>
