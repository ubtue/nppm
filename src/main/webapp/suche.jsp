<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ include file="configuration.jsp"%>
<%@ include file="functions.jsp"%>

<div>
    <jsp:include page="layout/titel.suche.jsp" />

    <div id="form">
        <div id="tab1">
            <div id="header">
                <ul id="primary">
                    <li>
                        <span>
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </span>
                    </li>
                    <li><a href="javascript:onoff('tab2','tab1');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab3','tab1');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab1');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab5','tab1');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab6','tab1');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab8','tab1');">
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </a>
                    </li>
                </ul>
            </div>

            <div id="main">
                <form method="post" action="suche">
                    <input type="hidden" name="form" value="identischesLemma" />

                    <table>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "suche", "Belegform");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Belegform" />
                            </td>
                        </tr>
                    </table>
                    <br>
                    <p><input type="reset" value="<%= Language.getTextfield(session, "suche", "Abbrechen")%>" />&nbsp;&nbsp;
                       <input type="submit" value="<%= Language.getTextfield(session, "suche", "Suchen")%>" />
                    </p>
                </form>

                <%
                    if (request.getParameter("form") != null
                            && request.getParameter("form").equals(
                                    "identischesLemma")) {
                %>
                <%@ include file="suche/identischesLemma.jsp"%>
                <%    }
                %>
            </div>
        </div>

        <div id="tab2">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab2');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a>
                    </li>
                    <li><span>
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </span>
                    </li>
                    <li><a href="javascript:onoff('tab3','tab2');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab2');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab5','tab2');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab6','tab2');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab8','tab2');">
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </a>
                    </li>
                </ul>
            </div>
            <div id="main">
                <form method="post" action="suchergebnis">
                    <input type="hidden" name="form" value="person" />

                    <table>
                        <tr>
                            <th width="200">PKZ</th>
                            <td width="450">
                                <input type="text" size="50" name="PKZ" />
                            </td>
                        </tr>
                        <tr>
                            <th width="200">1. <% Language.printTextfield(out, session, "suche", "Belegform");%> </th>
                            <td width="450">
                                <input type="text" size="50" name="Belegform" disabled />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printDatafield(out, session, "freie_suche", "Personenname");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Person" />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "suche", "Amt");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Amt" disabled />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printDatafield(out, session, "person", "Stand");%></th>
                            <td width="450">
                                <jsp:include page="inc.suchformular.jsp">
                                    <jsp:param name="Formular" value="selektion_stand" />
                                    <jsp:param name="Datenfeld" value="Stand" />
                                </jsp:include>
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printDatafield(out, session, "person", "Ethnie");%></th>
                            <td width="450">
                                <jsp:include page="inc.suchformular.jsp">
                                    <jsp:param name="Formular" value="selektion_ethnie" />
                                    <jsp:param name="Datenfeld" value="Ethnie" />
                                </jsp:include>
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printDatafield(out, session, "person", "Geschlecht");%></th>
                            <td width="450">
                                <jsp:include page="inc.suchformular.jsp">
                                    <jsp:param name="Formular" value="selektion_geschlecht" />
                                    <jsp:param name="Datenfeld" value="Geschlecht" />
                                </jsp:include>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <h2><% Language.printTextfield(out, session, "suche", "Ausgabefelder");%></h2>
                    <table>
                        <tr>
                            <td><input type="checkbox" name="AusgabePerson" /></td>
                            <td width="200"><% Language.printTextfield(out, session, "suche", "Person");%></td>
                            <td>
                                <input type="checkbox" name="AusgabeBeleform" disabled />
                            </td>
                            <td width="200">
                                1. <% Language.printTextfield(out, session, "suche", "Belegform");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeZusatz" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Zusatz");%>
                            </td>
                            <td>
                                <input type="checkbox" name="AusgabeAmt" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Amt");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeStand" />
                            </td>
                            <td width="200">
                                <% Language.printDatafield(out, session, "person", "Stand");%>
                            </td>
                            <td>
                                <input type="checkbox" name="AusgabeEthnie" />
                            </td>
                            <td width="200">
                                <% Language.printDatafield(out, session, "person", "Ethnie");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeGeschlecht" />
                            </td>
                            <td width="200">
                                <% Language.printDatafield(out, session, "person", "Geschlecht");%>
                            </td>
                            <td>
                                <input type="checkbox" name="AusgabeDatumErste" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "DatumErsteNennung");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeDatumLetzte" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "DatumLetzteNennung");%>
                            </td>
                        </tr>
                    </table>
                    <p>
                       <input type="reset" value="<%= Language.getTextfield(session, "suche", "Abbrechen")%>" />&nbsp;&nbsp;
                       <input type="submit" value="<%= Language.getTextfield(session, "suche", "Suchen")%>" />
                    </p>
                </form>
            </div>
        </div>

        <div id="tab3">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab3');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab2','tab3');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a>
                    </li>
                    <li>
                        <span>
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </span>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab3');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab5','tab3');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab6','tab3');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab8','tab3');">
                            <% Language.printTextfield(out, session, "suche", "Titel");%>
                        </a>
                    </li>
                </ul>
            </div>
            <div id="main">
                <form method="post" action="suchergebnis">
                    <input type="hidden" name="form" value="quelle" />

                    <table>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "einzelbeleg", "BoxQuelle");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Quelle" />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "suche", "Handschrift");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Handschrift" disabled />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "quelle", "Edition");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Edition" />
                            </td>
                        </tr>
                    </table>
                    <br>
                    <h2><% Language.printTextfield(out, session, "suche", "Ausgabefelder");%></h2>
                    <table>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeID" checked disabled />
                            </td>
                            <td width="200">ID</td>
                            <td>
                                <input type="checkbox" name="AusgabeKurztitel" />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Kurztitel");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeHandschrift" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Handschrift");%>
                            </td>
                            <td>
                                <input type="checkbox" name="AusgabeEdition" />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "quelle", "Edition");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeBelegform" disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Belegform");%>
                            </td>
                        </tr>
                    </table>
                    <p>
                       <input type="reset" value="<%= Language.getTextfield(session, "suche", "Abbrechen")%>" />&nbsp;&nbsp;
                       <input type="submit" value="<%= Language.getTextfield(session, "suche", "Suchen")%>" />
                    </p>
                </form>
            </div>
        </div>

        <div id="tab4">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab4');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a></li>
                    <li><a href="javascript:onoff('tab2','tab4');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a></li>
                    <li><a href="javascript:onoff('tab3','tab4');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a></li>
                    <li><span>
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </span></li>
                    <li><a href="javascript:onoff('tab5','tab4');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a></li>
                    <li><a href="javascript:onoff('tab6','tab4');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a></li>
                    <li><a href="javascript:onoff('tab8','tab4');">
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </a></li>
                </ul>
            </div>
            <div id="main">
                <p><% Language.printTextfield(out, session, "suche", "Folgt");%></p>
            </div>
        </div>

        <div id="tab5">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab5');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab2','tab5');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab3','tab5');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab5');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li>
                        <span>
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </span>
                    </li>
                    <li><a href="javascript:onoff('tab6','tab5');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab8','tab5');">
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </a>
                    </li>
                </ul>
            </div>
            <div id="main">
                <p><% Language.printTextfield(out, session, "suche", "Folgt");%></p>
            </div>
        </div>

        <div id="tab6">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab6');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab2','tab6');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab3','tab6');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab6');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab5','tab6');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a>
                    </li>
                    <li>
                        <span>
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </span>
                    </li>
                    <li><a href="javascript:onoff('tab8','tab6');">
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </a>
                    </li>
                </ul>
            </div>
            <div id="main">
                <form method="post" action="suchergebnis"><input
                        type="hidden" name="form" value="namenkommentar" />
                    <table>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "suche", "Zwischenlemma");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Zwischenlemma" />
                            </td>
                        </tr>
                        <tr>
                            <th width="200"><% Language.printTextfield(out, session, "suche", "Namenelement");%></th>
                            <td width="450">
                                <input type="text" size="50" name="Namenelement" disabled />
                            </td>
                        </tr>
                    </table>
                    <br>
                    <h2><% Language.printTextfield(out, session, "suche", "Ausgabefelder");%></h2>
                    <table>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeLink" checked disabled />
                            </td>
                            <td width="200"><% Language.printTextfield(out, session, "suche", "Link");%></td>
                            <td>
                                <input type="checkbox" name="AusgabeZwischenlemma" checked disabled />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Zwischenlemma");%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="AusgabeNamenelement" />
                            </td>
                            <td width="200">
                                <% Language.printTextfield(out, session, "suche", "Namenelement");%>
                            </td>
                        </tr>
                    </table>
                    <p>
                        <input type="reset" value="<%= Language.getTextfield(session, "suche", "Abbrechen")%>" />&nbsp;&nbsp;
                       <input type="submit" value="<%= Language.getTextfield(session, "suche", "Suchen")%>" />
                    </p>
                </form>
            </div>
        </div>

        <div id="tab8">
            <div id="header">
                <ul id="primary">
                    <li><a href="javascript:onoff('tab1','tab8');">
                            <% Language.printTextfield(out, session, "suche", "TabLemma");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab2','tab8');">
                            <% Language.printTextfield(out, session, "person", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab3','tab8');">
                            <% Language.printTextfield(out, session, "quelle", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab4','tab8');">
                            <% Language.printTextfield(out, session, "edition", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab5','tab8');">
                            <% Language.printTextfield(out, session, "handschrift", "Titel");%>
                        </a>
                    </li>
                    <li><a href="javascript:onoff('tab6','tab8');">
                            <% Language.printTextfield(out, session, "namenkommentar", "Titel");%>
                        </a>
                    </li>
                    <li>
                        <span>
                            <% Language.printTextfield(out, session, "suche", "TabFavoriten");%>
                        </span>
                    </li>
                </ul>
            </div>
            <div id="main">
                <form method="post" action="suchergebnis">
                    <input type="hidden" name="form" value="favorit" />

                    <%
                        String text = Language.getTextfield(session, "suche", "Testweise");

                        String link = "<a href=\"person?ID=21812\">";
                        String end = "</a>";

                        text = text.replace("{Link}", link);
                        text = text.replace("{end}", end);

                    %>

                    <p><%= text%></p>
                    <p>
                       <input type="reset" value="<%= Language.getTextfield(session, "suche", "Abbrechen")%>" />&nbsp;&nbsp;
                       <input type="submit" value="<%= Language.getTextfield(session, "suche", "Suchen")%>" />
                    </p>
                </form>
            </div>
        </div>
    </div>
</div>
