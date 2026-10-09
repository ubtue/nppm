<%@page import="de.uni_tuebingen.ub.nppm.util.pagination.search.PrintPagination"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.List"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ include file="../../configuration.jsp" %>

<%    int id = -1;
    String title = "gast_" + request.getParameter("title").toLowerCase();

    String guest = "";
    String sql_max = "";
    String sql_akt = "";

    if (title != null && title.contains("gast_")) {
        title = title.substring(5);
        guest = "gast_";
    }

    int akt = 0;
    int max = 0;

    //Filter berechnen
    session = request.getSession(true);
    int filter = 0;
    String filterParameter = null;
    try {
        filter = ((Integer) session.getAttribute("filter")).intValue();
        filterParameter = (String) session.getAttribute("filterParameter");
    } catch (Exception e) {
    }

    try {
        id = Integer.parseInt(request.getParameter("ID"));
    } catch (NumberFormatException e) {
    }

    if (title != null && !title.equals("") && id > 0) {
        // SQL generieren
        sql_max = DatenbankDB.getFilterSql(guest + title, filter);
        sql_max = sql_max.replace("*", "count(*) c");
        sql_max = sql_max.replace("###", filterParameter != null ? filterParameter : "");

        sql_akt = sql_max + (sql_max.contains("WHERE") ? " AND " : " WHERE ") + title + ".ID < " + id;

        try {
            akt = AbstractBase.getIntNative(sql_akt) + 1;
            max = AbstractBase.getIntNative(sql_max);
        } catch (Exception e) {
            akt = 0;
            max = 0;
        }
    }


    int pageoffset = 0;
    if (request.getParameter("pageoffset") != null) {
        pageoffset = Integer.parseInt(request.getParameter("pageoffset"));
    }

    String export = "browse";

    PrintPagination.printPageNavigation(out, request, pageoffset, pageLimit, max, export, title);
%>
