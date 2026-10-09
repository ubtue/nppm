<%@page import="de.uni_tuebingen.ub.nppm.db.PersonDB"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false"%>
<%@ page import="java.math.BigInteger" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>

<%@ include file="configuration.jsp"%>

<style>

#primary li {
    word-wrap: break-word; /* Erzwingt den Zeilenumbruch bei zu langem Text */
    white-space: normal; /* Damit der Text in die nächste Zeile fließen kann */
}

</style>


<%
    String formular = "person";
    Language.setLanguage(request);
    Filter.setFilter(request, formular, out);
    int id = Utils.determineId(request, response, formular, out);

    if(id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || PersonDB.getById(id) == null)){
         if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Person ID P" + String.valueOf(id) + " ist nicht vorhanden");
        } else{
            throw new IdNotFoundException("Person ID P" + String.valueOf(id) + " does not exist");
        }
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="person" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>

<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="person" />
</jsp:include>


<div
    onLoad="javascript:onoff('tab4', 'tab1'); onoff('tab1', 'tab4');urlRewrite(<%=id%>);">
    <FORM method="POST">
         <jsp:include page="layout/titel.inc.jsp">
            <jsp:param name="title" value="Person" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="person" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="person" />
            <jsp:param name="Datenfeld" value="ID" />
            <jsp:param name="size" value="11" />
        </jsp:include>

        <div id="form">
            <table style="width:100%;">
                <tbody>
                    <!--tr>
                  <td width="200">
                    <% Language.printDatafield(out, session, formular, "PKZ");%>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%=id%>"/>
                        <jsp:param name="Formular" value="person"/>
                        <jsp:param name="Datenfeld" value="PKZ"/>
                        <jsp:param name="size" value="25"/>
                    </jsp:include>
                  </td>
                  <td>&nbsp;</td>
                </tr-->
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Standardname");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="Standardname" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                        </td>
                        <td>
                            <span style="float:right;display:block;font-weight:bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>"/>
                                    <jsp:param name="title" value="person"/>
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Varianten");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="Varianten" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Geschlecht");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="Geschlecht" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Fiktiv");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="Fiktiv" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "Identifizierungsproblem");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="Identifizierungsproblem" />
                                <jsp:param name="cols" value="40" />
                                <jsp:param name="rows" value="5" />
                            </jsp:include>
                        </td>
                    </tr>
                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Modul" value="namen" />
                    </jsp:include>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "GND");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="GND" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>

                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%=id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="GNDLink" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "WikiData");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="WikiData" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>

                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%=id%>" />
                                <jsp:param name="Formular" value="person" />
                                <jsp:param name="Datenfeld" value="WikidataLink" />
                            </jsp:include>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div id="tab1">
                <div id="header">
                    <ul id="primary">
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab6','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="QuiEt" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab2">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab6','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="AmtWeihe" />
                    </jsp:include>
                    <br>

                    <table>
                        <tbody>
                            <tr>
                                <th width="200">
                                    <% Language.printDatafield(out, session, formular, "Stand");%>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="Stand" />
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
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </a>
                        </li>
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab6','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <table>
                        <tbody>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "Ethnie");%>
                                </th>
                                <td valign="top">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="Ethnie" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200">
                                    <% Language.printDatafield(out, session, formular, "Areal");%>
                                </th>
                                <td valign="top">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="Areal" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200">
                                    <% Language.printDatafield(out, session, formular, "GruppeHerkunft");%>
                                </th>
                                <td valign="top">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="GruppeHerkunft" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "KommentarEthnie");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="KommentarEthnie" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "KommentarAreal");%>
                                </th>
                                <td>
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="KommentarAreal" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
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
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab6','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="Verwandtschaft" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab5">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab6','tab5');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>"/>
                        <jsp:param name="Formular" value="person"/>
                        <jsp:param name="Datenfeld" value="Einzelbeleg"/>
                    </jsp:include>
                </div>
            </div>

            <div id="tab6">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab6');">
                                <% Language.printTextfield(out, session, formular, "TabZusatz");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab6');">
                                <% Language.printTextfield(out, session, formular, "TabASW");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab6');">
                                <% Language.printTextfield(out, session, formular, "TabEthnieAreal");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab6');">
                                <% Language.printTextfield(out, session, formular, "TabVerwandte");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab5','tab6');">
                                <% Language.printTextfield(out, session, formular, "TabEinzelbelege");%>
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="BemerkungPrivat" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200">
                                    <% Language.printDatafield(out, session, formular, "Bearbeitungsstatus");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="person" />
                                        <jsp:param name="Datenfeld" value="ErstelltVon" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </FORM>
</div>
