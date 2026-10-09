<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>
<%@ page import="java.util.Date" isThreadSafe="false" %>
<%@ page import="java.util.HashSet" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>
<%@ page import="java.util.Set" isThreadSafe="false" %>
<%@ page import="java.util.stream.Stream" isThreadSafe="false" %>
<%@ page import="java.util.concurrent.atomic.AtomicReference" isThreadSafe="false" %>
<%@ page import="org.hibernate.query.NativeQuery" isThreadSafe="false" %>
<%@ page import="org.hibernate.Session" isThreadSafe="false" %>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>
<%
  Language.setLanguage(request);
%>
  <div>

    <jsp:include page="layout/title.datenpflege.jsp" />

       <div id="form">
       <ul>
          <li><a href="datenpflege?form=einzelbeleg&dbForm=einzelbeleg&zwischentabelle=einzelbeleg_hatnamenkommentar&attribut=Belegform&zwAttribut=einzelbelegID"><% Language.printTextfield(out, session, "datenpflege", "EinzelbelegOhneLemma");%></a></li>
          <li><a href="datenpflege?form=einzelbeleg&dbForm=einzelbeleg&zwischentabelle=einzelbeleg_textkritik&attribut=Belegform&zwAttribut=einzelbelegID"><% Language.printTextfield(out, session, "datenpflege", "EinzelbelegOhneTextkritik");%></a></li>
          <li><a href="datenpflege?form=einzelbeleg&dbForm=einzelbeleg&zwischentabelle=einzelbeleg_hatperson&attribut=Belegform&zwAttribut=einzelbelegID"><% Language.printTextfield(out, session, "datenpflege", "EinzelbelegOhnePerson");%></a></li>
          <li><a href="datenpflege?form=namenkommentar&dbForm=namenkommentar&zwischentabelle=einzelbeleg_hatnamenkommentar&attribut=PLemma&zwAttribut=namenkommentarID"><% Language.printTextfield(out, session, "datenpflege", "NamenOhneBelege");%></a></li>
          <li><a href="datenpflege?form=person&dbForm=person&zwischentabelle=einzelbeleg_hatperson&attribut=Standardname&zwAttribut=personID"><% Language.printTextfield(out, session, "datenpflege", "PersonOhneBelege");%></a></li>
          <li><a href="datenpflege?form=quelle&dbForm=quelle&zwischentabelle=quelle_inedition&attribut=Bezeichnung&zwAttribut=QuelleID"><% Language.printTextfield(out, session, "datenpflege", "QuelleOhneEdition");%></a></li>
          <li><a href="datenpflege?form=quelle&dbForm=quelle&zwischentabelle=handschrift_ueberlieferung&attribut=Bezeichnung&zwAttribut=QuelleID"><% Language.printTextfield(out, session, "datenpflege", "QuelleOhneUeberlieferung");%></a></li>
          <li><a href="datenpflege?form=handschrift&dbForm=handschrift&zwischentabelle=handschrift_ueberlieferung&attribut=Bibliothekssignatur&zwAttribut=HandschriftID"><% Language.printTextfield(out, session, "datenpflege", "TextzeugenOhneUeberlieferung");%></a></li>
          <li><a href="datenpflege?view=BelegformMitMehrerenLemmata">Belegformen mit mehreren Lemmata</a></li>
          <li><a href="datenpflege?view=BelegformGeschlecht">Belegformen mit Geschlecht</a></li>
          <li><a href="datenpflege?view=LemmaNachGlied">Lemmata nach Erst/Zweitglied</a></li>
       </ul>


    <%
        String form = request.getParameter("form");
        if (form != null){
            Map<Integer,String> attr = SucheDB.getAttributes(request);
            for (Integer key : attr.keySet()){
                out.println("<a href=\"" + form + "?ID=" + key + "\">-" + attr.get(key) + "</a><br>");
            }
        }
    %>

    <%
        String view = request.getParameter("view");
        if (view != null) {
            if (view.equals("BelegformMitMehrerenLemmata")) {
                Set<String> groupKeys = new HashSet<>();
                List<Map> rows = EinzelbelegDB.getBelegformenWithMultipleLemmas();

                out.println("<table class=\"dataTable\">");
                out.println("<thead>");
                out.println("<tr>");
                out.println("<th>Gruppierung</th>");
                out.println("<th>Einzelbeleg ID</th>");
                out.println("<th>Belegform</th>");
                out.println("<th>Lemma ID</th>");
                out.println("<th>Lemma</th>");
                out.println("<th>Provenienz</th>");
                out.println("</tr>");
                out.println("</thead>");
                out.println("<tbody>");
                for (Map row : rows) {
                    // TODO: Diacritical Marks must not be removed for grouping since they can lead to different Lemmas due to Mr. Geuenich
                    //String groupKey = Utils.removeDiacriticalMarks(String.valueOf(row.get("Belegform"))).toLowerCase();
                    String groupKey = String.valueOf(row.get("Belegform")).toLowerCase();
                    groupKeys.add(groupKey);
                    out.println("<tr>");
                    out.println("<td><b>" + Utils.escapeHTML(groupKey) + "</b></td>");
                    out.println("<td><a href=\"einzelbeleg?ID=" + String.valueOf(row.get("EinzelbelegID")) + "\">" + String.valueOf(row.get("EinzelbelegID")) + "</a></td>");
                    out.println("<td>" + Utils.escapeHTML(String.valueOf(row.get("Belegform"))) + "</td>");
                    out.println("<td><a href=\"lemma?ID=" + String.valueOf(row.get("MGHLemmaID")) + "\">" + String.valueOf(row.get("MGHLemmaID")) + "</a></td>");
                    out.println("<td>" + Utils.escapeHTML(String.valueOf(row.get("MGHLemma"))) + "</td>");
                    if (String.valueOf(row.get("provenance_source")).equals("DMP")) {
                        out.println("<td><a href=\"https://dmp.ub.uni-tuebingen.de?table=namen&mode=view&g_index=" + String.valueOf(row.get("provenance_id")) + "\" target=\"_blank\">" + Utils.escapeHTML(String.valueOf(row.get("provenance_source"))) + "</a></td>");
                    } else {
                        out.println("<td>" + Utils.escapeHTML(String.valueOf(row.get("provenance_source"))) + "</td>");
                    }
                    out.println("</tr>");
                }
                out.println("</tbody>");
                out.println("</table>");
            }

            if (view.equals("LemmaNachGlied")) {
                // Note: we cache this into a variable and print this at the end, else we might get buffered intermediate output with a strange view
                // before everything is finished
                StringBuilder html = new StringBuilder();
                html.append("<table class=\"dataTable\">\n");
                html.append("<thead><tr><th>Lemma</th><th>Erstglied</th><th>Zweitglied</th></tr></thead><tbody>\n");

                for (MghLemma lemma : LemmaDB.getList()) {
                    if (lemma.getMghLemma().contains("~")) {
                        String[] parts = lemma.getMghLemma().split("~");
                        if (parts.length == 2) {
                            html.append("<tr>");
                            html.append("<td><a href=\"lemma?ID=" + lemma.getId() + "\">" + Utils.escapeHTML(lemma.getMghLemma()) + "</a></td>");
                            html.append("<td>" + Utils.escapeHTML(parts[0]) + "</td>");
                            html.append("<td>" + Utils.escapeHTML(parts[1]) + "</td>");
                            html.append("</tr>\n");
                        }
                    }
                }

                html.append("</tbody></table>\n");
                out.println(html);
            }

            if (view.equals("BelegformGeschlecht")) {
                // This query is very slow, so we manage our session directly & use getResultStream()
                try (Session hibernateSession = MaintenanceDB.getSession()) {
                    NativeQuery query = hibernateSession.createNativeQuery(MaintenanceDB.getBelegformByGeschlechtSql());
                    Stream<Object[]> rows = query.getResultStream();

                    StringBuilder html = new StringBuilder();
                    html.append("<table class=\"dataTable\">\n");
                    html.append("<thead><tr><th>Lemma</th><th>Belegform</th><th>Geschlechter</th><th>Grammatikgeschlechter</th></tr></thead><tbody>\n");

                    AtomicReference<StringBuilder> htmlLambda = new AtomicReference<>(html);
                    rows.forEach(row -> {
                        htmlLambda.get().append("<tr>");
                        htmlLambda.get().append("<td>" + Utils.escapeHTML(row[3] != null ? row[3].toString() : "") + "</td>");
                        htmlLambda.get().append("<td>" + Utils.escapeHTML(row[0].toString()) + "</td>");
                        htmlLambda.get().append("<td>" + Utils.escapeHTML(row[1] != null ? row[1].toString() : "") + "</td>");
                        htmlLambda.get().append("<td>" + Utils.escapeHTML(row[2] != null ? row[2].toString() : "") + "</td>");
                        htmlLambda.get().append("</tr>\n");
                    });

                    html.append("</tbody></table>\n");
                    out.println(html);
                }
            }


            out.println("<script>");
            out.println("let dataTableOptions = {pageLength: 100, lengthMenu: [10, 50, 100, 500, 1000], language: {search: \"Suche:\", lengthMenu: \" _MENU_ Einträge pro Seite\", info: \"Zeige _START_ bis _END_ von _TOTAL_ Einträgen\"}, layout: {top2start: {'buttons': ['copyHtml5', 'csvHtml5', 'excelHtml5']}}};");
            out.println("$('.dataTable').each(function() { let table = new DataTable($(this), dataTableOptions); });");
            out.println("</script>");
        }
    %>
    </div>
  </div>
