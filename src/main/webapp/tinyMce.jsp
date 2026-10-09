<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="java.io.File"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.*"%>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>

<%    String helpFileName = request.getParameter("loadFile");
    String selectedLanguage = ContentDB.getCookieLanguage(request);

    Content content = ContentDB.getByNameAndLanguage(helpFileName, selectedLanguage);
    byte[] htmlBytes = content.getContent();
    String utf8String = new String(htmlBytes, java.nio.charset.StandardCharsets.UTF_8);

    String myLanguage = Language.getLanguage(request);

    if (myLanguage == null) {
        myLanguage = "en";
    } else if (myLanguage.equals("fr")) {
        myLanguage = "fr_FR";
    } else if (myLanguage.equals("la")) {
        myLanguage = "en";
    }
%>
<header>
    <script src="<%=Utils.getVersionedHref(request, application, "/layout/tinymce/tinymce.min.js")%>" type="text/javascript"></script>
    <script type="text/javascript">
        let language = '<%= myLanguage%>';
        tinymce.init({
            selector: '#mytextarea',
            themes: 'modern',
            width: 1024,
            height: 600,

            plugins: ['template', 'emoticons', 'fullscreen', 'preview', 'print', 'image', 'print', 'insertdatetime', 'pagebreak', 'table', 'export', 'anchor', 'link', 'fontselect',
                'searchreplace', 'visualblocks', 'visualchars', 'code', "advlist lists ", 'nonbreaking', 'charmap', 'wordcount'],

            contextmenu: "link | image | inserttable | cell row column deletetable",
            content_css: "gast/vendor/ut-typo3/css/merged.css",
            language: language,

            table_toolbar: 'tableprops tabledelete | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol',

            toolbar: 'undo redo | styleselect | forecolor | backcolor | blockquote | bold italic | underline | link | fontselect | fontsizeselect | formatselect | h1 h2 h3 h4 | alignleft aligncenter alignright alignjustify | numlist bullist | outdent indent | copy cut paste | anchor | emoticons | image | pagebreak | fullscreen | preview | visualblocks | visualchars | searchreplace | print | insertdatetime | charmap | code',

            // Define formats for headings, links, table elements, and images with classes
            style_formats: [
                {title: 'Heading 1', block: 'h1', classes: 'ut-heading ut-heading--h1'},
                {title: 'Heading 2', block: 'h2', classes: 'ut-heading ut-heading--h2'},
                {title: 'Heading 3', block: 'h3', classes: 'ut-heading ut-heading--h3'},
                {title: 'Heading 4', block: 'h4', classes: 'ut-heading ut-heading--h4'},
                {title: 'Styled Table', selector: 'table', classes: 'ut-table ut-table--striped ut-table--striped--color-primary-3'},
                {title: 'Table Body', selector: 'tbody', classes: 'ut-table__body'},
                {title: 'Table Row', selector: 'tr', classes: 'ut-table__row'},
                {title: 'Table Cell', selector: 'td', classes: 'ut-table__item ut-table__body__item'},
                {title: 'Styled Link (internal)', inline: 'a', classes: 'ut-link'},
                {title: 'Styled Link (external)', inline: 'a', classes: 'ut-link ut-link--external ut-link--context-icon'},
                {title: 'Styled Image', selector: 'img', classes: 'ut-picture__img ut-img--fluid'}
            ],

            formats: {
                h1: {block: 'h1', classes: 'ut-heading ut-heading--h1'},
                h2: {block: 'h2', classes: 'ut-heading ut-heading--h2'},
                h3: {block: 'h3', classes: 'ut-heading ut-heading--h3'},
                h4: {block: 'h4', classes: 'ut-heading ut-heading--h4'},
                table: {selector: 'table', classes: 'ut-table ut-table--striped ut-table--striped--color-primary-3'},
                tbody: {selector: 'tbody', classes: 'ut-table__body'},
                tr: {selector: 'tr', classes: 'ut-table__row'},
                td: {selector: 'td', classes: 'ut-table__item ut-table__body__item'},
                a: {inline: 'a', classes: 'ut-link'}, // Standard-Link-Klasse für interne Links
                img: {selector: 'img', classes: 'ut-picture__img ut-img--fluid'} // Standard-Klassen für Bilder
            },

            setup: function (editor) {
                editor.on('NodeChange', function (e) {

                    // Tabelle nachträglich formatieren
                    let tables = editor.getBody().querySelectorAll('table');
                    tables.forEach(table => {
                        table.classList.add('ut-table', 'ut-table--striped', 'ut-table--striped--color-primary-3');
                    });

                    // Weitere Formatierungen für Tabellen und deren Zellen
                    let tbody = editor.getBody().querySelectorAll('tbody');
                    tbody.forEach(body => {
                        body.classList.add('ut-table__body');
                    });

                    // Weitere Formatierungen für Tabellen und deren Zellen
                    let rows = editor.getBody().querySelectorAll('tr');
                    rows.forEach(row => {
                        row.classList.add('ut-table__row');
                    });

                    let cells = editor.getBody().querySelectorAll('td');
                    cells.forEach(cell => {
                        cell.classList.add('ut-table__item', 'ut-table__body__item');
                    });


                    // Für Bilder die Klassen hinzufügen
                    let images = editor.getBody().querySelectorAll('img');

                    images.forEach(image => {
                        image.classList.add('ut-picture__img', 'ut-img--fluid');
                    });

                    // Für Datums- und Zeitangaben die Klasse hinzufügen
                    let datetimeElements = editor.getBody().querySelectorAll('p');
                    datetimeElements.forEach(p => {
                        let text = p.textContent.trim();

                        // Überprüft verschiedene Datums- und Zeitformate
                        if (
                                text.match(/^\d{2}:\d{2}:\d{2}$/) || // 13:56:39
                                text.match(/^\d{1,2}:\d{2}:\d{2} [APM]{2}$/) || // 1:55:16 PM
                                text.match(/^\d{2}\/\d{2}\/\d{4}$/) || // 02/03/2025 (US-Format)
                                text.match(/^\d{4}-\d{2}-\d{2}$/) || // 2025-02-03 (ISO-Format)
                                text.match(/^\d{1,2}:\d{2} [APM]{2}$/) || // 13:51 PM (12 Stunden Format ohne Sekunden)
                                text.match(/^\d{4}-\d{2}-\d{2}\d{2}:\d{2}:\d{2}$/)                // 2025-02-03T13:56:39 (ISO mit Zeit)
                                ) {
                            p.classList.add('ut-news-item__datetime');
                        }
                    });

                    let links = editor.getBody().querySelectorAll('a');
                    links.forEach(link => {
                        let href = link.getAttribute('href');

                        if (href && (href.startsWith('http://') || href.startsWith('https://')) && !href.includes(window.location.hostname)) {
                            // Externe Links erhalten spezielle Klassen
                            link.classList.add('ut-link', 'ut-link--external', 'ut-link--context-icon');
                        } else {
                            // Interne Links erhalten nur 'ut-link'
                            link.classList.add('ut-link');
                            link.classList.remove('ut-link--external', 'ut-link--context-icon');
                        }
                    });
                });
            }
        });

    </script>
</header>
<jsp:include page="layout/titel.inhalt.jsp" />
<div id="form">

    <form method="post" action="edit">
        <textarea id="mytextarea" name="htmlContent">
            <%= utf8String%>
        </textarea>
        <input type="hidden" name="tinyFileName" value="<%= helpFileName%>">
        <input type="hidden" name="tinyLanguage" value="<%= selectedLanguage%>">

        <div style="display: flex;">
            <div style="margin-right: 10px;">
                <input class="full-width-button" type="submit" aria-label="<% Language.printTextfield(out, session, "tinyMce", "ButtonSpeichern"); %>" value="<% Language.printTextfield(out, session, "tinyMce", "ButtonSpeichern");%>">
                <input type="hidden" name="htmlFileAccess" value="HtmlSaveToDatabase">
            </div>
            <a href='file?context=<%=content.getContext()%>' style="margin-right: 10px;" aria-label="<% Language.printTextfield(out, session, "tinyMce", "LinkDateiBildVerwaltung"); %>"><% Language.printTextfield(out, session, "tinyMce", "LinkDateiBildVerwaltung");%></a>
        </div>
    </form>
</div>
