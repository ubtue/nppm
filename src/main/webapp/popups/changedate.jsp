<%@page import="java.util.HashMap"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
  if (session.getAttribute("BenutzerID") != null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0) {
%>

<jsp:include page="../dosave.jsp">
  <jsp:param name="form" value="handschrift_ueberlieferung" />
  <jsp:param name="ID" value="<%= request.getParameter("ID") %>" />
</jsp:include>

<HTML>
  <HEAD>
    <TITLE>NPPM - <% Language.printTextfield(out, session, "changedate", "NeuerEintrag");%></TITLE>
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
    <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
    <noscript></noscript>
  </HEAD>

  <BODY class="popup">
<%
  if (request.getParameter("speichern") == null) {
      out.println("<input type=\"hidden\" name=\"destination\" value=\""+request.getParameter("destination")+"\">");
 %>
     <h2><% Language.printTextfield(out, session, "changedate", "DatumAendern");%></h2>
    <form method="POST">
        <jsp:include page="../inc.erzeugeFormular.jsp">
          <jsp:param name="Formular" value="handschrift_ueberlieferung"/>
          <jsp:param name="Datenfeld" value="DatumVon"/>
        </jsp:include>
        <jsp:include page="../inc.erzeugeFormular.jsp">
          <jsp:param name="Formular" value="handschrift_ueberlieferung"/>
          <jsp:param name="Datenfeld" value="DatumBis"/>
        </jsp:include>
    <br/><br/>

    <%
        String id = request.getParameter("ID");

        // Generiere dynamisch den SQL-String
        String updateSql = "UPDATE handschrift_ueberlieferung SET DatumVon = :datumVon, DatumBis = :datumBis WHERE ID = :id";

        // Hole die Formulardaten
        String datumVon = request.getParameter("DatumVon");
        String datumBis = request.getParameter("DatumBis");

        // Erstelle die Map mit den Werten für den SQL-String
        Map<String, String> columnsAndValues = new HashMap<>();
        columnsAndValues.put("DatumVon", datumVon);
        columnsAndValues.put("DatumBis", datumBis);
        columnsAndValues.put("ID", id);

        // SQL-String wird mit der SaveHelper.insertOrUpdateSql() Methode verarbeitet
        try {
            SaveHelper.insertOrUpdateSql(updateSql);
        } catch (Exception e) {
        }
    %>

    <input type="submit" name="speichern" value="<%= Language.getTextfield(session, "navigation", "Speichern") %>">
    </form>

<%
  } else {
    // JavaScript, um die Seite nach dem Speichern zu schließen und die Auswahl zu aktualisieren
    out.println("<script type=\"text/javascript\">");
    out.println("var selection = opener.document.getElementById('" + request.getParameter("destination") + "');");
    try {
        out.println("selection.firstChild.nodeValue='" + request.getParameter("VonJahr") + "(" + request.getParameter("VonJahrhundert") + ".Jhd)-" + request.getParameter("BisJahr") + "(" + request.getParameter("BisJahrhundert") + ".Jhd)';");
    } catch (Exception ex) {
        out.println("selection.firstChild.nodeValue='---';");
    }
    out.println("window.close();");
    out.println("</script>");
  }
%>

  </BODY>
</HTML>

<%
  } else {
%>
    <a href="#" onclick="window.close(); return false;"><%= Language.getTextfield(session, "navigation", "Zurueck") %></a>
<%
  }
%>
