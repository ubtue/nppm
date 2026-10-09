<%@ page import="java.sql.*" isThreadSafe="false"%>
<%@ page import="java.util.List" isThreadSafe="false"%>
<%@ page import="java.math.BigInteger" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>

<%@ include file="configuration.jsp"%>
<%@ include file="functions.jsp"%>


<%
    String formular = "einzelbeleg";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
    int id = Utils.determineId(request, response, formular, out);

    if(id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || EinzelbelegDB.getById(id) == null)){
        if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Einzelbeleg ID B" + String.valueOf(id) + " ist nicht vorhanden");
        } else{
            throw new IdNotFoundException("Single Reference ID B" + String.valueOf(id) + " does not exist");
        }
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="einzelbeleg" />
    <jsp:param name="ID" value='<%=id%>' />
</jsp:include>

<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="einzelbeleg" />
</jsp:include>

<div
    onLoad="javascript:onoff('tab4', 'tab1'); onoff('tab1', 'tab4');urlRewrite(<%=id%>);">
    <FORM method="POST">
        <jsp:include page="layout/titel.inc.jsp">
            <jsp:param name="title" value="Einzelbeleg" />
            <jsp:param name="ID" value='<%=id%>' />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="einzelbeleg" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%=id%>' />
            <jsp:param name="Formular" value="einzelbeleg" />
            <jsp:param name="Datenfeld" value="ID" />
            <jsp:param name="size" value="11" />
        </jsp:include>

        <div id="form">
            <a href="einzelbeleg_comp?ID=<%=id%>">
                <% Language.printTextfield(out, session, formular, "KompakteSicht");%>
            </a>
            <table style="width: 100%;">
                <tbody>
                    <!--tr>
