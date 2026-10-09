<%@page import="de.uni_tuebingen.ub.nppm.db.BenutzerDB"%>

<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.Benutzer" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.BenutzerDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>

<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>


<%    String errorMessage = (String) request.getAttribute("errorMessage");
    boolean actionDone = (Boolean.TRUE.equals(request.getAttribute("actionDone")));
    boolean actionNotDone = (Boolean.TRUE.equals(request.getAttribute("actionNotDone")));

    String activeTab = request.getParameter("tab"); // Parameter 'tab' in der URL
    if (activeTab == null) {
        activeTab = "tab1"; // Standardmäßig Tab1 anzeigen
    }

    // Benutzer-ID aus der Session abrufen
    Integer sessionBenutzerID = (Integer) session.getAttribute("BenutzerID");
    int benutzerID = (sessionBenutzerID != null) ? sessionBenutzerID : -1;

    // Benutzer aus der Datenbank abrufen
    Benutzer benutzer = BenutzerDB.getById(benutzerID);
    boolean isAdmin = (benutzer != null) && benutzer.isAdmin();

    // Falls Admin und eine ID per Request übergeben wurde
    if (isAdmin && request.getParameter("ID") != null) {
        try {
            benutzerID = Integer.parseInt(request.getParameter("ID"));
            benutzer = BenutzerDB.getById(benutzerID);

            // ID in der Session speichern, damit sie nach Tab-Wechsel bleibt
            session.setAttribute("BearbeiteteBenutzerID", benutzerID);
        } catch (NumberFormatException e) {
            errorMessage = "Ungültige Benutzer-ID übergeben!";
        }
    } else if (isAdmin && session.getAttribute("BearbeiteteBenutzerID") != null) {
        // Falls keine neue ID übergeben wurde, aber eine gespeicherte existiert, diese nutzen
        benutzerID = (Integer) session.getAttribute("BearbeiteteBenutzerID");
        benutzer = BenutzerDB.getById(benutzerID);
    }
%>

<jsp:include page="layout/titel.einstellungen.jsp" />

