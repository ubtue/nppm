<%@page import="de.uni_tuebingen.ub.nppm.db.HandschriftDB"%>
<%@ page import="java.sql.*" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>

<%@ include file="configuration.jsp"%>

<%    String formular = "handschrift";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
    int id = Utils.determineId(request, response, formular, out);

    if (id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || HandschriftDB.getById(id) == null)) {
        if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Textzeugen ID T" + String.valueOf(id) + " ist nicht vorhanden");
        } else {
            throw new IdNotFoundException("Text attestor ID T" + String.valueOf(id) + " does not exist");
        }
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="handschrift" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>
<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="handschrift" />
</jsp:include>

<div
    onLoad="javascript:onoff('tab2', 'tab1'); onoff('tab1', 'tab2');urlRewrite(<%=id%>);">
    <FORM method="POST">
        <jsp:include page="layout/titel.inc.jsp">
            <jsp:param name="formTitle" value="Textzeugen" />
            <jsp:param name="title" value="Handschrift" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="handschrift" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="handschrift" />
            <jsp:param name="Datenfeld" value="ID" />
            <jsp:param name="size" value="" />
        </jsp:include>

        <div id="form">
            <table style="width:100%;">
                <tbody>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "Bibliothekssignatur");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="handschrift" />
                                <jsp:param name="Datenfeld" value="Bibliothekssignatur" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                            <span style="float:right;display:block;font-weight:bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>"/>
                                    <jsp:param name="title" value="handschrift"/>
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <br>

            <div id="tab1">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab2','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="handschrift" />
                        <jsp:param name="Datenfeld" value="Ueberlieferung" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab2">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </a>
                        </li>
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
                                        <jsp:param name="Formular" value="handschrift" />
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
