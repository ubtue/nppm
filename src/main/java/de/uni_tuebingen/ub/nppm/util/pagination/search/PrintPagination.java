package de.uni_tuebingen.ub.nppm.util.pagination.search;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.util.*;
import java.net.URISyntaxException;
import java.util.Enumeration;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;
import org.apache.http.client.utils.URIBuilder;

public class PrintPagination {

    // How many page entries should be shown before & after the current element?
    // Note: if you are at the beginning or end of the list, the size will be increased
    public static final int OFFSET_SIZE = 5;

    // Hauptfunktion: erkennt Modus anhand von Parametern
    public static void printPageNavigation(JspWriter out, HttpServletRequest request, Integer pageoffset, Integer pageLimit, Integer linecount, String export, String title) throws Exception {
        if (!"liste".equals(export) && !"browse".equals(export)) {
            return;
        }

        List<Integer> publicIds = null;
        Integer currentId = null;
        int totalPages = 0;
        int currentIndex = 0;
        boolean useIdMode = false;
        String prefix = null;

        // Modus 1: Navigation nach IDs (title != null)
        if (title != null) {
            useIdMode = true;
            prefix = IdentifierMapper.getPrefixByForm(title);
            switch (title) {
                case "person":
                    publicIds = PersonDB.getAllPublicPersonIds();
                    break;
                case "einzelbeleg":
                    publicIds = EinzelbelegDB.getAllPublicEinzelbelegIds();
                    break;
                case "quelle":
                    publicIds = QuelleDB.getAllPublicQuellenIds();
                    break;
                case "mgh_lemma":
                case "lemma":
                    publicIds = LemmaDB.getAllPublicLemmaIds();
                    break;
                default:
                    return;
            }
            totalPages = publicIds.size();
            try {
                currentId = Integer.parseInt(request.getParameter("ID"));
            } catch (Exception e) {
                currentId = publicIds.get(0);
            }
            currentIndex = publicIds.indexOf(currentId);
            if (currentIndex == -1) {
                currentIndex = 0;
            }
        } // Modus 2: Navigation nach Seitenoffset
        else if (pageoffset != null && pageLimit != null && linecount != null) {
            totalPages = (linecount + pageLimit - 1) / pageLimit;
            currentIndex = pageoffset;
        } else {
            return;
        }

        // If we are either at the front or the end, show more pages
        int minIndex = currentIndex - OFFSET_SIZE;
        int maxIndex = currentIndex + OFFSET_SIZE;
        if (minIndex < 0) {
            maxIndex = maxIndex - minIndex - 1;
            minIndex = 0;
        }
        if (maxIndex > totalPages) {
            minIndex -= (maxIndex - totalPages);
            maxIndex = totalPages;
        }

        out.println("<div class=\"resultlistnavigation\" align=\"center\">");

        // Previous Button
        if (currentIndex > 0) {
            String prev = Language.getTextfield(request.getSession(), "pagination", "Prev");
            if (useIdMode) {
                int prevID = publicIds.get(currentIndex - 1);
                out.print("<a href=\"" + Utils.getPidUrl(request, prefix + prevID) + "\"><button class=\"ut-btn ut-btn--color-primary-3 prev-button\">" + prev + "</button></a>&nbsp;");
            } else {
                String prevUrl = buildPageUrl(request, currentIndex - 1);
                out.print("<a href=\"" + prevUrl + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 prev-button\">" + prev + "</button></a>&nbsp;");
            }
        }

        // Page Number Buttons
        for (int i = 0; i < totalPages; i++) {
            boolean showFirstDots = i == 0 && i < minIndex;
            boolean showLastDots = i == totalPages - 1 && i >= maxIndex;
            boolean inWindow = i >= minIndex && i <= maxIndex;

            // Note regarding rel="nofollow":
            // This is added because we do not want bots like google etc. to crawl the whole pagination for each entity.
            // In ID mode this is OK, because these lead to pages for single entities which are also listed in the sitemap.
            // But it would not make sense for google to crawl the short view of all einzelbelege listed in a short form on other pages.

            if (showFirstDots) {
                if (useIdMode) {
                    int pageID = publicIds.get(i);
                    out.print("<a href=\"" + Utils.getPidUrl(request, prefix + pageID) + "\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">1</button></a>&nbsp;...&nbsp;");
                } else {
                    String pageUrl = buildPageUrl(request, i);
                    out.print("<a href=\"" + pageUrl + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">1</button></a>&nbsp;...&nbsp;");
                }
            }

            if (inWindow) {
                if (i == currentIndex) {
                    out.print("<button class=\"ut-btn ut-btn--color-primary-1 current-button\" disabled>");
                    out.print(i + 1);
                    out.print("</button>&nbsp;");
                } else {
                    if (useIdMode) {
                        int pageID = publicIds.get(i);
                        out.print("<a href=\"" + Utils.getPidUrl(request, prefix + pageID) + "\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">" + (i + 1) + "</button></a>&nbsp;");
                    } else {
                        String pageUrl = buildPageUrl(request, i);
                        out.print("<a href=\"" + pageUrl + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">" + (i + 1) + "</button></a>&nbsp;");
                    }
                }
            }

            if (showLastDots) {
                if (useIdMode) {
                    int pageID = publicIds.get(i);
                    out.print("...&nbsp;<a href=\"" + Utils.getPidUrl(request, prefix + pageID) + "\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">" + (i + 1) + "</button></a>&nbsp;");
                } else {
                    String pageUrl = buildPageUrl(request, i);
                    out.print("...&nbsp;<a href=\"" + pageUrl + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">" + (i + 1) + "</button></a>&nbsp;");
                }
            }
        }

        // Next Button
        if (currentIndex < totalPages - 1) {
            String next = Language.getTextfield(request.getSession(), "pagination", "Next");
            if (useIdMode) {
                int nextID = publicIds.get(currentIndex + 1);
                out.print("<a href=\"" + Utils.getPidUrl(request, prefix + nextID) + "\"><button class=\"ut-btn ut-btn--color-primary-3 next-button\">" + next + "</button></a>");
            } else {
                String nextUrl = buildPageUrl(request, currentIndex + 1);
                out.print("<a href=\"" + nextUrl + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 next-button\">" + next + "</button></a>");
            }
        }

        out.println("</div>");
    }

    // Komfortüberladung: klassischer Seitenmodus
    public static void printPageNavigation(JspWriter out, HttpServletRequest request, int pageoffset, int pageLimit, int linecount, String export) throws Exception {
        printPageNavigation(out, request, pageoffset, pageLimit, linecount, export, null);
    }

    // Komfortüberladung: klassischer ID-Modus
    public static void printPageNavigation(JspWriter out, HttpServletRequest request, String export, String title) throws Exception {
        printPageNavigation(out, request, null, null, null, export, title);
    }
    //funktioniert jetzt auch für array parameter
    private static String buildPageUrl(HttpServletRequest request, int pageoffset) {
        try {
            String requestURL = request.getRequestURL().toString(); // Basis-URL (ohne Query)
            URIBuilder uriBuilder = new URIBuilder(requestURL);

            for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
                String paramName = e.nextElement();
                if (!paramName.equals("pageoffset")) {
                    String[] values = request.getParameterValues(paramName);
                    if (values != null) {
                        for (String value : values) {
                            uriBuilder.addParameter(paramName, value);
                        }
                    }
                }
            }

            // Add pageoffset at the end
            uriBuilder.setParameter("pageoffset", String.valueOf(pageoffset));

            return uriBuilder.build().toString();
        } catch (URISyntaxException ex) {
            throw new RuntimeException("URL Build failed", ex);
        }
    }
}
