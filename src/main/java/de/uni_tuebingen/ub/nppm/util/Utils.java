package de.uni_tuebingen.ub.nppm.util;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import org.apache.commons.text.StringEscapeUtils;
import org.json.JSONObject;

public class Utils {

    // Hilfsfunktion für sichere Zahlenprüfung
    public static boolean safeNumeric(String s) {
        return s != null && isNumeric(s);
    }

    public static String safeToString(Object o) {
        return safeToString(o, "");
    }

    public static String safeToString(Object o, String fallback) {
        if (o == null) {
            return fallback;
        } else {
            return escapeHTML(String.valueOf(o));
        }
    }

    public static boolean isNumeric(String str) {
        try {
            Integer.parseInt(str);
        } catch (NumberFormatException numberFormatException) {
            return false;
        }
        return true;
    }

    public static boolean isDevelopmentEnvironment() {
        try {
            InitialContext initialContext = new InitialContext();
            Object entry = initialContext.lookup("java:comp/env/development");
            return entry == null || ((String) entry).equals("true");
        } catch (NamingException ex) {
            return false;
        }

    }

    public static boolean isGastEnvironment(HttpServletRequest request) {
        // checking for /gast/ url only might no longer be enough,
        // since there are some shortcut urls, so we also check for a username.
        if (request.getRequestURL().toString().contains("/gast/")) {
            return true;
        }

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("Benutzername") == null || ((String)session.getAttribute("Benutzername")).equals("gast")) {
            return true;
        }

