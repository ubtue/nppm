<%@page import="de.uni_tuebingen.ub.nppm.db.LemmaDB"%>
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

<%    String formular = "mgh_lemma";
    Language.setLanguage(request);
    Filter.setFilter(request, formular, out);
    int id = Utils.determineId(request, response, formular, out);

    if (id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || LemmaDB.getById(id) == null)) {
        if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Lemma ID M" + String.valueOf(id) + " ist nicht vorhanden");
        } else {
            throw new IdNotFoundException("Lemma ID M" + String.valueOf(id) + " does not exist");
        }
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="mgh_lemma" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>
<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="mgh_lemma" />
</jsp:include>


<div
    onLoad="javascript:onoff('tab4', 'tab1'); onoff('tab1', 'tab4');urlRewrite(<%=id%>);">
    <FORM method="POST">
        <jsp:include page="layout/titel.inc.jsp">
            <jsp:param name="title" value="mgh_lemma" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="mgh_lemma" />
        </jsp:include>

        <div id="form">
            <table style="width:100%;">
                <tbody>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "MGHLemma");%>
                        </td>
                        <td width="600">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="mgh_lemma" />
                                <jsp:param name="Datenfeld" value="MGHLemma" />
                                <jsp:param name="size" value="25" />
                            </jsp:include>
                            <span style="float:right;display:block;font-weight:bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>"/>
                                    <jsp:param name="title" value="mghlemma"/>
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <% Language.printDatafield(out, session, formular, "Sprachherkunft");%>
                        </td>
                        <td>
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="mgh_lemma" />
                                <jsp:param name="Datenfeld" value="Sprachherkunft" />
                                <jsp:param name="size" value="25" />
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
                                <% Language.printTextfield(out, session, formular, "TabBearbeiter");%>
                            </span>
                        </li>
                        <li>
                            <a href="javascript:onoff('tab3','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBelege");%>
                            </a>
                        </li>
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
                                <td width="250" valign="top">
                                    <% Language.printDatafield(out, session, formular, "BearbeiterNeu");%>
                                </td>
                                <td width="200">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="mgh_lemma" />
                                        <jsp:param name="Datenfeld" value="BearbeiterNeu" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="250" valign="top">
                                    <% Language.printDatafield(out, session, formular, "KorrektorNeu");%>
                                </td>
                                <td width="200">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="mgh_lemma" />
                                        <jsp:param name="Datenfeld" value="KorrektorNeu" />
                                    </jsp:include>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="mgh_lemma" />
                        <jsp:param name="Modul" value="bearbeiter" />
                    </jsp:include>
                    <br>
                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="mgh_lemma" />
                        <jsp:param name="Modul" value="korrektor" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab3">
                <div id="header">
                    <ul id="primary">
                        <li>
                            <a href="javascript:onoff('tab1','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabBearbeiter");%>
                            </a>
                        </li>
                        <li>
                            <span>
                                <% Language.printTextfield(out, session, formular, "TabBelege");%>
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
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="mgh_lemma" />
                        <jsp:param name="Modul" value="belege" />
                    </jsp:include>
                </div>
            </div>


            <div id="tab4">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabBearbeiter");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabBelege");%>
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
                                        <jsp:param name="Datenfeld" value="BemerkungPrivat" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "Bearbeitungsstatus");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
                                        <jsp:param name="Datenfeld" value="LetzteAenderung" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="200">
                                    <% Language.printDatafield(out, session, formular, "LetzteAenderungVon");%>
                                </td>
                                <td><jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
                                        <jsp:param name="Formular" value="mgh_lemma" />
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
