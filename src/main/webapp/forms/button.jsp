<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>

<%    int id = 1;
    try {
        id = Integer.parseInt(request.getParameter("ID"));
    } catch (NumberFormatException e) {
    }

    String label = "";
    String sql = "";
    if (request.getParameter("Command").equals("next")) {
        label = ">";
        sql = "SELECT ID FROM " + request.getParameter("Formular") + " WHERE ID > " + id + " ORDER BY ID ASC;";
    } else if (request.getParameter("Command").equals("back")) {
        label = "<";
        sql = "SELECT ID FROM " + request.getParameter("Formular") + " WHERE ID < " + id + " ORDER BY ID DESC;";
    } else if (request.getParameter("Command").equals("last")) {
        label = ">|";
        sql = "SELECT min(ID) ID FROM " + request.getParameter("Formular") + ";";
    } else if (request.getParameter("Command").equals("first")) {
        label = "|<";
        sql = "SELECT max(ID) ID FROM " + request.getParameter("Formular") + ";";
    } else if (request.getParameter("Command").equals("new")) {
        label = "neu";
        sql = "SELECT max(ID) ID FROM " + request.getParameter("Formular") + ";";
    }

    int newid = 0;

    Object[] columns = AbstractBase.getRowNative(sql);
    if (columns != null && columns.length > 0 && columns[0] != null) {
        newid = Integer.parseInt(String.valueOf(columns[0]));
    }

    out.println("<form method=\"POST\">");
    out.println("<input type=\"hidden\" name=\"Formular\" value=\"" + request.getParameter("Formular") + "\">");
    out.println("<input type=\"hidden\" name=\"ID\" value=\"" + newid + "\">");
    out.println("<input type=\"submit\" value=\"" + label + "\">");
    out.println("</form>");
%>
