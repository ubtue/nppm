<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ include file="configuration.jsp"%>
<%@ include file="functions.jsp"%>

<%    int id = Constants.UNDEFINED_ID;
    String formular = "einzelbeleg";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
    id = Utils.determineId(request, response, formular, out);
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="einzelbeleg" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>
<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="einzelbeleg" />
</jsp:include>

<div>
    <FORM method="POST">
        <jsp:include
            page="layout/titel.inc.jsp">
            <jsp:param name="title" value="Einzelbeleg" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="einzelbeleg" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="ID" />
            <jsp:param name="size" value="11" />
        </jsp:include>

        <div id="form">
            <a href="einzelbeleg?ID=<%=id%>">
                <% Language.printTextfield(out, session, formular, "AusfuehrlicheSicht");%>
            </a>
            <table style="width: 100%;">
                <tbody>
                    <tr>
                        <td width="200">
                            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Belegform" />
                            </jsp:include>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Belegform" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                            <span style="float: right; display: block; font-weight: bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>" />
                                    <jsp:param name="title" value="einzelbeleg" />
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top"></td>
                        <td width="450"></td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <jsp:include
                                page="inc.erzeugeBeschriftung.jsp">
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Kontext" />
                            </jsp:include>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Kontext" />
                                <jsp:param name="cols" value="40" />
                                <jsp:param name="rows" value="5" />
                            </jsp:include></td>
                    </tr>
                </tbody>
            </table>
            <br>

            <table class="date">
                <tbody>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Quellennummer");%>
                        </td>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Quellennummer" />
                                <jsp:param name="size" value="20" />
                            </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="QuelleSuchen" />
                            </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="QuelleLink" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Edition");%>
                        </td>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Edition" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "EditionKapitel");%>
                        </td>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="EditionKapitel" />
                                <jsp:param name="size" value="20" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "EditionSeite");%>
                        </td>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="EditionSeite" />
                                <jsp:param name="size" value="20" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "QuelleDatierung");%>
                        </td>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Datenfeld" value="QuelleDatumVon" />
                            </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Datenfeld" value="QuelleDatumBis" />
                            </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="QuelleDatierung" />
                                <jsp:param name="Visibility" value="hidden" />
                                <jsp:param name="size" value="20" />
                            </jsp:include></td>
                    </tr>
                </tbody>
            </table>
            <p></p>

            <table class="date">
                <tbody>

                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "Textkritik");%>
                        </td>
                        <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Textkritik" />
                            </jsp:include></td>
                    </tr>
                </tbody>
            </table>
            <p></p>


            <table class="date">
                <tbody>
                    <tr>
                        <th width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "LebendVerstorben");%>
                        </th>
                        <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="LebendVerstorben" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <th width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "AmtWeihe");%>
                        </th>
                        <td><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="AmtWeihe" />
                            </jsp:include></td>
                    </tr>
                    <tr>
                        <td colspan="2"><jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="PersonID" />
                            </jsp:include></td>
                    </tr>
                </tbody>
            </table>

            <div id="tab5">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab5');">Textkritik</a></li>
                        <li><a href="javascript:onoff('tab2','tab5');">Belegstelle</a></li>
                        <li><a href="javascript:onoff('tab3','tab5');">Zum Namen</a></li>
                        <li><a href="javascript:onoff('tab4','tab5');">Zur Person</a></li>
                        <li><span>Bemerkungen</span></li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungAlle");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungAlle" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungGruppe");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungGruppe" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungPrivat");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungPrivat" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Bearbeitungsstatus");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Bearbeitungsstatus" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderung");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="LetzteAenderung" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderungVon");%>
                                </td>
                                <td><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="LetzteAenderungVon" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "Erstellt");%>
                                </td>
                                <td width="450"><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Erstellt" />
                                    </jsp:include></td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "ErstelltVon");%>
                                </td>
                                <td><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="ErstelltVon" />
                                    </jsp:include></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="DatumVon" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="GenauigkeitTag" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="GenauigkeitMonat" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="GenauigkeitJahr" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="GenauigkeitJahrhundert" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="DatumBis" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="DatierungUngewiss" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="KommentarDatierung" />
            <jsp:param name="cols" value="40" />
            <jsp:param name="rows" value="5" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Lemma" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Quellengattung" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Echtheit" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Griechisch" />
            <jsp:param name="size" value="50" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Diakritisch" />
            <jsp:param name="size" value="50" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="GrammatikGeschlecht" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Visibility" value="hidden" />
            <jsp:param name="Datenfeld" value="Kasus" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="Funktion" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include> <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="UeberlieferungDatierung" />
            <jsp:param name="size" value="20" />
            <jsp:param name="Visibility" value="hidden" />
        </jsp:include>

        <div style="visibility: hidden">
            <jsp:include
                page="inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value="<%= id%>" />
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Datenfeld" value="Belegnummer" />
                <jsp:param name="size" value="25" />
            </jsp:include>
            <jsp:include page="inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value="<%= id%>" />
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Datenfeld" value="generiereBelegnummer" />
            </jsp:include>
        </div>
    </FORM>
</div>
