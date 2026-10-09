<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<div class="wrapper">
    <form method="post" action="einfaches_ergebnis">
        <% Language.setLanguage(request);

            if (request.getParameter("form") != null && request.getParameter("form").equals("einfache_suche")) {
        %><%@ include file="suche/einfache_suche.jsp" %>

        <%        } else {

        %>
        <input type="hidden" name="form" value="einfache_suche">

        <h3 class="ut-heading ut-heading--h3">
            <jsp:include page="../inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="gast_freie_suche"/>
                <jsp:param name="Textfeld" value="EinfacheSuche"/>
            </jsp:include></h3>

        <div class="ut-form__row row align-items-center">
            <div class="col-sm-10">
                <input class="ut-form__input ut-form__field" id="id_field" type="text" name="query" placeholder="<% Language.printTextfield(out, session, "gast_freie_suche", "BelegformSuchanfrage"); %>" value="" required />
            </div>
        </div>
        <div class="ut-form__row row align-items-center">
            <div class="col-sm-10">
                <button type="submit" class="ut-btn ut-btn--outline ut-btn--color-primary-1 ut-form__action mr-2" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "Suchen"); %>"><% Language.printTextfield(out, session, "gast_freie_suche", "Suchen"); %></button>
                <button type="reset" class="ut-btn ut-btn--outline ut-form__action" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "Zuruecksetzen"); %>"><% Language.printTextfield(out, session, "gast_freie_suche", "Zuruecksetzen"); %></button>
            </div>
        </div>

        <%   if(session.getAttribute("Sprache").equals("de")) {
                    String textDe = "In der einfachen Suche können Sie nach der Belegform eines Namens suchen – also nach derjenigen Schreibweise, die in einer mittelalterlichen Quelle zu erwarten ist. Denken Sie dabei insbesondere an die lateinische Endung: Sie suchen hier nicht Namen wie \"Charlemagne\",  \"Charles the Bald\" oder \"Karl der Große\", sondern mittelalterliche Namensformen wie \"Karolus\" oder \"Carolus\".";
                    out.print("<p>" + Utils.escapeHTML(textDe) + "</p>");
                    textDe = "Für komplexere Suchanfragen – etwa zu Quellen, Datierungen, einzelnen Personen usw. – verwenden Sie bitte die erweiterte Suche.";
                    out.print("<p>" + Utils.escapeHTML(textDe) + "</p>");
                } else {
                    String textEn = "In the simple search, you can look for the Form of Reference of a name  — that is, the spelling that would be expected in a medieval source. Pay particular attention to the Latin ending: you are not searching for names like \"Charlemagne\", \"Charles the Bald\" or \"Karl der Große\", but rather for medieval name forms such as \"Karolus\" or \"Carolus\".";
                    out.print("<p>" + Utils.escapeHTML(textEn) + "</p>");
                    textEn = "For more complex search queries — for example, regarding sources, dates, individual persons, etc. — please use the extended search.";
                    out.print("<p>" + Utils.escapeHTML(textEn) + "</p>");
                }
            }
        %>
    </form>
</div>
