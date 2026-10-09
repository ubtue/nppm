<%@page import="com.google.gson.Gson"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Content.Context"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.*"%>
<%@page import="org.apache.commons.fileupload.*" isThreadSafe="false" %>
<%@page import="org.apache.commons.fileupload.disk.*" isThreadSafe="false" %>
<%@page import="org.apache.commons.fileupload.servlet.*" isThreadSafe="false" %>
<%@page import="org.apache.commons.fileupload.util.*" isThreadSafe="false" %>
<%@include file="functions.jsp" %>
<%@ include file="configuration.jsp" %>

<header>
    <style>
        .cell-padding {
            padding-top: 5px;
            padding-bottom: 5px;
        }
        .full-width-button {
            display: block;
            width: 100%;
            margin-bottom: 2px;
            box-sizing: border-box;
        }
        .tab-container {
            display: flex;
        }
        .select-language {
            padding: 10px 20px;
            background-color: #f0f0f0;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .select-language.active {
            background-color: red;
            color: white;
        }

        .file-input-wrapper {
            position: relative;
            display: inline-block;
        }
        .file-input-wrapper input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0;
            cursor: pointer;
        }
        .file-input-label {
            background-color: #f1f1f1;
            padding: 2px 6px;
            border: 1px solid #999;
            display: inline-block;
            cursor: pointer;
            font-size: 14px;
            border-radius: 2px; /* Abgerundete Ecken */

        }
        .file-input-text {
            margin-left: 10px;
            font-style: normal;
            color: #666;
        }
    </style>
</header>

