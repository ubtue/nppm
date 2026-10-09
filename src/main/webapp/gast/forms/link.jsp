<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ include file="../../configuration.jsp" %>

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

    String excludeText = request.getParameter("excludeText");
    String exclusion = "";
    if (excludeText != null && !excludeText.isEmpty() && (guest+title).compareTo("gast_mgh_lemma") == 0) {
        exclusion = " AND " + title + ".MGHLemma NOT LIKE '%" + excludeText + "%'";
    }

    int newid = id;
    String label = "";
    String backgroundClass = "";

    String sql = DatenbankDB.getFilterSql(guest + title, filter);
    if (request.getParameter("Command").equals("next")) {
        label = ">";
        sql = sql.replace("*", title + ".ID");
        sql += (sql.contains("WHERE") ? " AND" : " WHERE") + " " + title + ".ID > " + id;
        backgroundClass = "next";
        if (!exclusion.isEmpty()) {
            sql += exclusion;
        }
        sql += " ORDER BY ID ASC;";
    } else if (request.getParameter("Command").equals("back")) {
        label = "<";
        sql = sql.replace("*", title + ".ID");
        sql += (sql.contains("WHERE") ? " AND" : " WHERE") + " " + title + ".ID < " + id;
        backgroundClass = "prev";
        if (!exclusion.isEmpty()) {
            sql += exclusion;
        }
        sql += " ORDER BY ID DESC;";
    } else if (request.getParameter("Command").equals("last")) {
        label = ">|";
        sql = sql.replace("*", "max(" + title + ".ID) ID");
        backgroundClass = "next_end";
        if (!exclusion.isEmpty()) {
            sql += (sql.contains("WHERE") ? " AND " : " WHERE ") + "1=1" + exclusion + ";";
        }
    } else if (request.getParameter("Command").equals("first")) {
        label = "|<";
        sql = sql.replace("*", "min(" + title + ".ID) ID");
        backgroundClass = "prev_end";
        if (!exclusion.isEmpty()) {
            sql += (sql.contains("WHERE") ? " AND " : " WHERE ") + "1=1" + exclusion + ";";
        }
    } else if (request.getParameter("Command").equals("new")) {
        label = "neu";
        sql = sql.replace("*", "max(" + title + ".ID) ID");
    }

    if (filterParameter != null) {
        sql = sql.replace("###", filterParameter);
    }

    Integer newid2 = AbstractBase.getIntNative(sql);
    if (newid2 != null)
        newid = newid2;

    out.println("<a class='pager " + backgroundClass + " ut-link' href='?ID=" + (request.getParameter("Command").equals("new") ? "-1" : newid) + "'></a>");
%>