        return false;
    }

    public static String getBaseUrl(HttpServletRequest request) {
        // Check whether we're behind a proxy
        String xHost = request.getHeader("Host");
        String xScheme = request.getHeader("X-Forwarded-Proto");
        String xPort = request.getHeader("X-Forwarded-Port");
        String xPrefix = request.getHeader("X-Forwarded-Prefix");
        if (xScheme != null && xHost != null && xPort != null) {
            // Use proxy configuration
            String baseUrl = xScheme + "://" + xHost + ((("http".equals(xScheme) && xPort.equals("80")) || ("https".equals(xScheme) && xPort.equals("443"))) ? "" : ":" + xPort);
            if (xPrefix != null) {
                baseUrl += xPrefix;
            }
            return baseUrl;
        } else {
            // If not, use the default
            String scheme = request.getScheme();
            String host = request.getServerName();
            int port = request.getServerPort();
            String contextPath = request.getContextPath();
            String baseUrl = scheme + "://" + host + ((("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443)) ? "" : ":" + port) + contextPath;
            return baseUrl;
        }
    }

    public static String getAjaxUrl(HttpServletRequest request) {
        return getBaseUrl(request) + "/ajax";
    }

    // This function will be overloaded with shortcuts, since it will be used in many templates
    public static String getPersistentIdentifierUrl(final HttpServletRequest request, final String persistentIdentifier) {
        return getBaseUrl(request) + "/id/" + escapeURL(persistentIdentifier);
    }

    public static String getPersistentIdentifierUrl(final HttpServletRequest request, final PersistentIdentifier persistentIdentifier) {
        return getPersistentIdentifierUrl(request, persistentIdentifier.getPersistentIdentifier());
    }

    public static String getPidUrl(final HttpServletRequest request, final String pid) {
        return getPersistentIdentifierUrl(request, pid);
    }

    public static String getPidUrl(final HttpServletRequest request, final PersistentIdentifier pid) {
        return getPersistentIdentifierUrl(request, pid.getPersistentIdentifier());
    }

    public static int determineId(HttpServletRequest request, HttpServletResponse response, String formular, JspWriter out) throws Exception {
        int id = Constants.UNDEFINED_ID;

        String reqID = request.getParameter("ID");
        if (reqID != null && isNumeric(reqID)) {
            id = Integer.parseInt(reqID);
        }

        String sql = Filter.getFilterSql(request, formular);

        if (id == Constants.UNDEFINED_ID) { //no id is set as parameter
            try {
                //get id from the first result of the filter
                id = Filter.getFirstFilterResult(sql, formular);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getLocalizedMessage());
            }
        } else if (id != Constants.NEW_ITEM) {
            try {
                //count
                BigInteger res = Filter.countFilterItems(sql);
                if (res != null) {
                    if (res.intValue() == 0) {
                        //no items with this filter
                        id = -1;
                    } else {
                        Integer ret = Filter.existIdInFilter(sql, formular, id);
                        if (ret == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "ID nicht gefunden");
                        }
                    }
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getLocalizedMessage());
            }
        }
        return id;
    }

    public static String escapeJS(String s) {
        return StringEscapeUtils.escapeEcmaScript(s);
    }

    public static String escapeHTML(String s) {
        return StringEscapeUtils.escapeHtml4(s);
    }

    public static String unescapeHTML(String s) {
        return StringEscapeUtils.unescapeHtml4(s);
    }

    /**
     * @deprecated
     * Use {@link Utils#escapeURL(String)} instead.
     */
    @Deprecated
    public static String urlEncode(String s) {
        return escapeURL(s);
    }

    // Alias for urlEncode(), so that we have multiple functions with the same naming schema (escape...)
    public static String escapeURL(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    /**
     * @deprecated
     *  This function is deprecated => we migrated all lemmas in the database,
     * so it should no longer be necessary to format them.
     * see issue #427
     */
    @Deprecated
    public static String format(String text, String feld) {
        if (!feld.endsWith("PLemma") && !feld.endsWith("MGHLemma") && !feld.endsWith("Klarlemma")) {
            return text;
        }

        String lemma = text;
        lemma = lemma.replaceAll("@-e1", "&#x01E3;");
        lemma = lemma.replaceAll("@-E1", "&#x01E2;");
        lemma = lemma.replaceAll("@!d", "&thorn;");
        lemma = lemma.replaceAll("@-I", "&#x012A;");
        lemma = lemma.replaceAll("@-i", "&#x012B;");
        lemma = lemma.replaceAll("@-A", "&#x0100;");
        lemma = lemma.replaceAll("@-a", "&#x0101;");
        lemma = lemma.replaceAll("@-O", "&#x014C;");
        lemma = lemma.replaceAll("@-o", "&#x014D;");
        lemma = lemma.replaceAll("@-E2", "&#x0112;");
        lemma = lemma.replaceAll("@-e2", "&#x0113;");
        lemma = lemma.replaceAll("@-E", "&#x0112;");
        lemma = lemma.replaceAll("@-e", "&#x0113;");
        lemma = lemma.replaceAll("@-U", "&#x016A;");
        lemma = lemma.replaceAll("@-u", "&#x016B;");
        if (!lemma.equals("-")) {
            lemma = lemma.replace("-", "");
        }
        lemma = lemma.replaceAll("~", "");
        lemma = lemma.replaceAll("\\.", "");

        if (lemma.length() > 1) {
            lemma = lemma.substring(0, 1).toUpperCase()
                    + lemma.substring(1);
        } else if (lemma.length() > 0) {
            lemma = lemma.substring(0, 1).toUpperCase();
        }

        if (lemma.startsWith("&#x01E3;")) {
            lemma = "&#x01E2;" + lemma.substring(8);
        }
        if (lemma.startsWith("&#x012B;")) {
            lemma = "&#x012A;" + lemma.substring(8);
        }
        if (lemma.startsWith("&thorn;")) {
            lemma = "&THORN;" + lemma.substring(7);
        }
        if (lemma.startsWith("&#x0101;")) {
            lemma = "&#x0100;" + lemma.substring(8);
        }
        if (lemma.startsWith("&#x014D;")) {
            lemma = "&#x014C;" + lemma.substring(8);
        }
        if (lemma.startsWith("&#x0113;")) {
            lemma = "&#x0112;" + lemma.substring(8);
        }
        if (lemma.startsWith("&#x016B;")) {
            lemma = "&#x016A;" + lemma.substring(8);
        }

        return lemma;
    }

    public static void simpleSearch(HttpServletRequest req, JspWriter out, List<String> headlines, List<String> fieldNames, List<Map> rsMap, String orderV[], String order, String open, boolean countTables) throws IOException, Exception {
        String header = "";
        int orderSize = orderV.length;
        boolean[] first = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true};  //kann mann vielleicht löschen ?!
        String oldValue[] = new String[15];
        header += "<tr>";
        for (int i = 0; i < headlines.size(); i++) {
            if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                header += "<th width=\"" + (100 / headlines.size()) + "%\" class=\"resultlist\">";
                header += headlines.get(i);
                header += "</th>";
            }
        }
        boolean even = false;
        header += "</tr>";

        if (orderSize == 0) {
            out.print("<table class=\"resultlist\" width=\"100%\">" + header + "<tr>");
        }

        for (Map rs : rsMap) {
            for (int z = 0; z < orderSize; z++) {
                int jahr = 0;
                int zeitraum = 0;
                String jahrV = "";
                if (rs.get(orderV[z]) == null) {
                    jahrV = "";
                    jahr = 0;
                } else {
                    jahrV = rs.get(orderV[z]).toString();

                    if (orderV[z].endsWith("Jahr")) {
                        zeitraum = 25;
                        jahr = Integer.parseInt(jahrV);
                        jahr = jahr / zeitraum;
                        jahrV = "" + jahr;
                    }

                }

                if (first[z] || rs.get(orderV[z]) != null && !jahrV.equalsIgnoreCase(oldValue[z])) {
                    oldValue[z] = jahrV;
                    if (!first[z]) {
                        out.print("</table>");
                        for (int z2 = z; z2 < orderSize; z2++) {
                            out.print("</ul></li>");
                        }

                    }
                    first[z] = false;
                    for (int z2 = z + 1; z2 < orderSize; z2++) {
                        first[z2] = true;
                    }

                    if (z > 0) {
                        out.print("<li class=\"liClosed\" style=\"font-size:medium\">");
                    } else {
                        out.print("<li class=\"liOpen\" style=\"font-size:large\">");
                    }

                    String text = "";
                    if ("Standardname".equals(orderV[z]) && rs.get(orderV[z]) == null) {
                        text = Language.getTextfield(req.getSession(), "suche", "pzuordnung");
                    } else if (rs.get(orderV[z]) == null) {
                        text = "-";
                    } else {
                        text = rs.get(orderV[z]).toString();
                    }

                    if (orderV[z].startsWith("einzelbelegID")) {
                        text = rs.get("Belegform").toString();
                    }

                    String titel = orderV[z];

                    if (orderV[z].startsWith("einzelbelegID")) {
                        titel = "Belegform";
                    }

                    titel = headlines.get(fieldNames.indexOf(titel));

                    if (titel.isEmpty()) {
                        out.print(titel);
                    } else {
                        out.print(titel + ": ");
                    }

                    boolean link = false;

                    if (!text.equals("-")) {
                        if (orderV[z].equals("einzelbelegID") && rs.get("einzelbelegID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "B" + rs.get("einzelbelegID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("e2ID") && rs.get("e2ID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "B" + rs.get("e2ID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("Standardname") && rs.get("personID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "P" + rs.get("personID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("perszuStandardname") && rs.get("perszuID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "P" + rs.get("perszuID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("PLemma") && rs.get("namenkommentarID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "N" + rs.get("namenkommentarID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("MGHLemma") && rs.get("mgh_lemmaID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "M" + rs.get("mgh_lemmaID")) + "\">");
                            link = true;
                        } else if (orderV[z].equals("Bezeichnung") && rs.get("quelleID") != null) {                              // ?
                            out.print("<a href=\"" + getPidUrl(req, "Q" + rs.get("quelleID")) + "\">");
                            link = true;
                        }
                    }

                    if (orderV[z].startsWith("einzelbelegID")) {
                        out.print(format(escapeHTML(text), "Belegform"));
                    } else if (orderV[z].endsWith("Jahr")) {
                        int ja = Integer.parseInt(oldValue[z]);
                        out.print("" + (ja * zeitraum) + "-" + ((ja + 1) * zeitraum - 1));
                    } else {

                        String format = orderV[z];
                        if (orderV[z].equals("Erstglied") || orderV[z].equals("Zweitglied")) {
                            format = "PLemma";
                        }
                        out.print(format(escapeHTML(text), format));
                    }
                    if (link) {
                        out.print("</a> &nbsp;");
                    } else {
                        out.print(" ");
                    }

                    if (z == orderSize - 1) {
                        out.print("<ul><table class=\"resultlist\" width=\"100%\">" + header + "<tr>");
                    } else {
                        out.print("<ul>");
                    }

                }
            }

            out.print("<tr class=\"" + (even ? "" : "un") + "even\">");

            for (int i = 0; i < fieldNames.size(); i++) {
                if (fieldNames.get(i).endsWith("Jahrhundert") || fieldNames.get(i).endsWith("Jahr") || fieldNames.get(i).endsWith("Monat") || fieldNames.get(i).endsWith("Tag") || !order.contains(fieldNames.get(i))) {
                    out.print("<td class=\"resultlist\" valign=\"top\">");

                    if (rs.get(fieldNames.get(i)) != null && !escapeHTML(rs.get(fieldNames.get(i)).toString()).equals("")) {
                        String cell = escapeHTML(rs.get(fieldNames.get(i)).toString());
                        boolean link = false;

                        if (fieldNames.get(i).contains("Belegform") && rs.get("einzelbelegID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "B" + rs.get("einzelbelegID")) + "\">");
                            link = true;
                        }
                        if (fieldNames.get(i).contains("Belegform") && rs.get("e2ID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "B" + rs.get("e2ID")) + "\">");
                            link = true;
                        } else if (fieldNames.get(i).contains("Standardname") && rs.get("personID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "P" + rs.get("personID")) + "\">");
                            link = true;
                        } else if (fieldNames.get(i).contains("perszuStandardname") && rs.get("perszuID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "P" + rs.get("perszuID")) + "\">");
                            link = true;
                        } else if (fieldNames.get(i).contains("PLemma") && rs.get("namenkommentarID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "N" + rs.get("namenkommentarID")) + "\">");
                            link = true;
                        } else if (fieldNames.get(i).contains("MGHLemma") && rs.get("mgh_lemmaID") != null) {
                            out.print("<a href=\"" + getPidUrl(req, "M" + rs.get("mgh_lemmaID")) + "\">");
                            link = true;
                        } else if (fieldNames.get(i).contains("Bezeichnung") && rs.get("quelleID") != null) {        //?
                            out.print("<a href=\"" + getPidUrl(req, "Q" + rs.get("quelleID")) + "\">");
                            link = true;
                        }

                        if (fieldNames.get(i).endsWith("PLemma") || fieldNames.get(i).equals("Erstglied") || fieldNames.get(i).equals("Zweitglied")) {
                            cell = format(cell, "PLemma");
                        }
                        out.print(cell);
                        if (link) {
                            out.print("</a> ");
                        }
                    } else {
                        out.print("&nbsp;");
                    }
                    out.print("</td>");
                }

            }

            out.print("</tr>");
            even = !even;
        }

        //final closing...
        out.print("</tr>");
        out.print("</table>");

        for (int z = orderSize - 2; z >= 0; z--) {
            out.print("</ul></li>");
        }

        out.print("</ul>");
    }

    // Hilfsfunktion zum Hinzufügen von Feldern, wenn sie gültig sind
    public static void addIfValid(JSONObject jsonObject, String key, Object value) {
        if (value != null) {
            jsonObject.put(key, value);
        }
    }

    // Hilfsfunktion zum Bereinigen von Strings
    public static String sanitize(String value) {
        if (value == null || "null".equalsIgnoreCase(value) || "-".equals(value.trim()) || "--".equals(value.trim()) || value.trim().isEmpty()) {
            return null;
        }
        return value;
    }

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");

    public static String formatDate(Date date) {
        return date != null ? DATE_FORMAT.format(date) : null;
    }

    public static long getLastModifiedTimestampForLocalAsset(ServletContext context, String path) throws Exception {
        URL resource = context.getResource(path);

        if (resource == null) {
            throw new Exception("Resource not found: " + path);
        }

        if (!"file".equals(resource.getProtocol())) {
            throw new Exception("Unexpected protocol: " + resource.getProtocol() + " for path: " + path);
        }

        File file = new File(resource.toURI());

        if (!file.exists()) {
            throw new Exception("File does not exist: " + file.getAbsolutePath());
        }

        //Änderungszeit zurückgeben
        return file.lastModified();
    }

    public static String getVersionedHref(HttpServletRequest request, ServletContext context, String path) throws Exception {
        long timestamp = getLastModifiedTimestampForLocalAsset(context, path);
        String baseUrl = getBaseUrl(request);
        String href;

        if (!baseUrl.endsWith("/") && !path.startsWith("/")) {
            href = baseUrl + "/" + path;
        } else if (baseUrl.endsWith("/") && path.startsWith("/")) {
            href = baseUrl + path.substring(1);
        } else {
            href = baseUrl + path;
        }

        return href + "?v=" + timestamp;
    }

    /**
     * Prüft, ob alle Elemente eines String-Arrays gleich dem gesuchten Wert
     * sind.
     *
     * @param arr Das zu prüfende Array
     * @param value Der Wert, auf den geprüft werden soll
     * @return true, wenn das Array nicht null ist, mindestens ein Element
     * enthält und alle Werte gleich value sind.
     */
    public static boolean allValuesAre(String[] arr, String value) {
        if (arr == null || arr.length == 0) {
            return false;
        }
        for (String elem : arr) {
            if (!value.equals(elem)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Remove diacritical marks from a string, e.g. "abię" => "abie"
     */
    public static String removeDiacriticalMarks(final String input)  {
        // Note on implementation:
        // - There is no function in MySQL to do this (in PostgreSQL there would be one)
        // - In Java we could also use org.apache.commons.lang3, but we don't want to use a dependency if it's also possible to do it directly in java

        // Normalize the input string to decompose characters
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);

        // Remove diacritical marks using regex
        Pattern pattern = Pattern.compile("\\p{M}");
        return pattern.matcher(normalized).replaceAll("");
    }
}
