<%@ page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@ page import="java.sql.*" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Constants" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ include file="functions.jsp" %>
<%@ include file="configuration.jsp"%>

<%    int urkundeid = Constants.UNDEFINED_ID;
    String formular = "quelle";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
    int id = Utils.determineId(request, response, formular, out);

    if (id != Constants.NEW_ITEM && (id == Constants.UNDEFINED_ID || QuelleDB.getById(id) == null)) {
        if (session.getAttribute("Sprache").equals("de")) {
            throw new IdNotFoundException("Quellen ID Q" + String.valueOf(id) + " ist nicht vorhanden");
        } else {
            throw new IdNotFoundException("Source ID Q" + String.valueOf(id) + " does not exist");
        }
    }
    //only determine the urkunde id for an existing quelle record
    if (id != Constants.UNDEFINED_ID && id != Constants.NEW_ITEM) {
        urkundeid = UrkundeDB.determineUrkundeId(id);
    }
%>

<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="quelle" />
    <jsp:param name="ID" value="<%= id%>" />
</jsp:include>
<jsp:include page="dosave.jsp">
    <jsp:param name="form" value="urkunde" />
    <jsp:param name="ID" value="<%= urkundeid%>" />
</jsp:include>
<jsp:include page="dojump.jsp">
    <jsp:param name="form" value="quelle" />
</jsp:include>

