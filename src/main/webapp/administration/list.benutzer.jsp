<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.BenutzerDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.Benutzer" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%!
  void renderTable(JspWriter out, List<Benutzer> liste, HttpSession session) throws Exception {
    out.println("<ul><table>");

    out.println("<tr>");
    out.println("<th>ID</th>");
    out.println("<th>" + Language.getTextfield(session, "einstellungen", "Nachname") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "einstellungen", "Vorname") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "Login") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "E-mail") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "Projektgruppe") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "Admin") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "Language") + "</th>");
    out.println("<th>" + Language.getTextfield(session, "admin", "Bearbeiten") + "</th>");
    out.println("</tr>");

    for (Benutzer benutzer : liste){
      out.println("<tr>");
      out.println("<td>" + Integer.toString(benutzer.getID()) + "</td>");
      out.println("<td>" + DBtoHTML(benutzer.getNachname()) + "</td>");
      out.println("<td>" + DBtoHTML(benutzer.getVorname()) + "</td>");
      out.println("<td>" + DBtoHTML(benutzer.getLogin()) + "</td>");
      out.println("<td>" + DBtoHTML(benutzer.getEMail()) + "</td>");
      out.println("<td>" + (benutzer.getGruppe() != null ? DBtoHTML(benutzer.getGruppe().getBezeichnung()) : "&nbsp;") + "</td>");
      out.println("<td>" + (benutzer.isAdmin() ? Language.getTextfield(session, "admin", "Ja") : "&nbsp;") +"</td>");
      out.println("<td>" + DBtoHTML(benutzer.getSprache()) + "</td>");
      out.println("<td><a href=\"einstellungen?ID=" + Integer.toString(benutzer.getID()) +"\">" + DBtoHTML(Language.getTextfield(session, "admin", "Aendern")) + "</a></td>");
      out.println("</tr>");
    }

    out.println("</table></ul>");
  }
%>

<%

  out.println("<ul class=\"mktree\" id=\"complete\">");

  out.println("  <li class=\"liOpen\" style=\"font-size:large\"><b>" + Language.getTextfield(session, "admin", "AktiveBenutzer") + "</b>");
  List listeAktiv = BenutzerDB.getListAktiv();
  renderTable(out, listeAktiv, session);
  out.println("  </li>");

  out.println("  <li class=\"liClosed\"  style=\"font-size:large\"><b>" + Language.getTextfield(session, "admin", "InaktiveBenutzer") + "</b>");
  List listeInaktiv = BenutzerDB.getListInaktiv();
  renderTable(out, listeInaktiv, session);
  out.println("  </li>");

  out.println("</ul>");

%>
