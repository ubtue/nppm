<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Content"%>
<%@ page import="java.io.File" isThreadSafe="false" %>
<%@ page import="java.io.FileNotFoundException" isThreadSafe="false" %>
<%@ page import="java.sql.Connection" isThreadSafe="false" %>
<%@ page import="java.sql.DriverManager" isThreadSafe="false" %>
<%@ page import="java.sql.ResultSet" isThreadSafe="false" %>
<%@ page import="java.sql.Statement" isThreadSafe="false" %>

<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>

<%
  if (session.getAttribute("BenutzerID")!=null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0) {
%>

<HTML>
  <HEAD>
    <TITLE>Nomen et Gens - <% Language.printTextfield(out, session, "fileManagement", "Delete");%></TITLE>
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
    <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
    <noscript></noscript>
  </HEAD>

  <BODY>
    <jsp:include page="layout/navigation.inc.jsp" />
    <jsp:include page="layout/image.inc.html" />
    <jsp:include page="layout/titel.suche.jsp" />
    <div id="form">
      <h2><% Language.printTextfield(out, session, "fileManagement", "Delete");%></h2>
<%

    if (request.getParameter("table") == null || request.getParameter("attribute") == null || (request.getParameter("ID") == null || request.getParameter("returnpage") == null)) {
        out.println(Language.getTextfield(session, "dodeletefile", "FalscherAufruf"));
    }
    else
    {
        int id = Integer.parseInt(request.getParameter("ID"));
        String filename = AbstractBase.getSingleField(request.getParameter("attribute"),request.getParameter("table") , id );
        int fileId = Integer.parseInt(filename);
        Content content = ContentDB.getById(fileId);
        filename = content.getName();

        Map<String, String> condMap = new HashMap<>();
        condMap.put("ID", String.valueOf(id));

        AbstractBase.update(request.getParameter("table"),request.getParameter("attribute"), null, condMap);

        out.println("<p>" + Language.getTextfield(session, "titel_inc", "Eintrag") + " " +filename+ " " + Language.getTextfield(session, "dodeletefile", "ErfolgreichGeloescht") + "</p>");
    }
        out.println("<p><a href=\""+request.getParameter("returnpage")+"?ID="+request.getParameter("ID")+"\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a></p>");
%>
    </div>
  </BODY>
</HTML>
<%
  }
  else {
%>
    <p><% Language.printTextfield(out, session, "dodeletefile", "ZugriffNichtErlaubt");%></p>
    <a href="<%=Utils.getBaseUrl(request)%>/index.jsp"><% Language.printTextfield(out, session, "all", "Startseite");%></a>
<%
  }
%>
