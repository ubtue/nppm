<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%
    if (readonly != null && readonly.equals("yes") && !array) {
        int selected = -1;
        if (Integer.parseInt(id) > 0) {
            Integer selection = AbstractBase.getIntNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
            if (selection != null) {
                selected = selection;
            }
        }

        List<Map> rowlist = AbstractBase.getMappedList("SELECT * FROM " + auswahlherkunft + " WHERE ID=" + selected + " ORDER BY Bezeichnung ASC");
        for (Map row : rowlist) {
            out.println(Utils.safeToString(row.get("Bezeichnung")));
        }

        out.println("</select>");
    }
%>
