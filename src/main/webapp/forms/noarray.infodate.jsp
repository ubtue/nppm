<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="java.sql.Timestamp"%>

<%
    if (feldtyp.equals("infodate") && !array) {
        Timestamp timestamp = AbstractBase.getTimestampNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
        if (timestamp != null) {
            out.print(DBtoHTML(String.valueOf(timestamp)));
        }
    }
%>
