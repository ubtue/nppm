<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>
<%@ page import="java.util.*" isThreadSafe="false" %>

<%
    /*
     Variante 1: Distinkte, alphabetisch sortierte Links
    - Behandelt Links wie gleich, auch wenn sie sich nur durch Groß-/Kleinschreibung unterscheiden.
    - Bevorzugt dabei Großschreibung.
    - Gibt jeden Link nur einmal aus (also keine Duplikate).
    - Sortiert alphabetisch (ohne Berücksichtigung von <a> Tags).

        <jsp:param name="Datenfeld" value="EinzelbelegRODistinct" />


    Variante 2: Alle Links ausgeben, keine Sortierung
    - Gibt jeden Link so aus, wie er in der Datenbank steht.
    - Macht keinen Unterschied zwischen Groß- und Kleinschreibung.
    - Sortiert nicht, zeigt die Reihenfolge aus der Datenbank.
    - Zeigt auch doppelte Links an, wenn vorhanden.

    <jsp:param name="Datenfeld" value="EinzelbelegRO" />
     */

    if (feldtyp.startsWith("link") && array) {
        String[] fields = feldtyp.substring(feldtyp.lastIndexOf('(') + 1, feldtyp.lastIndexOf(')')).split(",");
        List<Map> rowlist = AbstractBase.getMappedList(
                "SELECT * FROM " + zielTabelle + " WHERE " + formularAttribut + "=\"" + id + "\""
        );

        Set<String> alreadyPrintedNormalized = "EinzelbelegRODistinct".equals(datenfeld)
                ? new HashSet<>() : null;

        Map<String, String> normalizedToOriginal = new HashMap<>();
        Map<String, String> normalizedToId = new HashMap<>();

        List<String> links = new ArrayList<>();

        for (Map row : rowlist) {
            Map row2 = AbstractBase.getMappedRow(
                    "SELECT " + fields[2] + " FROM " + fields[0] + " WHERE tab.ID=" + String.valueOf(row.get(fields[1]))
            );

            if (row2 != null) {
                String bez = "Zum Datensatz";
                if (row2.get(fields[2]) != null) {
                    bez = format(String.valueOf(row2.get(fields[2])), fields[2]);
                    if (!fields[2].startsWith("PLemma")) {
                        bez = DBtoHTML(bez);
                    }
                }

                if (alreadyPrintedNormalized != null) {
                    String normalized = bez.toLowerCase();

                    if (normalizedToOriginal.containsKey(normalized)) {
                        String existing = normalizedToOriginal.get(normalized);
                        if (Character.isUpperCase(existing.charAt(0))) {
                            continue;
                        }
                        if (Character.isUpperCase(bez.charAt(0))) {
                            normalizedToOriginal.put(normalized, bez);
                            normalizedToId.put(normalized, String.valueOf(row.get(fields[1])));
                        } else {
                            continue;
                        }
                    } else {
                        normalizedToOriginal.put(normalized, bez);
                        normalizedToId.put(normalized, String.valueOf(row.get(fields[1])));
                    }
                } else {
                    String add = fields[3];
                    String href = add + "?ID=" + String.valueOf(row.get(fields[1]));
                    if (Utils.isGastEnvironment(request)) {
                        String prefix = IdentifierMapper.getPrefixByForm(add);
                        if (prefix != null) {
                            href = Utils.getPidUrl(request, prefix + String.valueOf(row.get(fields[1])));
                        }
                    }
                    String link = "<a class=\"ut-link\" href=\"" + href + "\">" + bez + "</a><br>";
                    links.add(link);
                }
            }
        }

        if (alreadyPrintedNormalized != null) {
            links.clear();
            for (String normalized : normalizedToOriginal.keySet()) {
                String bez = normalizedToOriginal.get(normalized);
                String zielId = normalizedToId.get(normalized);
                String add = fields[3];
                String href = add + "?ID=" + zielId;
                if (Utils.isGastEnvironment(request)) {
                    String prefix = IdentifierMapper.getPrefixByForm(add);
                    if (prefix != null) {
                        href = Utils.getPidUrl(request, prefix + zielId);
                    }
                }
                String link = "<a class=\"ut-link\" href=\"" + href + "\">" + bez + "</a><br>";
                links.add(link);
            }

            // Nur sortieren wenn EinzelbelegRODistinct aktiv ist
            Collections.sort(links, new Comparator<>() {
                public int compare(String a, String b) {
                    return a.replaceAll("<[^>]+>", "").compareToIgnoreCase(b.replaceAll("<[^>]+>", ""));
                }
            });
        }

        String ausrichtung = request.getParameter("Ausrichtung");
        if ("horizontal".equalsIgnoreCase(ausrichtung)) {
            int count = 0;
            for (int i = 0; i < links.size(); i++) {
                out.print(links.get(i).replaceAll("<br>", "")); // <br> entfernen für horizontale Darstellung

                count++;
                if (count % 5 == 0 || i == links.size() - 1) {
                    out.println("<br>"); // nach 5 Links oder am Ende der Liste: Zeilenumbruch
                    count = 0;
                } else {
                    out.print(", &nbsp;");
                }
            }
        } else {
            for (String link : links) {
                out.println(link);
            }
        }

    }
%>
