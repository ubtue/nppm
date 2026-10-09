<%@page import="de.uni_tuebingen.ub.nppm.db.EditionDB"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>

<%@ include file="configuration.jsp" %>

<%    String formular = "edition";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
    int id = Utils.determineId(request, response, formular, out);

    //If we have deleted the edition with ID = -2, this should be used.
    //if (id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || EditionDB.getById(id) == null)) {
    if (id != Constants.NEW_ITEM && (EditionDB.getById(id) == null)) {
        if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Edition ID E" + String.valueOf(id) + " ist nicht vorhanden");
        } else {
            throw new IdNotFoundException("Edition ID E" + String.valueOf(id) + " does not exist");
        }
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="edition" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>
<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="edition" />
</jsp:include>

<div onLoad="javascript:onoff('tab4', 'tab1'); onoff('tab1', 'tab4');urlRewrite(<%= id%>);">
    <FORM method="POST">
        <jsp:include page="layout/titel.inc.jsp">
            <jsp:param name="title" value="Edition" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="edition" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>"/>
            <jsp:param name="Formular" value="edition"/>
            <jsp:param name="Datenfeld" value="ID"/>
            <jsp:param name="size" value="11"/>
        </jsp:include>

        <div id="form">
            <table style="width:100%;">
                <tbody>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Titel");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Titel"/>
                                <jsp:param name="size" value="50"/>
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                            <span style="float:right;display:block;font-weight:bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>"/>
                                    <jsp:param name="title" value="edition"/>
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Quelle");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Quelle"/>
                                <jsp:param name="size" value="50"/>
                            </jsp:include>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Jahr");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Jahr"/>
                            </jsp:include>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Ort");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Ort"/>
                            </jsp:include>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Reihe");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Reihe"/>
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <% Language.printDatafield(out, session, formular, "Band");%>
                        </td>
                        <td>
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Band"/>
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "dMGHBand");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="dMGHBand"/>
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Zitierweise");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="Zitierweise"/>
                                <jsp:param name="size" value="50"/>
                            </jsp:include>
                            &nbsp;
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Datenfeld" value="GeneriereZitierweise"/>
                            </jsp:include>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td width="200">
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>"/>
                                <jsp:param name="Formular" value="edition"/>
                                <jsp:param name="Visibility" value="hidden"/>
                                <jsp:param name="Datenfeld" value="Seiten"/>
                            </jsp:include>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

            <div id="tab1">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabEditoren");%>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab5','tab1');">
                                <% Language.printTextfield(out, session, "quelle", "TabUeberlieferung");%>
                            </a></li>
                        <!-- TAB BAENDE & QUELLEN
                                      <li>
                                        <a href="javascript:onoff('tab2','tab1');">
                        <% Language.printTextfield(out, session, formular, "TabBaende");%>
                    </a>
                  </li>
                  <li>
                    <a href="javascript:onoff('tab3','tab1');">
                        <% Language.printTextfield(out, session, formular, "TabQuellen");%>
                    </a>
                  </li>
                        -->
                        <li>
                            <a href="javascript:onoff('tab4','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <th width="200"valign="top">
                                    <% Language.printDatafield(out, session, formular, "Editor");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="Editor"/>
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab5">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabEditoren");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, "quelle", "TabUeberlieferung");%>
                            </span>
                        </li>
                        <!-- TAB BAENDE & QUELLEN
                                      <li>
                                        <a href="javascript:onoff('tab2','tab1');">
                        <% Language.printTextfield(out, session, formular, "TabBaende");%>
                        </a>
                      </li>
                      <li>
                        <a href="javascript:onoff('tab3','tab1');">
                        <% Language.printTextfield(out, session, formular, "TabQuellen");%>
                     </a>
                   </li>
                        -->
                        <li>
                            <a href="javascript:onoff('tab4','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="edition" />
                        <jsp:param name="Modul" value="ueberlieferung" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab2">

                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabEditoren");%>
                            </a>
                        </li>
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabBaende");%>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab3','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabQuellen");%>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab4','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>"/>
                        <jsp:param name="Formular" value="edition"/>
                        <jsp:param name="Datenfeld" value="Baende"/>
                    </jsp:include>
                </div>
            </div>

            <div id="tab3">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabEditoren");%>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab2','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBaende");%>
                            </a>
                        </li>
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabQuellen");%>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab4','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>"/>
                        <jsp:param name="Formular" value="edition"/>
                        <jsp:param name="Modul" value="quellen"/>
                    </jsp:include>
                </div>
            </div>

            <div id="tab4">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabEditoren");%>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab5','tab4');">
                                <% Language.printTextfield(out, session, "quelle", "TabUeberlieferung");%>
                            </a>
                        </li>
                        <!-- TAB B�NDE & QUELLEN
                                      <li>
                                        <a href="javascript:onoff('tab2','tab4');">
                        <% Language.printTextfield(out, session, formular, "TabBaende");%>
                    </a>
                  </li>
                  <li>
                    <a href="javascript:onoff('tab3','tab4');">
                        <% Language.printTextfield(out, session, formular, "TabQuellen");%>
                    </a>
                  </li>
                        -->
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </span>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungAlle");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="BemerkungAlle"/>
                                        <jsp:param name="cols" value="40"/>
                                        <jsp:param name="rows" value="5"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungGruppe");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="BemerkungGruppe"/>
                                        <jsp:param name="cols" value="40"/>
                                        <jsp:param name="rows" value="5"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungPrivat");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="BemerkungPrivat"/>
                                        <jsp:param name="cols" value="40"/>
                                        <jsp:param name="rows" value="5"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Bearbeitungsstatus");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="Bearbeitungsstatus"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderung");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="LetzteAenderung"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderungVon");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="LetzteAenderungVon"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "Erstellt");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="Erstellt"/>
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "ErstelltVon");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>"/>
                                        <jsp:param name="Formular" value="edition"/>
                                        <jsp:param name="Datenfeld" value="ErstelltVon"/>
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>"/>
                        <jsp:param name="Formular" value="edition"/>
                        <jsp:param name="Datenfeld" value="Sammelband"/>
                        <jsp:param name="Visibility" value="hidden"/>
                    </jsp:include>
                </div>
            </div>
        </div>
    </FORM>
</div>