<div
    onLoad="javascript:onoff('tab4', 'tab1'); onoff('tab1', 'tab4');urlRewrite(<%=id%>);">
    <FORM method="POST">
        <jsp:include
            page="layout/titel.inc.jsp">
            <jsp:param name="title" value="Quelle" />
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="size" value="" />
            <jsp:param name="Formular" value="quelle" />
        </jsp:include>

        <jsp:include page="inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value="<%= id%>" />
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Datenfeld" value="ID" />
            <jsp:param name="size" value="11" />
        </jsp:include>

        <div id="form">
            <table style="width:100%;">
                <tbody>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Bezeichnung");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="Bezeichnung" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>
                        </td>
                        <td>
                            <span style="float:right;display:block;font-weight:bold;">
                                <jsp:include page="forms/id.jsp">
                                    <jsp:param name="ID" value="<%=id%>"/>
                                    <jsp:param name="title" value="quelle"/>
                                </jsp:include>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Quellenkommentar");%>
                        </td>

                        <%
                            if (id != -1 && QuelleDB.getById(id).getQuellenKommentarDatei() != null && !QuelleDB.getById(id).getQuellenKommentarDatei().equals("")) {
                                int fileId = 1;
                                boolean fileExist = false;

                                Content content = new Content();

                                if (!QuelleDB.getById(id).getQuellenKommentarDatei().equals("")) {

                                    fileId = Integer.parseInt(QuelleDB.getById(id).getQuellenKommentarDatei());
                                    fileExist = ContentDB.searchId(fileId);  //serachID(fileName)

                                    if (fileExist) {
                                        if (fileExist) {
                                            content = ContentDB.getById(fileId);  //getByIde(fileID)
                                        }

                                        String name = content.getName();
                                        String fileUrl = Utils.getBaseUrl(request) + "/content?name=" + urlEncode(name);

                        %>
                        <td width="450">
                            <div style="display: inline-block;">
                                <a href="<%=fileUrl%>" target="_blank"><%=name%></a>
                                <a href="javascript:deleteFile('quelle', 'QuellenKommentarDatei', <%= id%>, 'quelle');">
                                    <img src="layout/icons/delete2.gif" border="0" alt="<%= DBtoHTML(Language.getTextfield(session, "quelle", "Delete"))%>" title="<%= DBtoHTML(Language.getTextfield(session, "quelle", "Delete"))%>">
                                </a>
                            </div>
                        </td>
                        <td>&nbsp;</td>
                        <%
                                }
                            }
                        } else {

                        %>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="QuellenKommentar" />
                                <jsp:param name="type" value="file" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                        <%
                            }
                        %>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Ueberlieferungskommentar");%>
                        </td>
                        <%

                            if (id != -1 && QuelleDB.getById(id).getUeberlieferungsKommentarDatei() != null && !QuelleDB.getById(id).getUeberlieferungsKommentarDatei().equals("")) {
                                int fileId = 1;
                                boolean fileExist = false;

                                Content content = new Content();

                                if (!QuelleDB.getById(id).getUeberlieferungsKommentarDatei().equals("")) {

                                    fileId = Integer.parseInt(QuelleDB.getById(id).getUeberlieferungsKommentarDatei());
                                    fileExist = ContentDB.searchId(fileId);  //serachID(fileName)

                                    if (fileExist) {

                                        if (fileExist) {
                                            content = ContentDB.getById(fileId);  //getByIde(fileID)
                                        }

                                        String name = content.getName();
                                        String fileUrl = Utils.getBaseUrl(request) + "/content?name=" + urlEncode(name);
                        %>
                        <td width="450">
                            <div style="display: inline-block;">
                                <a href="<%=fileUrl%>" target="_blank"><%=name%></a>
                                <a href="javascript:deleteFile('quelle', 'UeberlieferungsKommentarDatei', <%= id%>, 'quelle');">
                                    <img src="layout/icons/delete2.gif" border="0" alt="<%= DBtoHTML(Language.getTextfield(session, "quelle", "Delete"))%>" title="<%= DBtoHTML(Language.getTextfield(session, "quelle", "Delete"))%>">
                                </a>
                            </div>
                        </td>
                        <td>&nbsp;</td>
                        <%
                                }
                            }
                        } else {
                        %>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="UeberlieferungsKommentar" />
                                <jsp:param name="type" value="file" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                        <%
                            }
                        %>
                    </tr>
                    <tr>
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "ZuVeroeffentlichen");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="ZuVeroeffentlichen" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "Quellengattung");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%=id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="Quellengattung" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>                        
                        <td width="200">
                            <% Language.printDatafield(out, session, formular, "Geschichtsquellen");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="Geschichtsquellen" />
                                <jsp:param name="size" value="50" />
                            </jsp:include>

                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%=id%>" />
                                <jsp:param name="Formular" value="quelle" />
                                <jsp:param name="Datenfeld" value="GeschichtsquellenLink" />
                            </jsp:include>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </tbody>
            </table>
            <br>
            <table class="date">
                <tbody>
                    <tr>
                        <th class="date" colspan="2">
                            <% Language.printTextfield(out, session, formular, "Datierung");%>
                        </th>
                    </tr>
                    <tr>
                        <td width="200" valign="top">
                            <% Language.printDatafield(out, session, formular, "DatumVon");%>
                        </td>
                        <td width="450">
                            <jsp:include page="inc.erzeugeFormular.jsp">
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
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
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
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
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
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
                                <jsp:param name="ID" value="<%= id%>" />
                                <jsp:param name="Formular" value="quelle" />
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
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabEdition");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabUrkunde");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab1');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="quelle" />
                        <jsp:param name="Datenfeld" value="Edition" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab2">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabEdition");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabUrkunde");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab2');">
                                <% Language.printTextfield(out, session, formular, "TabBemerkungen");%>
                            </a>
                        </li>
                    </ul>
                </div>
                <div id="main">
                    <jsp:include page="inc.modul.jsp">
                        <jsp:param name="ID" value="<%= id%>" />
                        <jsp:param name="Formular" value="quelle" />
                        <jsp:param name="Modul" value="ueberlieferung" />
                    </jsp:include>
                </div>
            </div>

            <div id="tab3">
                <div id="header">
                    <ul id="primary">
                        <li><a href="javascript:onoff('tab1','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabEdition");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab3');">
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </a>
                        </li>
                        <li><span>
                                <% Language.printTextfield(out, session, formular, "TabUrkunde");%>
                            </span>
                        </li>
                        <li><a href="javascript:onoff('tab4','tab3');">
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
                                    <% Language.printDatafield(out, session, "urkunde", "Actumort");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= urkundeid%>" />
                                        <jsp:param name="Formular" value="urkunde" />
                                        <jsp:param name="Datenfeld" value="Actumort" />
                                        <jsp:param name="size" value="50" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, "urkunde", "Betreff");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= urkundeid%>" />
                                        <jsp:param name="Formular" value="urkunde" />
                                        <jsp:param name="returnID" value="<%= id%>" />
                                        <jsp:param name="Datenfeld" value="Betreff" />
                                        <jsp:param name="size" value="50" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, "urkunde", "Aussteller");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= urkundeid%>" />
                                        <jsp:param name="returnID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="urkunde" />
                                        <jsp:param name="Datenfeld" value="Aussteller" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, "urkunde", "Empfaenger");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= urkundeid%>" />
                                        <jsp:param name="returnID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="urkunde" />
                                        <jsp:param name="Datenfeld" value="Empfaenger" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <th width="200" valign="top">
                                    <% Language.printDatafield(out, session, "urkunde", "Dorsalnotiz");%>
                                </th>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= urkundeid%>" />
                                        <jsp:param name="returnID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="urkunde" />
                                        <jsp:param name="Datenfeld" value="Dorsalnotiz" />
                                        <jsp:param name="size" value="50" />
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
                                <% Language.printTextfield(out, session, formular, "TabEdition");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab2','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabUeberlieferung");%>
                            </a>
                        </li>
                        <li><a href="javascript:onoff('tab3','tab4');">
                                <% Language.printTextfield(out, session, formular, "TabUrkunde");%>
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
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "BemerkungAlle");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="quelle" />
                                        <jsp:param name="Datenfeld" value="BemerkungAlle" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "BemerkungGruppe");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="quelle" />
                                        <jsp:param name="Datenfeld" value="BemerkungGruppe" />
                                        <jsp:param name="cols" value="40" />
                                        <jsp:param name="rows" value="5" />
                                    </jsp:include>
                                </td>
                            </tr>
                            <tr>
                                <td width="200" valign="top">
                                    <% Language.printDatafield(out, session, formular, "BemerkungPrivat");%>
                                </td>
                                <td width="450">
                                    <jsp:include page="inc.erzeugeFormular.jsp">
                                        <jsp:param name="ID" value="<%= id%>" />
                                        <jsp:param name="Formular" value="quelle" />
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
                                        <jsp:param name="Formular" value="quelle" />
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
                                        <jsp:param name="Formular" value="quelle" />
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
                                        <jsp:param name="Formular" value="quelle" />
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
                                        <jsp:param name="Formular" value="quelle" />
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
                                        <jsp:param name="Formular" value="quelle" />
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
