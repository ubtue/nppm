<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ include file="../configuration.jsp" %>

<%
    int id = -1;
    String title = request.getParameter("title");

    //Filter berechnen
    session = request.getSession(true);
    int filter = 0;
    String filterParameter = null;
    String formular = request.getParameter("Formular");
    try {
        filter = ((Integer) session.getAttribute(formular + "filter")).intValue();
        filterParameter = (String) session.getAttribute(formular + "filterParameter");
    } catch (Exception e) {
    }

    try {
        id = Integer.parseInt(request.getParameter("ID"));
    } catch (NumberFormatException e) {
    }
%>
<div id="titel">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td align="left">
                <h1 id="h1-titel">
                    <jsp:include page="../inc.erzeugeBeschriftung.jsp">
                        <jsp:param name="Formular" value='<%= request.getParameter("title")%>'/>
                        <jsp:param name="Textfeld" value="Titel"/>
                    </jsp:include>
                    <%
                        if (title.equals("Einzelbeleg") || title.equals("Person") || title.equals("Namenkommentar") || title.equals("Quelle")) {
                            String url = request.getRequestURL().toString();
                            String query = request.getQueryString();
                            url = url.substring(0, url.lastIndexOf('/') + 1) + "gast/" + url.substring(url.lastIndexOf('/') + 1, url.length());
                            out.println("<a href=\"" + url);
                            if (query != null) {
                                out.println("?" + query);
                            }
                            out.println("\">");

                    %><img src="layout/icons/lupe.png" height="16" width="16" alt="Zeige Eintrag im Gast-Modus"></a>
                    <%}%>
                </h1>
            </td>
            <td align="right">
                <jsp:include page="../forms/link.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="Command" value="new"/>
                </jsp:include>

                <%
                    String speichernText = Language.getTextfield(session, "navigation", "Speichern");
                    String reset = Language.getTextfield(session, "navigation", "Abbrechen");

                    // Nur Anzeigen, wenn eigener Datensatz oder Datensatz ohne Besitzer
                    int akt = 0;

                    //id = Integer.parseInt(request.getParameter("ID"));
                    String disabled = "";
                    String href = Utils.getVersionedHref(request, application, "/javascript/shortcuts.js");
                    out.println("    <script src=\""+href+"\" type=\"text/javascript\"></script>");
                    if (!disabled.equals(" disabled"))
                        out.println("    <script type=\"text/javascript\">shortcut.add(\"Ctrl+Shift+S\",function() {document.forms[0].speichern.click();	},{	'type':'keydown',	'propagate':false,	'target':document});</script>");
                %>
                <input id="speichernX" type="submit" name="speichern" value='<%= speichernText %>' <%= disabled %>>
                <input type="reset" name="abbrechen" value='<%= reset %>' <%= disabled%>>
                <jsp:include page="../forms/link.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="Command" value="first"/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                </jsp:include>

                <jsp:include page="../forms/link.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="Command" value="back"/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                </jsp:include>

                <jsp:include page="../forms/link.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="Command" value="next"/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                </jsp:include>

                <jsp:include page="../forms/link.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="Command" value="last"/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                </jsp:include>

                <jsp:include page="../forms/duplicate.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                </jsp:include>
            </td>
        </tr>
        <tr>
            <td align="left">
                <jsp:include page="../forms/jumpID.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                </jsp:include>
                <jsp:include page="../forms/jump.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                </jsp:include>
            </td>
            <td align="right">
                <jsp:include page="../forms/filter.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                </jsp:include>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">

        <tr>
            <td align="left" nowrap>
                <jsp:include page="../forms/shortcut.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                    <jsp:param name="formular" value='<%= formular%>'/>
                </jsp:include>
            </td>
            <td align="right" style="color:white;font-weight:bold;">
                <% Language.printTextfield(out, session, "titel_inc", "Eintrag");%>
                <jsp:include page="../forms/counter.jsp">
                    <jsp:param name="ID" value='<%= id%>'/>
                    <jsp:param name="title" value='<%= request.getParameter("title").toLowerCase()%>'/>
                    <jsp:param name="filter" value='<%= filter%>'/>
                    <jsp:param name="filterParameter" value='<%= filterParameter%>'/>
                </jsp:include>
            </td>
        </tr>
    </table>
</div>
