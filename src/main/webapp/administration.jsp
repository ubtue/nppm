<%@page import="de.uni_tuebingen.ub.nppm.model.BenutzerGruppe"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Benutzer"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.SelektionDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.DatenbankSelektion" isThreadSafe="false" %>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>

<% Language.setLanguage(request); %>

<div>
    <jsp:include page="layout/titel.administration.jsp" />
    <div id="form">

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String createMessage = (String) request.getAttribute("createMessage");
            boolean errorCreate = (Boolean.TRUE.equals(request.getAttribute("errorCreate")));
            String activeTab = request.getParameter("tab"); // Parameter 'tab' in der URL
            if (activeTab == null) {
                activeTab = "tab1"; // Standard Tab1 anzeigen
            }

            if ("anlegen".equals(createMessage)) {
                if (errorCreate) {
                    out.println(errorMessage);
                    out.println("<a href=\"javascript:history.back()\">zur&uuml;ck</a>");
                } else {
                    out.println("<p>Benutzer \"" + request.getParameter("Benutzername") + "\" erfolgreich angelegt.</p>");
                    out.println("<a href=\"administration\">zur&uuml;ck</a>");
                }
            } else {
        %>

        <div id="header">
            <ul id="primary">
                <li><a href="administration?tab=tab1" <%= "tab1".equals(activeTab) ? "class='active'" : ""%>><%= Language.getTextfield(session, "administration", "TabBenutzerVerwalten")%></a></li>
                <li><a href="administration?tab=tab2" <%= "tab2".equals(activeTab) ? "class='active'" : ""%>><%= Language.getTextfield(session, "administration", "TabBenutzerNeu")%></a></li>
                <li><a href="administration?tab=tab3" <%= "tab3".equals(activeTab) ? "class='active'" : ""%>><%= Language.getTextfield(session, "administration", "TabAuswahlfelder")%></a></li>
                <li><a href="administration?tab=tab4" <%= "tab4".equals(activeTab) ? "class='active'" : ""%>><%= Language.getTextfield(session, "administration", "TabLemmaKorrektur")%></a></li>
            </ul>
        </div>

        <div id="main">
            <%
                if ("tab1".equals(activeTab)) {
            %>
            <jsp:include page="administration/list.benutzer.jsp" />
            <%
            } else if ("tab2".equals(activeTab)) {
            %>
            <FORM method="POST" action="administration" autocomplete="off">
                <input type="hidden" name="action" value="benutzer.neu">
                <table>
                    <tr>
                        <td width="200"><label for="Benutzername"><%= Language.getTextfield(session, "login", "Benutzername")%>:</label></td>
                        <td width="450"><input name="Benutzername" size="25" maxlength="255" autocomplete="off" required="true"></td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Nachname"><%= Language.getTextfield(session, "einstellungen", "Nachname")%>:</label></td>
                        <td width="450"><input name="Nachname" size="25" maxlength="255" required="true"></td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Vorname"><%= Language.getTextfield(session, "einstellungen", "Vorname")%>:</label></td>
                        <td width="450"><input name="Vorname" size="25" maxlength="255" required="true"></td>
                    </tr>
                    <tr>
                        <td width="200"><label for="EMail"><%= Language.getTextfield(session, "admin", "E-mail")%>:</label></td>
                        <td width="450"><input type="email" name="EMail" size="25" maxlength="255" required="true"></td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Kennwort"><%= Language.getTextfield(session, "login", "Passwort")%>:</label></td>
                        <td width="450">
                            <div class="input-container">
                                <input id="Kennwort" name="Kennwort" size="25"  minlength="6" maxlength="255" type="password" autocomplete="off" required="true">
                                <span class="toggle-eye" onclick="togglePassword('Kennwort', this)">👁</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Projektgruppe"><%= Language.getTextfield(session, "admin", "Projektgruppe")%>:</label></td>
                        <td width="450">
                            <jsp:include page="administration/select.jsp">
                                <jsp:param name="Tabelle" value="benutzer_gruppe" />
                                <jsp:param name="Feldname" value="Projektgruppe" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Sprache"><%= Language.getTextfield(session, "admin", "Language")%>:</label></td>
                        <td width="450">
                            <jsp:include page="administration/select.jsp">
                                <jsp:param name="Tabelle" value="datenbank_sprachen" />
                                <jsp:param name="Feldname" value="Sprache" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200"><label for="Administrator"><%= Language.getTextfield(session, "admin", "Administrator")%>:</label></td>
                        <td width="450"><input type="checkbox" name="Administrator"></td>
                    </tr>
                </table>
                <p><input type="reset" value="<%= Language.getTextfield(session, "admin", "Abbrechen")%>">&nbsp;&nbsp;<input type="submit" name="actionCreate" value="<%= Language.getTextfield(session, "admin", "Anlegen")%>"></p>
            </FORM>

            <script>
                function togglePassword(fieldId, eyeIcon) {
                    let inputField = document.getElementById(fieldId);
                    if (inputField.type === "password") {
                        inputField.type = "text";
                        eyeIcon.textContent = "🔒"; // Schloss-Symbol
                    } else {
                        inputField.type = "password";
                        eyeIcon.textContent = "👁"; // Auge-Symbol
                    }
                }
            </script>

            <style>
                .input-container {
                    position: relative;
                    display: inline-block;
                }
                .toggle-eye {
                    position: absolute;
                    right: 10px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    font-size: 18px;
                    background: none;
                    border: none;
                    outline: none;
                    color: gray;
                }
            </style>

            <%
            } else if ("tab3".equals(activeTab)) {
            %>
            <table>
                <%                        List<String> lst = DatenbankDB.getSelektion();
                    for (String tbl : lst) {
                        if (tbl.startsWith("selektion_") && !tbl.endsWith("autor")) {
                            out.print("<tr>");
                            out.print("<td>" + tbl + "</td>");
                            out.print("<td><a href=\"admin-auswahlfelder?Formular=bearbeiten&Tabelle=" + tbl + "\">" + Language.getTextfield(session, "admin", "BearbeitenKlein") + "</a></td>");
                            out.print("<td><a href=\"admin-auswahlfelder?Formular=zusammenfuehren&Tabelle=" + tbl + "\">" + DBtoHTML(Language.getTextfield(session, "admin", "zusammenfuehren")) + "</a></td>");
                            if ("selektion_funktion".equals(tbl)) {
                                out.print("<td><a href=\"admin-auswahlfelder?Formular=aufteilen&Tabelle=" + tbl + "\">" + Language.getTextfield(session, "admin", "aufteilen") + "</a></td>");
                            } else {
                                out.print("<td></td>");
                            }
                            if (SelektionDB.isHierarchy(tbl)) {
                                out.print("<td><a href=\"admin-auswahlfelder?Formular=baumstruktur&Tabelle=" + tbl + "\">" + Language.getTextfield(session, "admin", "Baumstruktur") + "</a></td>");
                            } else {
                                out.print("<td></td>");
                            }
                            out.println("<td>");
                            out.println("<a href=\"admin-auswahlfelder?Formular=showProvenance&Tabelle=" + tbl + "\">" + Language.getTextfield(session, "admin", "ProvenanceInfo") + "</a>");
                            out.println("</td>");
                            out.print("</tr>");
                        }
                    }
                %>
            </table>            
            <% } else if ("tab4".equals(activeTab)) { %>
                <div id="lemmaKorr-container" class="container mt-2">
                    <div id="lemmaKorr-initials" class=""><%= Language.getTextfield(session, "administration", "DBloading")%></div>
                    <div id="lemmaKorr-list" class="fill-height"></div>
                </div>
            <% } %>
        </div>
        <%
            }
        %>

    </div>
</div>
