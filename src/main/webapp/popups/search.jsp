<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
  if (session.getAttribute("BenutzerID")!=null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0) {
%>
<HTML>
  <HEAD>
    <TITLE>Nomen et Gens - <jsp:include
	page="../inc.erzeugeBeschriftung.jsp">
	<jsp:param name="Formular" value="popup" />
	<jsp:param name="Textfeld" value="Suche" />
</jsp:include></TITLE>
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
    <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
    <noscript></noscript>
  </HEAD>

  <BODY class="popup">
<%
  if (request.getParameter("action") == null && request.getParameter("form") != null) {
    out.println("<h2>Nach \""+request.getParameter("form").substring(0,1).toUpperCase()+request.getParameter("form").substring(1)+"\" suchen</h2>");
    out.println("<form method=\"POST\">");

    out.println(request.getParameter("attribut")+":");

    out.println("<input type=\"hidden\" name=\"action\" value=\"search\">");
    out.println("<input type=\"hidden\" name=\"form\" value=\""+request.getParameter("form")+"\">");
    out.println("<input type=\"hidden\" name=\"attribut\" value=\""+request.getParameter("attribut")+"\">");
    out.println("<input type=\"hidden\" name=\"destination\" value=\""+request.getParameter("destination")+"\">");
    out.println("<input type=\"text\" name=\"searchstring\" size=\"50\">");
    out.println("<br/><br/>");
    out.println("<input type=\"submit\" value=\"suchen\">");
    out.println("</form>");
  }
  else if (request.getParameter("action").equals("search")) {
    String sql = "SELECT ID, "+request.getParameter("attribut")+" FROM "+request.getParameter("form")+" WHERE "+request.getParameter("attribut")+" LIKE '%"+DBtoDB(request.getParameter("searchstring"))+"%' ORDER BY "+request.getParameter("attribut");
    List<Map> rowlist = SucheDB.getMappedList(sql);

    out.println("<table>");
    out.println("<tr><th width=\"75\">ID</th><th>"+request.getParameter("attribut")+"</th></tr>");
    for (Map row : rowlist) {
      out.println("<tr>");
      out.println("<td width=\"75\">"+row.get("ID").toString()+"</td>");
      out.println("<td><a href=\"javascript:copySearchedID("+row.get("ID").toString()+", '"+request.getParameter("destination")+"');window.close();\">"+DBtoHTML(row.get(request.getParameter("attribut")).toString())+"</a></td>");
      out.println("</tr>");
    }
    out.println("</table>");
    out.println("<p align=\"center\"><a href=\"javascript:history.back();\">zur&uuml;ck</a></p>");
//  javascript:addSelection("+newID+", '"+request.getParameter("neuerEintrag")+"', '"+request.getParameter("destination")+"');window.close();\">");
  }
%>
  </BODY>
</HTML>
<%
  }
  else {
    out.println("<p>Zugriff nicht erlaubt!!!</p>");
    out.println("<a href=\"../index.jsp\">Zur&uuml;ck zur Startseite</a>");
  }
%>
