<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.DeleteHelper" isThreadSafe="false" %>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>

<%
  if (AuthHelper.isBenutzerLogin(request)) {
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
      <h2>L&ouml;schen</h2>
<%
  if (request.getParameter("table") == null) {
    out.println(Language.getTextfield(session, "dodeletefile", "FalscherAufruf"));
  }
  else if (request.getParameter("ID") == null) {
    out.println(Language.getTextfield(session, "dodeletefile", "FalscherAufruf"));
  }
  else if (request.getParameter("returnpage") == null) {
    out.println(Language.getTextfield(session, "dodeletefile", "FalscherAufruf"));
  }
  else if (request.getParameter("returnid") == null) {
    out.println(Language.getTextfield(session, "dodeletefile", "FalscherAufruf"));
  }
  else {
    if(DeleteHelper.deleteEntity(request,response,out)){
        out.println("<p>" + Language.getTextfield(session, "dodelete", "EintragErflogreichGelöscht") + "</p>");
        out.println("<script type=\"text/javascript\">window.setTimeout(location.replace('"+request.getParameter("returnpage")+"?ID="+request.getParameter("returnid")+"'),1000)</script>");
    }else{
        out.println("<p>" + Language.getTextfield(session, "dodelete", "FehlerBeimLoeschen!") + "</p>");
        out.println("<a href=\"javascript: history.back();\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
    }
  }
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
