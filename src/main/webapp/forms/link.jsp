<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>

<%
    int id = -1;
    String title = request.getParameter("title");
    String formular = request.getParameter("formular");

    String guest = "";
    if (title.contains("gast_")) {
        title = title.substring(5);
        guest = "gast_";
    }
    int filter = 0;
    String filterParameter = null;
    try {
        id = Integer.parseInt(request.getParameter("ID"));
        filter = ((Integer) session.getAttribute(formular + "filter")).intValue();
        filterParameter = (String) (session.getAttribute(formular + "filterParameter"));
    } catch (Exception e) {
    }

    int newid = id;
    String label = "";

    String sql = DatenbankDB.getFilterSql(guest + title, filter);
    if (request.getParameter("Command").equals("next")) {
        label = ">";
        sql = sql.replace("*", title + ".ID");
        sql += (sql.contains("WHERE") ? " AND" : " WHERE") + " " + title + ".ID > " + id + " ORDER BY ID ASC;";
    } else if (request.getParameter("Command").equals("back")) {
        label = "<";
        sql = sql.replace("*", title + ".ID");
        sql += (sql.contains("WHERE") ? " AND" : " WHERE") + " " + title + ".ID < " + id + " ORDER BY ID DESC;";
    } else if (request.getParameter("Command").equals("last")) {
        label = ">|";
        sql = sql.replace("*", "max(" + title + ".ID) ID");
    } else if (request.getParameter("Command").equals("first")) {
        label = "|<";
        sql = sql.replace("*", "min(" + title + ".ID) ID");
    } else if (request.getParameter("Command").equals("new")) {
        label = Language.getTextfield(session, "titelNavigation", "Neu");
        sql = sql.replace("*", "max(" + title + ".ID) ID");
    }

    if (filterParameter != null) {
        sql = sql.replace("###", filterParameter);
    }

    Integer newid2 = AbstractBase.getIntNative(sql);
    if (newid2 != null)
        newid = newid2;

    out.println("<a style='color:#ffffff;' href='?ID=" + (request.getParameter("Command").equals("new") ? "-1" : newid) + "'>" + label + "</a>");
%>