<div id="form">

    <%        if (actionDone) {
    %>

    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="ErfolgDaten"/>
    </jsp:include>
    <br><br>
    <a href="javascript:history.back()">
        <jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="einstellungen"/>
            <jsp:param name="Textfeld" value="Zurueck"/>
        </jsp:include>
    </a>

    <%
    } else if (actionNotDone) {

        if ("passwordOldEmpty".equals(errorMessage)) {
    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerPasswortAltLeer"/>
    </jsp:include>
    <%
    } else if ("passwordNewEmpty".equals(errorMessage)) {

    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerPasswortNeuLeer"/>
    </jsp:include>
    <%} else if ("passwordNewReplayEmpty".equals(errorMessage)) {

    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerPasswortNeuWdhLeer"/>
    </jsp:include>
    <%    } else if ("passwordNewNotEqual".equals(errorMessage)) {
    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerPasswortNeuUngleich"/>
    </jsp:include>
    <%
    } else if ("passwordOldWrong".equals(errorMessage)) {
    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerPasswortAltFalsch"/>
    </jsp:include>
    <%
    } else if ("emailAddressTaken".equals(errorMessage)) {
    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="EmailBesetzt"/>
    </jsp:include>
    <%
    } else if ("usernameTaken".equals(errorMessage)) {
    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="LoginNameBesetzt"/>
    </jsp:include>
    <%
    } else if ("noEmail".equals(errorMessage)) {

    %>
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="einstellungen"/>
        <jsp:param name="Textfeld" value="FehlerEmailLeer"/>
    </jsp:include>
    <%    }
        out.println("<br><br>");
        out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
    } else {
    %>

    <div id="header">
        <ul id="primary">
            <li><a href="einstellungen?tab=tab1" <%= "tab1".equals(activeTab) ? "class='active'" : ""%>>

                    <jsp:include page="inc.erzeugeBeschriftung.jsp">
                        <jsp:param name="Formular" value="einstellungen"/>
                        <jsp:param name="Textfeld" value="TabEinstellungen"/>
                    </jsp:include>

                </a>
            </li>
            <li>
                <a href="einstellungen?tab=tab2" <%= "tab2".equals(activeTab) ? "class='active'" : ""%>>
                    <jsp:include page="inc.erzeugeBeschriftung.jsp">
                        <jsp:param name="Formular" value="einstellungen"/>
                        <jsp:param name="Textfeld" value="TabPasswort"/>
                    </jsp:include>
                </a>
            </li>
        </ul>
    </div>
    <div id="main">

        <%
            if ("tab1".equals(activeTab)) {
        %>

        <form method="POST" action="einstellungen">
            <% if (isAdmin)%>
            <input type="hidden" name="ID" value="<%= benutzerID %>">
            <input type="hidden" name="action" value="Einstellungen">
            <table>
                <tr>
                    <td width="200"><label for="Benutzername"><%= Language.getTextfield(session, "login", "Benutzername")%>:</label></td>
                    <td width="450"><input name="Benutzername" size="25" maxlength="255" required="true" value="<%= benutzer.getLogin()%>"></td>
                </tr>
                <tr>
                    <td width="200"><label for="Nachname"><%= Language.getTextfield(session, "einstellungen", "Nachname")%>:</label></td>
                    <td width="450"><input name="Nachname" size="25" maxlength="255" required="true" value="<%= benutzer.getNachname()%>"></td>
                </tr>
                <tr>
                    <td width="200"><label for="Vorname"><%= Language.getTextfield(session, "einstellungen", "Vorname")%>:</label></td>
                    <td width="450"><input name="Vorname" size="25" maxlength="255" required="true" value="<%= benutzer.getVorname()%>"></td>
                </tr>
                <tr>
                    <td>
                        <jsp:include page="inc.erzeugeBeschriftung.jsp">
                            <jsp:param name="Formular" value="einstellungen"/>
                            <jsp:param name="Textfeld" value="Email"/>
                        </jsp:include>
                    </td>

                    <td><input type="email" name="email" required="true" value="<%= benutzer.getEMail()%>"/></td>
                </tr>
                <tr>
                    <td>
                        <jsp:include page="inc.erzeugeBeschriftung.jsp">
                            <jsp:param name="Formular" value="einstellungen"/>
                            <jsp:param name="Textfeld" value="Sprache"/>
                        </jsp:include>
                    </td>
                    <td>
                        <jsp:include page="administration/select.jsp">
                            <jsp:param name="Tabelle" value="datenbank_sprachen" />
                            <jsp:param name="Feldname" value="Sprache" />
                            <jsp:param name="checkValue" value="<%= benutzer.getSprache()%>" />
                        </jsp:include>
                    </td>
                </tr>
                <%if (isAdmin) {%>
                <tr>
                    <td width="200"><label for="Administrator"><%= Language.getTextfield(session, "administration", "Titel")%>:</label></td>
                    <td width="450"><input type="checkbox" name="Administrator" <%= benutzer.isAdmin() ? "checked" : ""%>></td>
                </tr>
                <tr>
                    <td width="200"><label for="Administrator"><%= Language.getTextfield(session, "einstellungen", "Aktiv")%>:</label></td>
                    <td width="450"><input type="checkbox" name="Aktiv" <%= benutzer.isAktiv() ? "checked" : ""%>></td>
                </tr>
                <%}%>
                <tr>
                    <td colspan="2" align="right">
                        <input type="reset" value="<%= DatenbankDB.getLabel((String) session.getAttribute("Sprache"), "navigation", "Abbrechen")%>">
                        &nbsp;
                        <input type="submit" name="save" value="<%= DatenbankDB.getLabel((String) session.getAttribute("Sprache"), "navigation", "Speichern")%>">
                    </td>
                </tr>
            </table>
        </form>


        <%
        } else if ("tab2".equals(activeTab)) {
        %>
        <form method="POST" action="einstellungen">
            <% if (isAdmin)%>
            <input type="hidden" name="ID" value="<%= benutzerID %>">
            <input type="hidden" name="action" value="Passwort">
            <table>
                <tr>
                    <% if (!isAdmin) { %>
                    <td>
                        <jsp:include page="inc.erzeugeBeschriftung.jsp">
                            <jsp:param name="Formular" value="einstellungen"/>
                            <jsp:param name="Textfeld" value="PasswortAlt"/>
                        </jsp:include>
                    </td>
                    <td>
                        <div class="input-container">
                            <input type="password" name="PasswortAlt" id="passwortAlt">
                            <span class="toggle-eye" onclick="togglePassword('passwortAlt', this)">👁</span>
                        </div>
                    </td>
                    <% } else { %>
                    <td><input type="hidden" name="PasswortAlt" /></td>
                        <% }%>
                </tr>
                <tr>
                    <td>
                        <jsp:include page="inc.erzeugeBeschriftung.jsp">
                            <jsp:param name="Formular" value="einstellungen"/>
                            <jsp:param name="Textfeld" value="PasswortNeu"/>
                        </jsp:include>
                    </td>
                    <td>
                        <div class="input-container">
                            <input type="password" name="PasswortNeu" id="passwortNeu" minlength="6">
                            <span class="toggle-eye" onclick="togglePassword('passwortNeu', this)">👁</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <jsp:include page="inc.erzeugeBeschriftung.jsp">
                            <jsp:param name="Formular" value="einstellungen"/>
                            <jsp:param name="Textfeld" value="PasswortNeuWdh"/>
                        </jsp:include>
                    </td>
                    <td>
                        <div class="input-container">
                            <input type="password" name="PasswortNeuWdh" id="passwortNeuWdh" minlength="6">
                            <span class="toggle-eye" onclick="togglePassword('passwortNeuWdh', this)">👁</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <input type="reset" value="<%= DatenbankDB.getLabel((String) session.getAttribute("Sprache"), "navigation", "Abbrechen")%>">
                        &nbsp;
                        <input type="submit" name="password" value="<%= DatenbankDB.getLabel((String) session.getAttribute("Sprache"), "navigation", "Speichern")%>">
                    </td>
                </tr>
            </table>
        </form>

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
            .input-container input {
                padding-right: 35px; /* Platz für das Auge */
            }
            .toggle-eye {
                position: absolute;
                right: 5px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 18px;
            }
        </style>

    </div>

    <%
            }
        }
    %>
</div>