<div id="dynamicContentDiv">
    <% String language = (String) session.getAttribute("Sprache");
        int id = 0;
        String context = "";
        if (request.getParameter("context") != null) {
            context = request.getParameter("context");
        }
        Content.Context contextEnum = null;
        if (context.equals("CMS")) {
            contextEnum = Content.Context.CMS;
        } else if (context.equals("NAMENKOMMENTAR")) {
            contextEnum = Content.Context.NAMENKOMMENTAR;
        } else if (context.equals("QUELLENKOMMENTAR")) {
            contextEnum = Content.Context.QUELLENKOMMENTAR;
        } else if (context.equals("UEBERLIEFERUNGSKOMMENTAR")) {
            contextEnum = Content.Context.UEBERLIEFERUNGSKOMMENTAR;
        }
    %>
    <br>
    <form method="get" id="contextForm" onchange="this.submit();">
        <select name="context">
            <option value="" aria-label="<% Language.printTextfield(out, session, "fileManagement", "ContextWahl"); %>" >
                <% Language.printTextfield(out, session, "fileManagement", "ContextWahl");%>
            </option>
            <option value="NAMENKOMMENTAR" aria-label="<%= Language.getTextfield(session, "fileManagement", "Namenkommentar")%>" <% if (contextEnum == Content.Context.NAMENKOMMENTAR) {
                    out.print("selected"); }%>>
                <%= Language.getTextfield(session, "fileManagement", "Namenkommentar")%>
            </option>
            <option value="QUELLENKOMMENTAR" aria-label="<%= Language.getTextfield(session, "fileManagement", "Quellenkommentar")%>" <% if (contextEnum == Content.Context.QUELLENKOMMENTAR) {
                    out.print("selected"); }%>>
                <%= Language.getTextfield(session, "fileManagement", "Quellenkommentar")%>
            </option>
            <option value="UEBERLIEFERUNGSKOMMENTAR" aria-label="<%= Language.getTextfield(session, "fileManagement", "Überlieferungskommentar")%>" <% if (contextEnum == Content.Context.UEBERLIEFERUNGSKOMMENTAR) {
                    out.print("selected"); }%>>
                <%= Language.getTextfield(session, "fileManagement", "Überlieferungskommentar")%>
            </option>
            <option value="CMS" <% if (contextEnum == Content.Context.CMS) {
                    out.print("selected"); } %>>
                CONTENT MANAGEMENT SYSTEM
            </option>
        </select>
    </form>
    <br>
    <%
        try {
            String fileToDelete = request.getParameter("filename");
            boolean deleteConfirmation = (fileToDelete != null && !fileToDelete.isEmpty());
            boolean showPage = (!context.isEmpty());
            if (showPage) {
                List<Integer> ids = new ArrayList<>(); // IDs-Liste initialisieren
%>
    <form action="file?context=<%=context%>&fileAccess=fileUpload" method="post" enctype="multipart/form-data">
        <div class="file-input-wrapper" role="group" aria-labelledby="file-upload-label">
            <label id="file-upload-label" for="file-upload" class="file-input-label"><%= Language.getTextfield(session, "fileManagement", "ChooseFiles")%></label>
            <input type="file" id="file-upload" name="file[]" multiple onchange="updateFileName()" aria-describedby="file-name">
            <span id="file-name" class="file-input-text"><%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%></span>
        </div>

        <br><br>
        <input type="submit" value="<%= Language.getTextfield(session, "fileManagement", "Upload")%>">
    </form>
    <br>

    <%
        if(context.equals("CMS")){
          %>
        <div class="tab-container">
            <button data-language="de" class="select-language" type="button" aria-label="<%= Language.getTextfield(session, "sprachauswahl", "Sprache_de")%>" onclick="setLanguage('de')"><%= Language.getTextfield(session, "sprachauswahl", "Sprache_de")%></button>
            <button data-language="gb" class="select-language" type="button" aria-label="<%= Language.getTextfield(session, "sprachauswahl", "Sprache_en")%>" onclick="setLanguage('gb')"><%= Language.getTextfield(session, "sprachauswahl", "Sprache_en")%></button>
            <button data-language="fr" class="select-language" type="button" aria-label="<%= Language.getTextfield(session, "sprachauswahl", "Sprache_fr_2")%>" onclick="setLanguage('fr')"><%= Language.getTextfield(session, "sprachauswahl", "Sprache_fr_2")%></button>
            <button data-language="la" class="select-language" type="button" aria-label="<%= Language.getTextfield(session, "sprachauswahl", "Sprache_la_2")%>" onclick="setLanguage('la')"><%= Language.getTextfield(session, "sprachauswahl", "Sprache_la_2")%></button>
        </div>
          <%
        }
    %>

    <table style="border-collapse:collapse;" border="1">
        <tr>
            <th><%= Language.getTextfield(session, "fileManagement", "Pfad")%></th>
            <th><%= Language.getTextfield(session, "fileManagement", "Vorschau")%></th>
            <th><%= Language.getTextfield(session, "fileManagement", "Aktionen")%></th>
        </tr>

        <%
            List<Content> fileList = ContentDB.getList(contextEnum.toString());
            for (Content content : fileList) {
                if (content.getContent_Type().startsWith("text/html")) {
                    Content firstResult = ContentDB.getFirstResultByName(content.getName());
                    if (firstResult != null && firstResult.getID() == content.getID()) {
                        String name = content.getName();
                        String fileUrl = Utils.getBaseUrl(request) + "/content?name=" + urlEncode(name);
                        id++;
                        ids.add(id); // ID zur Liste hinzufügen
        %>
        <tr>
            <td>
                <a id="fileLink_<%=id%>" style="display: none;" href="<%=fileUrl%>" target="_blank"><%=name%></a>
                <p id="fileParagraph_<%=id%>" style="display: none;"><%=name%></p>
            </td>
            <td></td>
            <td class="cell-padding">
                <form name="formFileLanguage_<%=id%>">
                    <input type="hidden" name="content_name" value="<%=name%>">
                    <input type="hidden" name="content_language" value="<%=Constants.DEFAULT_LANG%>">
                    <input type="submit" style="display:none;">
                </form>

                <form id="createFileForm_<%=id%>" action="file" method="post" onsubmit="setActionUrl(event, this, '<%= content.getContext()%>')">
                    <input type="hidden" name="CreateHTMLFileName" value="<%=name%>">
                    <input type="hidden" name="fileAccess" value="HtmlFileCreate">
                    <input type="hidden" name="HtmlContext" value="<%= content.getContext()%>">
                    <button type="submit" id="createFileButton_<%=id%>" aria-label="<%= Language.getTextfield(session, "fileManagement", "DateiErstellen")%>"><%= Language.getTextfield(session, "fileManagement", "DateiErstellen")%></button>
                </form>

                <a id="showTinyLink_<%=id%>" style="display: none;" href="edit?loadFile=<%=name%>" aria-label="<%= Language.getTextfield(session, "fileManagement", "HtmlBearbeiten")%>"><%= Language.getTextfield(session, "fileManagement", "HtmlBearbeiten")%></a>
                <hr>
                <form id="chooseFileForm_<%=id%>" style="display: block;" action="file?context=<%=context%>&fileAccess=fileReplace&id=<%=content.getID()%>" method="post" onsubmit="return confirmReplace('<%=id%>');" enctype="multipart/form-data">
                    <div class="file-input-wrapper" role="group" aria-labelledby="file-upload-label-replace_<%=id%>">
                        <label id="file-upload-label-replace_<%=id%>" for="file-upload-replace_<%=id%>" class="file-input-label"><%= Language.getTextfield(session, "fileManagement", "ChooseFile")%></label>
                        <input type="file" id="file-upload-replace_<%=id%>" name="file" onchange="updateFileNameReplace('<%=id%>')" aria-describedby="file-name-replace_<%=id%>">
                        <span id="file-name-replace_<%=id%>" class="file-input-text"><%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%></span>
                    </div>
                    <input class="full-width-button" type="submit" aria-label="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>" value="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>">
                    <input type="hidden" id="contentNameReplace_<%=id%>" name="contentNameReplace" value="<%= content.getName()%>">
                </form>
                <hr>
                <form id="deleteFileForm_<%=id%>" style="display: none;"  action="file" method="post" onsubmit="return confirmDelete('<%=id%>');">
                    <input class="full-width-button" type="submit" name="deleteFile" aria-label="<%= Language.getTextfield(session, "fileManagement", "Delete")%>" value="<%= Language.getTextfield(session, "fileManagement", "Delete")%>">
                    <input type="hidden" name="fileAccess" value="fileDelete">
                    <input type="hidden" name="id" value="<%=content.getID()%>">
                    <input type="hidden" name="context" value="<%=context%>">
                    <input type="hidden" id="contentName_<%=id%>" value="<%= content.getName()%>">
                </form>
            </td>
        </tr>
        <%
            }
        } else if (content.getContent_Type().startsWith("text/plain") || content.getContent_Type().startsWith("application/vnd.oasis.opendocument.text")
                || content.getContent_Type().startsWith("application/msword") || content.getContent_Type().startsWith("application/vnd.openxmlformats-officedocument.wordprocessingml.document")) {
            String name = content.getName();
            String fileUrl = Utils.getBaseUrl(request) + "/content?name=" + urlEncode(name);
            id++;
        %>
        <tr>
            <td><a href="<%=fileUrl%>" target="_blank"><%=name%></a></td>
            <td></td>
            <td class="cell-padding">
                <form id="chooseFileForm_<%=id%>" style="display: block;" action="file?context=<%=context%>&fileAccess=fileReplace&id=<%=content.getID()%>" method="post" onsubmit="return confirmReplace('<%=id%>');" enctype="multipart/form-data">
                    <div class="file-input-wrapper" role="group" aria-labelledby="file-upload-label-replace_<%=id%>">
                        <label id="file-upload-label-replace_<%=id%>" for="file-upload-replace_<%=id%>" class="file-input-label"><%= Language.getTextfield(session, "fileManagement", "ChooseFile")%></label>
                        <input type="file" id="file-upload-replace_<%=id%>" name="file" onchange="updateFileNameReplace('<%=id%>')" aria-describedby="file-name-replace_<%=id%>">
                        <span id="file-name-replace_<%=id%>" class="file-input-text"><%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%></span>
                    </div>
                    <input class="full-width-button" type="submit" aria-label="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>" value="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>">
                    <input type="hidden" id="contentNameReplace_<%=id%>" name="contentNameReplace" value="<%= content.getName()%>">
                </form>
                <hr>
                <form action="file" method="post" onsubmit="return confirm('<%= Language.getTextfield(session, "contentServlet", "Datei")%> <%=content.getName()%> <%= Language.getTextfield(session, "fileManagement", "reallyDelete")%>');">
                    <input class="full-width-button" type="submit" name="deleteFile" aria-label="<%= Language.getTextfield(session, "fileManagement", "Delete")%>" value="<%= Language.getTextfield(session, "fileManagement", "Delete")%>">
                    <input type="hidden" name="fileAccess" value="fileDelete">
                    <input type="hidden" name="id" value="<%=content.getID()%>">
                    <input type="hidden" name="context" value="<%=context%>">
                </form>
            </td>
        </tr>
        <%
                }
            }
            String idsJson = new Gson().toJson(ids);
        %>

        <input type="hidden" id="idsArray" value="<%= idsJson%>">
        <%

            for (Content content : fileList) {
                if (content.getContent_Type().startsWith("image")) {
                    String name = content.getName();
                    String imageUrl = Utils.getBaseUrl(request) + "/content?name=" + urlEncode(name);
                    id++;
        %>
        <tr>
            <td><a href="<%=imageUrl%>" target="_blank"><%=name%></a></td>
            <td><img src="<%=imageUrl%>" height="256px"></td>
            <td class="cell-padding">
                <form id="chooseFileForm_<%=id%>" style="display: block;" action="file?context=<%=context%>&fileAccess=fileReplace&id=<%=content.getID()%>" method="post" onsubmit="return confirmReplace('<%=id%>');" enctype="multipart/form-data">
                    <div class="file-input-wrapper" role="group" aria-labelledby="file-upload-label-replace_<%=id%>">
                        <label id="file-upload-label-replace_<%=id%>" for="file-upload-replace_<%=id%>" class="file-input-label"><%= Language.getTextfield(session, "fileManagement", "ChooseFile")%></label>
                        <input type="file" id="file-upload-replace_<%=id%>" name="file" onchange="updateFileNameReplace('<%=id%>')" aria-describedby="file-name-replace_<%=id%>">
                        <span id="file-name-replace_<%=id%>" class="file-input-text"><%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%></span>
                    </div>
                    <input class="full-width-button" type="submit" aria-label="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>" value="<%= Language.getTextfield(session, "fileManagement", "Ersetzen")%>">
                    <input type="hidden" id="contentNameReplace_<%=id%>" name="contentNameReplace" value="<%= content.getName()%>">
                </form>

                <hr>
                <form action="file" method="post" onsubmit="return confirm('<%= Language.getTextfield(session, "contentServlet", "Datei")%> <%=content.getName()%> <%= Language.getTextfield(session, "fileManagement", "reallyDelete")%>');">
                    <input class="full-width-button" type="submit" name="deleteFile" aria-label="<%= Language.getTextfield(session, "fileManagement", "Delete")%>" value="<%= Language.getTextfield(session, "fileManagement", "Delete")%>">
                    <input type="hidden" name="fileAccess" value="fileDelete">
                    <input type="hidden" name="id" value="<%=content.getID()%>">
                    <input type="hidden" name="context" value="<%=context%>">
                </form>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.toString());
        }
    %>

    <script>
        var idsJsonString = document.getElementById('idsArray').value;
        var ids = JSON.parse(idsJsonString);

        // Jetzt kannst du die IDs in JavaScript verwenden
        console.log(ids); // Zum Beispiel, um die IDs in der Konsole anzuzeigen

        function updateButtons(answer, id) {
            if (answer === "true") {
                document.getElementById("createFileButton_" + id).style.display = "none";
                document.getElementById("showTinyLink_" + id).style.display = "inline-block";
                document.getElementById("chooseFileForm_" + id).style.display = "inline-block";
                document.getElementById("deleteFileForm_" + id).style.display = "inline-block";
                document.getElementById("fileLink_" + id).style.display = "inline-block";
                document.getElementById("fileParagraph_" + id).style.display = "none";


            } else {
                document.getElementById("createFileButton_" + id).style.display = "inline-block";
                document.getElementById("showTinyLink_" + id).style.display = "none";
                document.getElementById("chooseFileForm_" + id).style.display = "none";
                document.getElementById("deleteFileForm_" + id).style.display = "none";
                document.getElementById("fileLink_" + id).style.display = "none";
                document.getElementById("fileParagraph_" + id).style.display = "inline-block";
            }
        }

        function setLanguage(languageCode) {
            document.cookie = "selectedLanguage=" + languageCode;
        }

        function activateTab(tabLanguage) {
            document.querySelectorAll('.select-language').forEach(function (button) {
                if (button.getAttribute('data-language') === tabLanguage) {
                    button.classList.add('active');
                } else {
                    button.classList.remove('active');
                }
            });
        }

        document.querySelectorAll('.select-language').forEach(function (button) {
            button.addEventListener('click', function () {
                let languageCode = this.getAttribute('data-language');
                activateTab(languageCode);
                setLanguage(languageCode);
                ids.forEach(function (id) {
                    take_values(languageCode, id);
                });
            });
        });

        function take_values(content_language, id) {
            let n = document.forms["formFileLanguage_" + id]["content_name"].value;
            if (n == null || n == "") {
                alert("Please enter a value");
                return false;
            } else {
                var http = new XMLHttpRequest();
                http.open("POST", "berechne", true);
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                var params = "param1=" + encodeURIComponent(n) + "&param2=" + encodeURIComponent(content_language);
                http.send(params);
                http.onload = function () {
                    let answer = http.responseText;
                    updateButtons(answer, id);
                };
            }
        }

        function setContextCookie() {
            var selectElement = document.getElementById('contextSelect');
            var selectedContext = selectElement.value;

            // Prüfen, ob sich der ausgewählte Kontext geändert hat
            var previousContext = getCookie('selectedContext');
            if (selectedContext !== previousContext) {
                document.cookie = "selectedContext=" + selectedContext + "; path=/";
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            let languageCookie = getCookie("selectedLanguage");
            if (!languageCookie) {
                languageCookie = 'de';
            }
            activateTab(languageCookie);
            setLanguage(languageCookie);
            ids.forEach(function (id) {
                take_values(languageCookie, id);
            });
        });

        function getCookie(name) {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = cookies[i].trim();
                if (cookie.startsWith(name + '=')) {
                    return cookie.substring(name.length + 1);
                }
            }
            return null;
        }

        function confirmDelete(id) {
            // Abrufen des aktuellen Werts des Cookies
            let selectedLanguage = getCookie('selectedLanguage');

            // Abrufen des Namens des Inhalts aus dem versteckten HTML-Element
            let contentName = document.getElementById('contentName_' + id).value;

            let messageStart = '<%= Language.getTextfield(session, "contentServlet", "Datei")%>' + " ";
            let messageEnd = '<%= Language.getTextfield(session, "fileManagement", "reallyDelete")%>';

            // Anzeigen des Bestätigungsfensters mit dem aktuellen Wert des Cookies und dem Namen des Inhalts
            return confirm(messageStart + contentName + ' (' + selectedLanguage + ') ' + messageEnd);
        }

        function confirmReplace(id) {
            // Abrufen des aktuellen Werts des Cookies
            let selectedLanguage = getCookie('selectedLanguage');

            // Abrufen des Namens des Inhalts aus dem versteckten HTML-Element
            let contentName = document.getElementById('contentNameReplace_' + id).value;

            let messageStart = '<%= Language.getTextfield(session, "contentServlet", "Datei")%>' + " ";
            let messageEnd = '<%= Language.getTextfield(session, "fileManagement", "reallyReplace")%>';

            // Anzeigen des Bestätigungsfensters mit dem aktuellen Wert des Cookies und dem Namen des Inhalts
            return confirm(messageStart + contentName + ' (' + selectedLanguage + ') ' + messageEnd);
        }

        function setActionUrl(event, form, context) {
            form.action += '?context=' + encodeURIComponent(context);
        }

        function updateFileName() {
            var input = document.getElementById('file-upload');
            var fileNameSpan = document.getElementById('file-name');
            if (input.files.length > 0) {
                var fileNames = [];
                for (var i = 0; i < input.files.length; i++) {
                    fileNames.push(input.files[i].name);
                }
                fileNameSpan.textContent = fileNames.join(', ');
            } else {
                fileNameSpan.textContent = '<%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%>';
            }
        }


        function updateFileNameReplace(suffix) {
            var input, fileNameSpan;

            if (suffix) {
                input = document.getElementById('file-upload-replace_' + suffix);
                fileNameSpan = document.getElementById('file-name-replace_' + suffix);
            } else {
                input = document.getElementById('file-upload-replace');
                fileNameSpan = document.getElementById('file-name-replace');
            }

            if (input && fileNameSpan) {
                if (input.files.length > 0) {
                    fileNameSpan.textContent = input.files[0].name;
                } else {
                    fileNameSpan.textContent = '<%= Language.getTextfield(session, "fileManagement", "NoFileChosen")%>';
                }
            } else {
                console.error('Input element or fileNameSpan element not found.');
            }
        }
    </script>
</div>
