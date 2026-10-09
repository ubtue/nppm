<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("file") && !array) {

        Object[] columns = AbstractBase.getRowNative("SELECT ID, " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
        if (columns != null && columns.length > 1 && columns[1] != null) {
            String folder = "";
            if (zielTabelle.equals("person")) {
                folder = commentFolder_personenkommentar;
            } else if (zielTabelle.equals("namenkommentar")) {
                folder = commentFolder_namenkommentar;
            }
            /* else if (zielTabelle.equals("quelle") && zielAttribut.equals("QuellenKommentarDatei"))
               folder = commentFolder_quellenkommentar;
               else if (zielTabelle.equals("quelle") && zielAttribut.equals("UeberlieferungsKommentarDatei"))
               folder = commentFolder_ueberlieferungskommentar;
             */
            String href = "javascript:deleteFile('" + zielTabelle + "', '" + zielAttribut + "', '" + Utils.safeToString(columns[0]) + "', '" + returnpage + "');";
            out.println("<a href='" + folder + "/" + Utils.safeToString(columns[1]) + "'>" + Utils.safeToString(columns[1]) + "</a>");
            if (!id.equals("-1") && !isReadOnly) {
                out.println("<a href=\"" + href + "\">");
                out.println(txt_delete);
                out.println("</a>");
            }
        } else {
            if (!id.equals("-1") && !isReadOnly) {
                out.print("<div id=\"upload\"><input type=\"button\" value=\"" + Language.getTextfield(session, "general", "Hochladen") + "\" onClick=\"javascript:uploadFile(window, '" + zielTabelle + "', '" + zielAttribut + "','" + id + "');\"></div>");
            }
        }
    }
%>
