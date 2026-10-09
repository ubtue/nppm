<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.SucheDB"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.ArrayList" isThreadSafe="false" %>
<%@ page import="java.util.Enumeration" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.Document" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.rtf.*" isThreadSafe="false" %>
<%@ page import="java.io.*" isThreadSafe="false" %>
<%@ page import="java.awt.Color" isThreadSafe="false" %>

<a href="<%= Utils.getBaseUrl(request) %>/gast/export_csv?query=<%= URLEncoder.encode(request.getParameter("query"), "UTF-8") %>" class="ut-btn">
    <%=Language.getTextfield(session, "suche", "Export")%>
</a>
<%
    String query = request.getParameter("query");

    try {
        List<String> headlines = new ArrayList<>();
        List<String> fieldNames = new ArrayList<>();

        int orderSize = 0;

        String belegform = "";

        query = query.trim();

        if (query.length() < 3) {
            throw new Exception("<b>" + Language.getTextfield(session, "suche", "Bitte3Zeichen") + "</b>");
        }

        String aufklappen = Language.getTextfield(session, "gast_freie_suche", "EbeneAufklappen");
        String zuklappen = Language.getTextfield(session, "gast_freie_suche", "EbeneZuklappen");

        out.println("<div id=\"level-function\">");
        out.println("<button class=\"ut-btn \" type=\"button\"  aria-label=\"" + aufklappen + "\" onClick=\"expandNextLevel('complete')\"><img src=\"layout/images/open_next_level.png\" alt=\"Aufklappen\" style=\"vertical-align: middle height: 23px; width: 30px; margin-right: 5px;\">" + aufklappen + "</button>");
        out.println("<button class=\"ut-btn \" type=\"button\"  aria-label=\"" + zuklappen + "\" onClick=\"collapseNextLevel('complete')\"><img src=\"layout/images/close_next_level.png\"  style=\"vertical-align: middle height: 23px; width: 30px; margin-right: 5px;\">" + zuklappen + "</button>");
        out.println("</div>");

        out.println("<ul class=\"mktree\" id=\"complete\">");

        headlines = new ArrayList<>();
        headlines.add("");
        headlines.add("");
        headlines.add(Language.getTextfield(session, "suche", "Belegform"));
        headlines.add(Language.getTextfield(session, "freie_suche", "Quelle"));
        headlines.add(Language.getTextfield(session, "suche", "NummerSeite"));
        headlines.add(Language.getTextfield(session, "suche", "Raster"));
        headlines.add(Language.getTextfield(session, "quelle", "Edition"));
        headlines.add(Language.getTextfield(session, "suche", "Cap"));
        headlines.add(Language.getTextfield(session, "suche", "Pag"));
        headlines.add(Language.getTextfield(session, "suche", "QvJ"));
        headlines.add(Language.getTextfield(session, "suche", "QvJh"));
        headlines.add(Language.getTextfield(session, "suche", "QbJ"));
        headlines.add(Language.getTextfield(session, "suche", "QbJh"));

        headlines.add(Language.getTextfield(session, "suche", "EBvJ"));
        headlines.add(Language.getTextfield(session, "suche", "EBvJh"));
        headlines.add(Language.getTextfield(session, "suche", "EBbJ"));
        headlines.add(Language.getTextfield(session, "suche", "EBbJh"));
        headlines.add(Language.getTextfield(session, "suche", "QJahr"));

        fieldNames = new ArrayList<>();
        fieldNames.add("MGHLemma");
        fieldNames.add("Standardname");
        fieldNames.add("Belegform");
        fieldNames.add("Bezeichnung");
        fieldNames.add("seite");
        fieldNames.add("raster");
        fieldNames.add("editionZitierweise");
        fieldNames.add("EditionKapitel");
        fieldNames.add("EditionSeite");
        fieldNames.add("quelleVonJahr");
        fieldNames.add("quelleVonJahrhundert");
        fieldNames.add("quelleBisJahr");
        fieldNames.add("quelleBisJahrhundert");

        fieldNames.add("VonJahr");
        fieldNames.add("VonJahrhundert");
        fieldNames.add("BisJahr");
        fieldNames.add("BisJahrhundert");
        fieldNames.add("quelleBerJahr");

        orderSize = 0;
        String order = "ORDER BY mgh_lemma.MGHLemma ASC, person.Standardname ASC, (VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) DIV 25), VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) ASC ";

        String orderV1[] = {"MGHLemma", "Standardname", "Belegform"};

        belegform = "";

        java.util.List<Map> resultAsMap = SucheDB.getEinfacheSucheResult(query);

        for (Map<String, Object> row : resultAsMap) {
            Object val = row.get("quelleBerJahr");
            if (val != null && val.toString().equals("99999")) {
                row.put("quelleBerJahr", "-");
            }
        }

        boolean found = false;

        Set<String> uniqueStandardnamen = new HashSet<>();
        Set<String> uniqueBelegformen = new HashSet<>();
        int belegformCount = 0; // We want this to be non-unique, so we can't count over the HashSet (special request ~07/2025)

        for (Map<String, Object> row : resultAsMap) {
            Object sn = row.get("Standardname");
            if (sn != null && !sn.toString().trim().isEmpty()) {
                uniqueStandardnamen.add(sn.toString().trim());
            }

            Object bf = row.get("Belegform");
            if (bf != null && !bf.toString().trim().isEmpty()) {
                uniqueBelegformen.add(bf.toString().trim());
                ++belegformCount;
            }
        }

        StringBuilder output = new StringBuilder();

        int personCount = uniqueStandardnamen.size();
        if (personCount >= 0) {
            output.append(Language.getTextfield(session, "freie_suche", "Insgesamt")).append(" ");
            output.append(personCount).append(" ");
            if (personCount == 1) {
                output.append(Language.getTextfield(session, "person", "Person"));
            } else {
                output.append(Language.getTextfield(session, "person", "Titel"));
            }
            output.append(", ");
        }

        if (belegformCount >= 0) {
            output.append(Language.getTextfield(session, "freie_suche", "Insgesamt")).append(" ");
            output.append(belegformCount).append(" ");
            if (belegformCount == 1) {
                output.append(Language.getTextfield(session, "einzelbeleg", "Einzelbeleg"));
            } else {
                output.append(Language.getTextfield(session, "einzelbeleg", "Titel"));
            }
            output.append(", ");
        }

        // Entferne letztes Komma + Leerzeichen
        if (output.length() >= 2) {
            output.setLength(output.length() - 2);
        }

        // Ausgabe
        out.println("<p><strong>" + output.toString() + "</strong></p>");

        if (!resultAsMap.isEmpty()) {
            found = true;
            out.print("<li  style=\"width:45%;float:left;margin-left:1em\"  class=\"liOpen\" style=\"font-size:large\">Lemma <ul>");

            Utils.simpleSearch(request,out, headlines, fieldNames, resultAsMap, orderV1, order, "", false);
            out.println("</ul></li>");
        }

        out.println("</ul>");

        String entry = Language.getTextfield(session, "titel_inc", "Eintrag");
        String entries = Language.getTextfield(session, "suche", "Eintraege");
%>
<script type="text/javascript">
    var array = document.getElementsByTagName("li");
    var entry = "<%= entry%>";
    var entries = "<%= entries%>";
    for (var j = 0; j < array.length; j++) {
        if (array[j].getElementsByTagName("ul").length == 0)
            continue;
        var ul = array[j].getElementsByTagName("ul")[0].previousSibling;
        var li = array[j].getElementsByTagName("li");
        var count = 0;
        if (li.length < 1)
            count = (array[j].getElementsByTagName("table")[0].rows.length - 2);
        else
            count = ul.nextSibling.childNodes.length;
        //     alert(ul.data);
        if (count == 1)
            ul.data = ul.data + "(" + count + " " + entry + ")";
        else
            ul.data = ul.data + "(" + count + " " + entries + ")";
    }
</script>

<%
        if (!found) {
            out.println("<b>" + Language.getTextfield(session, "suche", "KeinErgebnis") + "</b>");
        }

    } catch (Exception e) {
        out.println(e.getMessage());
    }

%>
