<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>

<%
    int id = -1;
    String title = request.getParameter("title");
    String guest = "";
    if (title.contains("gast_")) {
        title = title.substring(5);
        guest = "gast_";
    }
    int filter = 0;
    String filterParameter = request.getParameter("filterParameter") == null ? "" : request.getParameter("filterParameter");
    try {
        id = Integer.parseInt(request.getParameter("ID"));
        filter = Integer.parseInt(request.getParameter("filter"));
    } catch (NumberFormatException e) {
    }

    String sql_max = DatenbankDB.getFilterSql(guest + title, filter);
    sql_max = sql_max.replace("*", "count(*) c");
    sql_max = sql_max.replace("###", filterParameter);

    String sql_akt = sql_max + (sql_max.contains("WHERE") ? " AND " : " WHERE ") + title + ".ID < " + id;

    String excludeText = request.getParameter("excludeText");

    if (excludeText != null && !excludeText.isEmpty() && (guest+title).compareTo("gast_mgh_lemma") == 0) {
        String excludeClause = " AND " + title + ".MGHLemma NOT LIKE '%" + excludeText + "%'";
        sql_max += excludeClause;
        sql_akt += excludeClause;
    }

    Integer akt = AbstractBase.getIntNative(sql_akt) + 1;
    Integer max = AbstractBase.getIntNative(sql_max);

    out.println("[" + akt + " / " + max + "]");
%>
