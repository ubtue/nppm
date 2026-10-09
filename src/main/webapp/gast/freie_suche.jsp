<%@ page import="java.util.Date" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%    int id = -1;
    int filter = 0;
    String formular = "freie_suche";
%>
<div class="wrapper">

    <div class="container" >
        <div class="container" id="erweiterte-suche">
            <div class="container">
                <ul class="ut-tab-list ut-tab-list--color-primary-1" role="tablist" id="tab-list">
                    <li data-id="tab-1" class="ut-tab-list__item tab-1 search-button" role="presentation">
                        <a class="ut-link ut-tab-list__link active" href="#" aria-role="<% Language.printTextfield(out, session, formular, "Tab1"); %>"><% Language.printTextfield(out, session, formular, "Tab1"); %></a></li>
                    <li data-id="tab-2" class="ut-tab-list__item tab-2 search-button" role="presentation">
                        <a class="ut-link ut-tab-list__link" href="#" aria-role="<% Language.printTextfield(out, session, formular, "Tab2"); %>"><% Language.printTextfield(out, session, formular, "Tab2"); %></a></li>
                    <li data-id="tab-3" class="ut-tab-list__item tab-3 search-button" role="presentation">
                        <a class="ut-link ut-tab-list__link" href="#" aria-role="<% Language.printTextfield(out, session, formular, "Tab3"); %>"><% Language.printTextfield(out, session, formular, "Tab3"); %></a></li>
                </ul>
            </div>


            <FORM method="POST" action="suchergebnis">
                <input type="hidden" name="form" value="freie_suche">

                <!-- ##### SUCHFELDER ##### -->
                <div class="container" id="tab-1" >
                    <div style="display: flex; justify-content: flex-end; align-items: end;">
                        <h5 class="ut-heading ut-heading--h5"> <% Language.printTextfield(out, session, "gast_freie_suche", "Schritt1Von3"); %></h5>
                    </div>
                    <div class="clear"> </div>
                    <table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
                        <tbody>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "NPPMID"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="NPPMID"/>
                                        <jsp:param name="size" value="75"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Belegform"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Belegform"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Kontext"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Kontext"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "ErstZweitGlied"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche" />
                                        <jsp:param name="Datenfeld" value="ErstGliedSelect" />
                                    </jsp:include>/
                                    <div style="height: 5px;"></div>
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche" />
                                        <jsp:param name="Datenfeld" value="ZweitGliedSelect" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item" >
                                    <% Language.printDatafield(out, session, formular, "MGHLemma"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="MGHLemma"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item" >
                                    <% Language.printDatafield(out, session, formular, "Sprachherkunft"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Sprachherkunft"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Personenname"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Personenname"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Geschlecht"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Geschlecht"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "PersonZeitraum"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="PersonZeitraum"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "AmtWeihePerson"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="AmtWeihePerson"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "StandPerson"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="StandPerson"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "EthniePerson"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="EthniePerson"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "AmtWeiheEinzelbeleg"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="AmtWeiheEinzelbeleg"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, "gast_freie_suche", "StandEinzelbeleg"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="StandEinzelbeleg"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "EthnieEinzelbeleg"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="EthnieEinzelbeleg"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Quelle"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="gast_freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Quellenliste"/>
                                        <jsp:param name="FolgendeAuswahl" value="Yes"/>
                                    </jsp:include>
                                    <div style="height: 5px;"></div>
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Quelle"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "QuelleGattung"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="QuelleGattung"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "QuelleZeitraum"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="QuelleZeitraum"/>
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="text-align: right;">
                        <button data-id="tab-2" class="ut-btn ut-btn--color-primary-1 search-next search-button erweiterte_suche_next" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "WeiterZuSchritt2"); %>"  href="#erweiterte-suche">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "WeiterZuSchritt2"); %>
                        </button>
                    </div>

                    <div class="clear"> </div>
                </div>


                <!-- ##### AUSGABEFELDER ##### -->
                <div class="container hide" id="tab-2">
                    <div style="text-align: right;">
                        <h5 class="ut-heading ut-heading--h5" style="margin: 0;"><% Language.printTextfield(out, session, "gast_freie_suche", "Schritt2Von3"); %></h5>
                    </div>
                    <div class="clear"> </div>
                    <table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
                        <tbody class="ut-table__body">
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item" colspan="2">
                                    <h3 class="ut-heading ut-heading--h3">
                                        <% Language.printTextfield(out, session, "gast_freie_suche", "ZumNamen"); %>
                                    </h3>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_MGHLemma"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_MGHLemma"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Sprachherkunft"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Sprachherkunft"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">
                                    <h3 class="ut-heading ut-heading--h3">
                                        <% Language.printTextfield(out, session, "gast_freie_suche", "ZurPerson"); %>
                                    </h3></td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Person_Standardname"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Person_Standardname"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Person_AmtWeihe"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Person_AmtWeihe"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item"></td>
                                <td class="ut-table__item ut-table__body__item" colspan="2">
                                    <div style="display: flex;">
                                        <jsp:include page="../inc.erzeugeFormular.jsp">
                                            <jsp:param name="Formular" value="freie_suche"/>
                                            <jsp:param name="Datenfeld" value="Ausgabe_Person_AmtWeiheZeitraum"/>
                                        </jsp:include>
                                        <div style="padding-left: 5px;">
                                            <% Language.printDatafield(out, session, formular, "Ausgabe_Person_AmtWeiheZeitraum"); %>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Stand"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Stand"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Person_Ethnie"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Person_Ethnie"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Geschlecht"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Geschlecht"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>

                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">&nbsp;</td></tr>
                            <tr class="ut-table__row"><td class="ut-table__item ut-table__body__item" colspan="2">
                                    <h3 class="ut-heading ut-heading--h3">
                                        <% Language.printTextfield(out, session, "gast_freie_suche", "ZumEinzelbeleg"); %>
                                    </h3></td></tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Belegform"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Belegform"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Belegstelle"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Belegstelle"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_AmtWeihe"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_AmtWeihe"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Stand_Einzelbeleg"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Stand_Einzelbeleg"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Kontext"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Kontext"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Datierung"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Datierung"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_lebend"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_lebend"); %>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Varianten"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Varianten"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>

                            <!-- TODO: Oder als Teil von Belegstelle umsetzen? AuÃerdem: Label in GAST fehlt! -->
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="freie_suche"/>
                                        <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Quellengattung"/>
                                    </jsp:include>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Ausgabe_Einzelbeleg_Quellengattung"); %>
                                    <font color="blue"></font>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p align="right">
                        <a href="javascript:CheckAll(1, true, 'Ausgabe_')">

                        </a><br/><a href="javascript:CheckAll(1, false, 'Ausgabe_')">

                        </a><br/>
                        <a href="javascript:onoff('tab3','tab2');">

                        </a>
                    </p>
                    <div style="text-align: right;">
                        <button  class="ut-btn search-next search-functions" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "AlleAuswahlen"); %>"  onclick="CheckAll(1, true, 'Ausgabe_')">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "AlleAuswahlen"); %>
                        </button>
                    </div>
                    <div class="clear"></div>
                    <div style="text-align: right;">
                        <button  class="ut-btn search-next search-functions" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "AuswahlAufheben"); %>"  onclick="CheckAll(1, false, 'Ausgabe_')">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "AuswahlAufheben"); %>
                        </button>
                    </div>
                    <div class="clear"></div>
                    <div class="container" style="display: flex; justify-content: space-between; padding: 0;">
                        <button data-id="tab-1" class="ut-btn ut-btn--color-primary-1 search-next search-button left erweiterte_suche_prev" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "ZurueckZuSchritt1"); %>" onclick="window.location.href = '#erweiterte-suche';">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "ZurueckZuSchritt1"); %>
                        </button>
                        <div style="flex-grow: 1;"></div> <!-- Fügt flexibles Leerzeichen hinzu -->
                        <button data-id="tab-3" class="ut-btn ut-btn--color-primary-1 search-next search-button erweiterte_suche_next" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "WeiterZuSchritt3"); %>" href="#erweiterte-suche">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "WeiterZuSchritt3"); %>
                        </button>
                    </div>
                    <div class="clear"> </div>
                </div>

                <!-- ##### SORTIERUNG ##### -->
                <div class="container hide gruppierung" id="tab-3">
                    <div style="text-align: right;">
                        <h5 class="ut-heading ut-heading--h5" style="margin: 0;"><% Language.printTextfield(out, session, "gast_freie_suche", "Schritt3Von3"); %></h5>
                    </div>
                    <div class="clear"> </div>
                    <h3 class="ut-heading ut-heading--h3">
                        <% Language.printTextfield(out, session, formular, "Ueberschrift3"); %>
                    </h3>
                    <table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
                        <tbody class="ut-table__body">
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Sortierung1"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../forms/search.order.jsp">
                                        <jsp:param name="name" value="order1"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Sortierung2"); %>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../forms/search.order.jsp">
                                        <jsp:param name="name" value="order2"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr class="ut-table__row">
                                <td class="ut-table__item ut-table__body__item">
                                    <% Language.printDatafield(out, session, formular, "Sortierung3");%>
                                </td>
                                <td class="ut-table__item ut-table__body__item">
                                    <jsp:include page="../forms/search.order.jsp">
                                        <jsp:param name="name" value="order3"/>
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="text-align: right;">
                        <button id="addButton" class="ut-btn search-next search-functions" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "WeitereGruppierung"); %>">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "WeitereGruppierung"); %>
                        </button>
                    </div>
                    <div class="clear"></div>
                    <p> &nbsp; </p>

                    <div class="container" style="display: flex; justify-content: space-between; padding: 0;">
                        <button data-id="tab-2" class="ut-btn ut-btn--color-primary-1 search-next search-button left erweiterte_suche_prev" type="button" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "ZurueckZuSchritt2"); %>" onclick="window.location.href = '#erweiterte-suche';">
                            <% Language.printTextfield(out, session, "gast_freie_suche", "ZurueckZuSchritt2"); %>
                        </button>
                        <div style="flex-grow: 1;"></div> <!-- Fügt flexibles Leerzeichen hinzu -->
                        <button  class="ut-btn ut-btn--color-primary-1" type="reset" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "Zuruecksetzen"); %>" >
                            <% Language.printTextfield(out, session, "gast_freie_suche", "Zuruecksetzen"); %>
                        </button>
                        <span style="margin-right: 10px;"></span>
                        <button  class="ut-btn ut-btn--color-primary-1" type="submit" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "Suchen"); %>" >
                            <% Language.printTextfield(out, session, "gast_freie_suche", "Suchen");%>
                        </button>

                    </div>
                    <div class="clear"> </div>
                </div>
        </div>
    </div>
