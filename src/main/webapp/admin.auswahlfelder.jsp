<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@page import="java.math.BigInteger" isThreadSafe="false" %>
<%@page import="java.util.*" isThreadSafe="false" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="configuration.jsp" %>
<%@include file="functions.jsp" %>

<div>
    <jsp:include page="layout/titel.administration.jsp" />
    <div id="form">

        <%
            if (request.getParameter("Formular") != null && request.getParameter("Formular").equals("baumstruktur")) {
        %>
        <h1><%= Language.getTextfield(session, "admin", "BaumstrukturBearbeiten")%></h1>
        <h2><%= Language.getTextfield(session, "admin", "Tabelle")%>: ${fn:escapeXml(param.Tabelle)}</h2>
        <p><%=  DBtoHTML(Language.getTextfield(session, "admin", "DragAndDrop"))%></p>

        <!-- Buttons to Expand and Collapse Tree -->
        <button id="collapseAllButton"><%= Language.getTextfield(session, "admin", "AllesZuklappen")%></button>
        <button id="expandAllButton"><%= Language.getTextfield(session, "admin", "AllesAufklappen")%></button>

        <br><br>

        <div id="data">
            <!-- The jsTree is created here -->
        </div>


        <script>
            $(document).ready(function () {

                let ajaxUrl = '<%= Utils.getAjaxUrl(request)%>';


                // Get source data from database
                let myQuelle = <%=SelektionDB.getListHierarchyJson(request.getParameter("Tabelle"))%>;

                // Create jsTree structure from the source data
                let treeData = [];
                for (let i = 0; i < myQuelle.length; i++) {
                    let quelle = myQuelle[i];
                    let node = {
                        id: quelle.id,
                        text: quelle.bezeichnung,
                        parent: (quelle.parent !== null) ? quelle.parent.id : "#"
                    };
                    treeData.push(node);
                }

                // Initialize jstree component with dynamic data source
                $("#data").jstree({
                    "core": {
                        "data": treeData,
                        "check_callback": true // Allow moving nodes
                    },
                    "plugins": ["dnd", "sort"]
                });

                // Button to expand the tree
                $("#expandAllButton").on("click", function () {
                    $("#data").jstree("open_all");
                });

                // Button to collapse the tree
                $("#collapseAllButton").on("click", function () {
                    $("#data").jstree("close_all");
                });

                $("#data").on("move_node.jstree", function (e, data) {
                    let nodeId = data.node.id;
                    let newParentId = data.parent;

                    // Check if newParentId is undefined, null or empty and set it to Null
                    if (typeof newParentId === "undefined" || newParentId === undefined || newParentId === null || newParentId === "" || newParentId === "#") {
                        newParentId = null;
                    }

                    // Send the data to the servlet via AJAX
                    $.ajax({
                        url: ajaxUrl, //  URL path to the servlet
                        method: "POST",
                        data: {
                            action: "newParentNode",
                            id: nodeId,
                            parentId: newParentId,
                            Tabelle: '${param.Tabelle}'
                        },
                        error: function (error) {

                            console.error("Error updating Parent ID:", error);
                            console.log("Failed newParentId:", newParentId);
                        }
                    });
                });
            });
        </script>


        <%             } else {
        %>





        <%            int rowCounter = 0;
            String editMessage = (String) request.getAttribute("editMessage");
            String moveMessage = (String) request.getAttribute("moveMessage");
            String CheckSelektionFunktion = (String) request.getAttribute("funktionSelektionBezeichnung");

            if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "navigation", "Neu")) && "blankLabel".equals(editMessage)) {
                out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "BeschriftungLeer") + "</p>");
                out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Umbenennen")) && "cannotRenameDash".equals(editMessage)) {
                out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "Auswahl") + " " + Language.getTextfield(session, "admin", "DarfNichtUmbenanntWerden") + "</p>");
                out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "navigation", "Neu")) && "alreadyExists".equals(editMessage)) {
                out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "Auswahl") + "\"" + request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung") + "\"" + Language.getTextfield(session, "admin", "existiertBereits") + "</p>");
                out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "navigation", "Neu")) && "success".equals(editMessage)) {
                out.println("<p>" + Language.getTextfield(session, "admin", "Auswahl") + " \"" + request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung") + "\" " + Language.getTextfield(session, "admin", "AuswahlAngelegt") + "</p>");
                out.println("<a href=\"admin-auswahlfelder?Formular=bearbeiten&Tabelle=" + request.getParameter("Tabelle") + "\">" + Language.getTextfield(session, "admin", "WeitereElementeBearbeiten") + "</a><br><br>");
                out.println("<a href=\"administration\">" + DBtoHTML(Language.getTextfield(session, "admin", "ZurueckAdministration")) + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Umbenennen")) && "blankLabel".equals(editMessage)) {
                out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "BeschriftungLeer") + "</p>");
                out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Umbenennen")) && "alreadyExists".equals(editMessage)) {
                out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + "\"" + request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung") + "\" " + DBtoHTML(Language.getTextfield(session, "admin", "Auswahlenzusammenzuführen")) + "</p>");
                out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
            } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Umbenennen")) && "success".equals(editMessage)) {
                String oldName = (String) request.getAttribute("oldName");
                out.println("<p>\"" + oldName + "\" " + Language.getTextfield(session, "admin", "ErfolgreichNach")
                        + " \"" + request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung") + "\" " + Language.getTextfield(session, "admin", "Umbenannt") + "</p>");
                out.println("<a href=\"admin-auswahlfelder?Formular=bearbeiten&Tabelle=" + request.getParameter("Tabelle") + "\">" + Language.getTextfield(session, "admin", "WeitereElementeBearbeiten") + "</a><br><br>");
                out.println("<a href=\"administration\">" + DBtoHTML(Language.getTextfield(session, "admin", "ZurueckAdministration")) + "</a>");
            } else if (request.getParameter("action") == null && request.getParameter("Tabelle") != null && request.getParameter("Formular").equals("bearbeiten")) {
                String tbl = request.getParameter("Tabelle");
        %>
        <FORM method="POST" action="admin-auswahlfelder">
            <input type="hidden" name="Tabelle" value="<%= tbl%>">
            <table>
                <tr>
                    <th width="200"><%= tbl%></th>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td width="200"><%= Language.getTextfield(session, "admin", "Auswahl")%></td>
                    <td width="450">
                        <jsp:include page="administration/select.jsp">
                            <jsp:param name="Tabelle" value="<%= tbl%>" />
                            <jsp:param name="Feldname" value="<%= tbl%>" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td width="200"><%= Language.getTextfield(session, "admin", "Beschriftung")%></td>
                    <td width="450"><input name="<%= tbl%>_Bezeichnung" size="50" maxlength="255"></td>
                </tr>
            </table>
            <p>
                <input type="hidden" name="selectedBezeichnung" id="selectedBezeichnung" value="">
                <input type="reset" value="<%= Language.getTextfield(session, "admin", "AbbrechenKlein")%>">
                <input type="submit" name="action" value="<%= Language.getTextfield(session, "navigation", "Neu")%>">
                <input type="submit" name="action" value="<%= Language.getTextfield(session, "admin", "Umbenennen")%>" onclick="updateSelectedBezeichnung()">
            </p>
        </FORM>
        <script>
            function updateSelectedBezeichnung() {
                let selectElement = document.getElementsByName("<%= tbl%>")[0]; // Das Select-Feld
                let selectedOption = selectElement.options[selectElement.selectedIndex];

                // Die Bezeichnung des ausgewählten Elements in das hidden-Feld setzen
                document.getElementById("selectedBezeichnung").value = selectedOption.text;
            }
        </script>


        <%
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Verschieben")) && "sameSelection".equals(moveMessage)) {
            out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "ErrorVerschieben") + "</p>");
            out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Verschieben")) && "cannotMoveDash".equals(moveMessage)) {
            out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "AlteAuswahl") + " " + DBtoHTML(Language.getTextfield(session, "admin", "DarfNichtZusammengefuehrtWerden")) + "</p>");
            out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Verschieben")) && "success".equals(moveMessage)) {
            String fieldOld = (String) request.getAttribute("fieldOld");
            String fieldNew = (String) request.getAttribute("fieldNew");
            out.println("<p>\"" + fieldOld + "\" " + Language.getTextfield(session, "admin", "ErfolgVerschiebenVon") + "\" " + fieldNew + "\" " + Language.getTextfield(session, "admin", "ErfolgVerschiebenNach") + "</p>");
            out.println("<a href=\"admin-auswahlfelder?Formular=zusammenfuehren&Tabelle=" + request.getParameter("Tabelle") + "\">" + Language.getTextfield(session, "admin", "WeitereElementeZusammenfuehren") + "</a><br><br>");
            out.println("<a href=\"administration\">" + DBtoHTML(Language.getTextfield(session, "admin", "ZurueckAdministration")) + "</a>");
        } else if (request.getParameter("action") == null && request.getParameter("Tabelle") != null && request.getParameter("Formular").equals("zusammenfuehren")) {
            String tbl = request.getParameter("Tabelle");
        %>
        <FORM method="POST" action="admin-auswahlfelder">
            <input type="hidden" name="Tabelle" value="<%= tbl%>">
            <table>
                <tr>
                    <th width="200"><%= tbl%></th>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td width="200"><%= Language.getTextfield(session, "admin", "AlteAuswahl")%></td>
                    <td width="450">
                        <jsp:include page="administration/select.jsp">
                            <jsp:param name="Tabelle" value="<%= tbl%>" />
                            <jsp:param name="Feldname" value="Feld_alt" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td width="200"><%= Language.getTextfield(session, "admin", "NeueAuswahl")%></td>
                    <td width="450">
                        <jsp:include page="administration/select.jsp">
                            <jsp:param name="Tabelle" value="<%= tbl%>" />
                            <jsp:param name="Feldname" value="Feld_neu" />
                        </jsp:include>
                    </td>
                </tr>
            </table>
            <p>
                <input type="reset" value="<%= Language.getTextfield(session, "admin", "AbbrechenKlein")%>">
                <input type="submit" name="action" value="<%= Language.getTextfield(session, "admin", "Verschieben")%>">
            </p>
        </FORM>
        <%
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen")) && "noSelektionFunktion".equals(CheckSelektionFunktion)) {
            out.println("<p><b>Fehler:</b> selektion_funktion darf nicht leer sein.</p>");
            out.println("<a href=\"javascript:history.back()\">zur&uuml;ck</a>");
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen")) && "cannotDivideDash".equals(CheckSelektionFunktion)) {
            out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "Auswahl") + " " + Language.getTextfield(session, "admin", "DarfNichtAufgeteiltWerden") + "</p>");
            out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen")) && "noDivideSelektionFunktion".equals(CheckSelektionFunktion)) {
            out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "ErrorAufteilen") + "</p>");
            out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen")) && "success".equals(CheckSelektionFunktion)) {
            String selectionField = (String) request.getAttribute("selectionTag");
            String[] myarray = (String[]) request.getAttribute("myarray");
            StringBuilder devideFields = new StringBuilder();
            if (myarray != null && myarray.length > 0) {
                for (int i = 0; i < myarray.length; i++) {
                    // Holen der Bezeichnung für das aktuelle Element
                    String fieldNames = SelektionDB.getBezeichnungByID(myarray[i], request.getParameter("Tabelle"));

                    // Wenn es nicht das erste Element ist, ein Komma anfügen
                    if (i > 0) {
                        devideFields.append(", ");
                    }

                    // Füge das aktuelle Element zum devideFields hinzu
                    devideFields.append(fieldNames);
                }
            }

            out.println("<p>" + Language.getTextfield(session, "admin", "Auswahl") + " " + selectionField + " " + Language.getTextfield(session, "admin", "ErfolgreichAufgeteiltIn") + " " + devideFields + "." + "</p>");
            out.print("<p><a href=\"admin-auswahlfelder?Formular=aufteilen&Tabelle=" + request.getParameter("Tabelle") + "\">" + Language.getTextfield(session, "admin", "WeitereElementeAufteilen") + "</a><br><br>");
            out.println("<a href=\"administration\">" + DBtoHTML(Language.getTextfield(session, "admin", "ZurueckAdministration")) + "</a>");

        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen")) && "sameSelektionFunktion".equals(CheckSelektionFunktion)) {
            out.println("<p><b>" + Language.getTextfield(session, "einstellungen", "Fehler") + ": </b>" + Language.getTextfield(session, "admin", "ErrorAufteilenMitSichSelbst") + "</p>");
            out.println("<a href=\"javascript:history.back()\">" + Language.getTextfield(session, "einstellungen", "Zurueck") + "</a>");
        } else if (request.getParameter("action") == null && request.getParameter("Tabelle") != null && request.getParameter("Formular").equals("aufteilen")) {

        %>

        <div>
            <form id="myForm" method="POST" action="admin-auswahlfelder">
                <input type="hidden" name="Tabelle" value="<%= request.getParameter("Tabelle")%>">
                <table id="myTable">
                    <tr>
                        <th width="200"><%= request.getParameter("Tabelle")%></th>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="200"><%= Language.getTextfield(session, "admin", "Auswahl")%></td>
                        <td width="450">
                            <jsp:include page="administration/select.jsp">
                                <jsp:param name="Tabelle" value='<%= request.getParameter("Tabelle")%>' />
                                <jsp:param name="Feldname" value="Feld_selektionFunktion" />
                            </jsp:include>
                        </td>
                    </tr>
                    <tr id="rowTemplate">
                        <td width="200"><%= Language.getTextfield(session, "admin", "AufteilenGross")%></td>
                        <td width="450">
                            <jsp:include page="administration/select.jsp">
                                <jsp:param name="Tabelle" value='<%= request.getParameter("Tabelle")%>' />
                                <jsp:param name="Feldname" value="Split[0]" />
                            </jsp:include>
                        </td>
                    </tr>
                </table>
                <p>
                    <input type="hidden" id="feldnameHidden" name="Feldname" value="Split[0]">
                    <input type="reset" value="<%= Language.getTextfield(session, "admin", "AbbrechenKlein")%>">
                    <input type="button" id="subButton" value="-">
                    <input type="button" id="addButton" value="+">
                    <input type="submit" name="action" value="<%= Language.getTextfield(session, "admin", "Aufteilen")%>">
                </p>
            </form>
        </div>

        <script>
            let rowCounter = <%= rowCounter%>; // Initialer Zaehler fuer die Zeilen

            document.getElementById("addButton").addEventListener("click", function () {
                var rowTemplate = document.getElementById("rowTemplate");
                var newRow = rowTemplate.cloneNode(true); // Klone die Zeile
                rowCounter++; // Erhoehe den Zaehler fuer die naechste Zeile

                // Aktualisiere den Namen des select-Feldes
                var selectElement = newRow.querySelector("select");
                if (selectElement) {
                    selectElement.name = "Split[" + rowCounter + "]";
                }

                // Entferne die ID von der neuen Zeile, um die Vorlage zu behalten
                newRow.removeAttribute("id");

                // Fuege die neue Zeile zur Tabelle hinzu
                document.getElementById("myTable").appendChild(newRow);
                // Aktualisiere das Hidden-Field mit dem neuesten Wert
                document.getElementById("feldnameHidden").value = "Split[" + rowCounter + "]";
                console.log("New row added. Name of the new input: " + (selectElement ? selectElement.name : "unbekannt"));
            });

            document.getElementById("subButton").addEventListener("click", function () {
                var table = document.getElementById("myTable");
                var rows = table.getElementsByTagName("tr");

                // Stelle sicher, dass mindestens eine Zeile vorhanden ist, die nicht die Vorlage ist
                if (rows.length > 1) {
                    var lastRow = rows[rows.length - 1];
                    // Ueberpruefe, ob die Zeile das letzte Element ist, das entfernt werden soll
                    if (lastRow && lastRow.id !== 'rowTemplate') {
                        table.removeChild(lastRow);
                        rowCounter--; // Reduziere den Zaehler
                        console.log("Row removed. Current number of rows: " + (rows.length - 1));
                    } else {
                        console.log("No more rows to remove");
                    }
                } else {
                    console.log("No more rows to remove");
                }
            });
        </script>

        <%
            }
        %>

    </div>
    <%
        }
    %>
</div>