<td width="200">
                    <% Language.printDatafield(out, session, formular, "Belegnummer");%>
                  </td>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>'/>
                        <jsp:param name="Formular" value="einzelbeleg"/>
                        <jsp:param name="Datenfeld" value="Belegnummer"/>
                        <jsp:param name="size" value="25"/>
                    </jsp:include>
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>'/>
                        <jsp:param name="Formular" value="einzelbeleg"/>
                        <jsp:param name="Datenfeld" value="generiereBelegnummer"/>
                    </jsp:include>
                  </td>
                </tr-->
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Belegform");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Belegform" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                            <span style="float: right; display: block; font-weight: bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value='<%=id%>' />
                                    <jsp:param name="title" value="einzelbeleg" />
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "PalAbgrenzung");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="PalAbgrenzung" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "InhAbgrenzung");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="InhAbgrenzung" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "NrInStrukt");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="NrInStrukt" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "Lemma");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Lemma" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "MGHLemma");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="MGHLemma" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "KritikSelektion");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="KritikSelektion" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "AngabenPerson");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="AngabenPerson" />
                            </jsp:include>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br>
            <table class="date">
                <tr>
                    <th class="date" colspan="2">
                        <% Language.printTextfield(out, session, formular, "Kontext"); %>
                    </th>
                </tr>
                <tr>
                    <td width="200" valign="top">
                        <% Language.printDatafield(out, session, formular, "Kontext_vor");%>
                    </td>
                    <td width="450">
                        <jsp:include page="inc.erzeugeFormular.jsp">
                            <jsp:param name="ID" value='<%=id%>' />
                            <jsp:param name="Formular" value="einzelbeleg" />
                            <jsp:param name="Datenfeld" value="Kontext_vor" />
                            <jsp:param name="cols" value="40" />
                            <jsp:param name="rows" value="5" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td width="200" valign="top">
                        <% Language.printDatafield(out, session, formular, "Kontext");%>
                    </td>
                    <td width="450">
                        <jsp:include page="inc.erzeugeFormular.jsp">
                            <jsp:param name="ID" value='<%=id%>' />
                            <jsp:param name="Formular" value="einzelbeleg" />
                            <jsp:param name="Datenfeld" value="Kontext" />
                            <jsp:param name="cols" value="40" />
                            <jsp:param name="rows" value="5" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td width="200" valign="top">
                        <% Language.printDatafield(out, session, formular, "Kontext_nach");%>
                    </td>
                    <td width="450">
                        <jsp:include page="inc.erzeugeFormular.jsp">
                            <jsp:param name="ID" value='<%=id%>' />
                            <jsp:param name="Formular" value="einzelbeleg" />
                            <jsp:param name="Datenfeld" value="Kontext_nach" />
                            <jsp:param name="cols" value="40" />
                            <jsp:param name="rows" value="5" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td width="200" valign="top">
                        <% Language.printDatafield(out, session, formular, "KontextSelektion");%>
                    </td>
                    <td width="450">
                        <jsp:include page="inc.erzeugeFormular.jsp">
                            <jsp:param name="ID" value='<%=id%>' />
                            <jsp:param name="Formular" value="einzelbeleg" />
                            <jsp:param name="Datenfeld" value="KontextSelektion" />
                        </jsp:include>
                    </td>
                </tr>
            </table>
            <br>
            <!-- Raster Group (same style as date group)-->
            <table class="date">
                <tbody>
                    <tr>
                        <th class="date" colspan="2">
                            <% Language.printTextfield(out, session, formular, "Grid"); %>
                        </th>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Seite");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Seite" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>

                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Raster");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Raster" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>

                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Schreiber");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="Schreiber" />
                                <jsp:param name="size" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br>
            <table class="date">
                <tbody>
                    <tr>
                        <th class="date" colspan="2">
                            <% Language.printTextfield(out, session, formular, "Datierung"); %>
                        </th>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "DatumVon");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="DatumVon" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "DatumBis");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="DatumBis" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "DatierungUngewiss");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="DatierungUngewiss" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "KommentarDatierung");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value='<%=id%>' />
                                <jsp:param name="Formular" value="einzelbeleg" />
                                <jsp:param name="Datenfeld" value="KommentarDatierung" />
                                <jsp:param name="cols" value="40" />
                                <jsp:param name="rows" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div id="tab1">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabBelegstelle"); %>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab2','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabTextkritik"); %>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab3','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabNamen"); %>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab4','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabPerson"); %>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab5','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen"); %>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Quellennummer");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Quellennummer" />
                                        <jsp:param name="size" value="20" />
                                    </jsp:include>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="QuelleSuchen" />
                                    </jsp:include>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="QuelleLink" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Edition");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Edition" />
                                    </jsp:include>

                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="EditionLink" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "EditionKapitel");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="EditionKapitel" />
                                        <jsp:param name="size" value="20" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "EditionSeite");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="EditionSeite" />
                                        <jsp:param name="size" value="20" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "QuelleDatierung");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Datenfeld" value="QuelleDatumVon" />
                                    </jsp:include>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Datenfeld" value="QuelleDatumBis" />
                                    </jsp:include>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="QuelleDatierung" />
                                        <jsp:param name="Visibility" value="hidden" />
                                        <jsp:param name="size" value="20" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="UeberlieferungDatierung" />
                                        <jsp:param name="Visibility" value="hidden" />
                                        <jsp:param name="size" value="20" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab2">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabBelegstelle"); %>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabTextkritik"); %>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabNamen"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabPerson"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Echtheit");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Echtheit" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Textkritik");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Textkritik" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>



            <div id="tab3">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBelegstelle"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabTextkritik"); %>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabNamen"); %>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabPerson"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Griechisch");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Griechisch" />
                                        <jsp:param name="size" value="50" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Diakritisch");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Diakritisch" />
                                        <jsp:param name="size" value="50" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "GrammatikGeschlecht");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="GrammatikGeschlecht" />
                                    </jsp:include>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Kasus");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Kasus" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab4">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabBelegstelle"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabTextkritik"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabNamen"); %>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabPerson"); %>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>

                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>' />
                        <jsp:param name="Formular" value="einzelbeleg" />
                        <jsp:param name="Datenfeld" value="PersonID" />
                    </jsp:include>

                    <table>
                        <tbody>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "LebendVerstorben");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="LebendVerstorben" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "AmtWeihe");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="AmtWeihe" />
                                    </jsp:include>
                                </td>
                            </tr>

                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Konvent");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Konvent" />
                                    </jsp:include>
                                </td>
                            </tr>

                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "BeziehungGemeinschaft");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BeziehungGemeinschaft" />
                                    </jsp:include>
                                </td>
                            </tr>

                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Ethnie");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Ethnie" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Stand");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Stand" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "TitelText");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="TitelText" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "TitelKritik");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="TitelKritik" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Kommentar");%>
                                </th>
                                <td valign="top">
                                    <jsp:include
                                        page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Kommentar" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>' />
                        <jsp:param name="Formular" value="einzelbeleg" />
                        <jsp:param name="Datenfeld" value="Funktion" />
                    </jsp:include>
                    <br />

                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>' />
                        <jsp:param name="Formular" value="einzelbeleg" />
                        <jsp:param name="Datenfeld" value="NewAreal" />
                    </jsp:include>


                </div>
            </div>

            <div id="tab5">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabBelegstelle"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabTextkritik"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabNamen"); %>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabPerson"); %>
                            </a>
                        </li>
                        <li><span>
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
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungAlle" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungGruppe");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungGruppe" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "BemerkungPrivat");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="BemerkungPrivat" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Bearbeitungsstatus");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Bearbeitungsstatus" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderung");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="LetzteAenderung" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderungVon");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="LetzteAenderungVon" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "Erstellt");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="Erstellt" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "ErstelltVon");%>
                                </td>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value='<%=id%>' />
                                        <jsp:param name="Formular" value="einzelbeleg" />
                                        <jsp:param name="Datenfeld" value="ErstelltVon" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div style="visibility: hidden">
            <jsp:include page="inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%=id%>' />
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Datenfeld" value="Belegnummer" />
                <jsp:param name="size" value="25" />
            </jsp:include>
            <jsp:include page="inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%=id%>' />
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Datenfeld" value="generiereBelegnummer" />
            </jsp:include>
        </div>
    </FORM>
</div>