</FORM>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let tabs = document.querySelectorAll('.ut-tab-list__item');
        let buttons = document.querySelectorAll('.search-next');

        // Funktion zum Aktivieren des Tabs und Deaktivieren der anderen Tabs
        function activateTab(tabId) {
            // Alle Tabs inaktiv setzen
            tabs.forEach(function (tab) {
                tab.querySelector('a').classList.remove('active');
            });
            // Den angeklickten Tab aktiv setzen
            let activeTab = document.querySelector('[data-id="' + tabId + '"]');
            if (activeTab) {
                activeTab.querySelector('a').classList.add('active');
            }
        }

        // Event Listener für die Buttons hinzufügen
        buttons.forEach(function (button) {
            button.addEventListener('click', function () {
                let tabId = this.getAttribute('data-id');
                activateTab(tabId);
            });
        });

        // Event Listener für die Tabs hinzufügen
        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                let tabId = this.getAttribute('data-id');
                activateTab(tabId);
            });
        });
    });

    function CheckAll(index, check, praefix) {
        let forms = document.forms;
        let targetForm = null;
        for (let i = 0; i < forms.length; i++) {
            if (forms[i].querySelector('input[name^="' + praefix + '"]')) {
                targetForm = forms[i];
                break;
            }
        }
        if (!targetForm)
            return;

        for (let i = 0; i < targetForm.elements.length; i++) {
            if (targetForm.elements[i].type === "checkbox" && targetForm.elements[i].name.indexOf(praefix) > -1) {
                targetForm.elements[i].checked = check;
            }
        }
    }

    $(function () { // when document has loaded

        // replace [help] with link to help >>
        let p = $('.truncate-hint');
        p.html(p.text().trim().replace(/\[(.+)\]/, "<a class=\"ut-link\" href='hilfe'>$1</a>"));
        // <<

        let i = 4; // check how many input exists on the document and add 1 for the add command to work
        $('#addButton').click(function () { // when you click the add button
            if (i < 15) {
    <%
        out.print("$('<tr><th>Dann nach</th><td>");
        out.print("<select name=\"order'+i+'\">");
        out.print("  <option value=\"-1\">--</option>");

        String sprache = Constants.DEFAULT_LANG;
        if (session != null && session.getAttribute("Sprache") != null) {
            sprache = (String) session.getAttribute("Sprache");
        }

        try {
            List<java.util.Map> result = DatenbankDB.getMappedList("SELECT * FROM datenbank_texte WHERE Formular='freie_suche' AND Textfeld LIKE \"Order%\"");
            for (java.util.Map map : result) {
                out.print("<option value=\"" + map.get("Textfeld") + "\">");
                out.print(map.get(sprache));
                out.print("</option>");
            }
            out.print("</select>");

            out.print("<input type=\"radio\" name=\"order'+i+'ASCDESC\" value=\"ASC\" checked/>");
            out.print("aufsteigend");
            out.print(" &nbsp;");
            out.print(" <input type=\"radio\" name=\"order'+i+'ASCDESC\" value=\"DESC\" />");
            out.print("absteigend");
            out.print("<br>Zeitraum (nur f&uuml;r Datierung): <input type=\"text\" name=\"order'+i+'zeit\" />  ");

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        out.print("</td></tr>').appendTo('div#tab-3 table tbody');");
//    out.print("</td></tr>').appendTo('div#tab3 div#main table tbody');");
    %>
                // if you have the input inside a form, change body to form in the appendTo
                i++; //after the click i will be i = 3 if you click again i will be i = 4
            }
        });
    });
</script>

<%
   //global link for the css that is included in enableTooltips
   String btCssHref = Utils.getVersionedHref(request, application, "/layout/bt.css");
%>
<script type="text/javascript">
    // global machen
    window.btCssHref = "<%= btCssHref %>";
    enableTooltips();
</script>
