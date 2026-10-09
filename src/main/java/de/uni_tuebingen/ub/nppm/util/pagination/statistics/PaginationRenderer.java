package de.uni_tuebingen.ub.nppm.util.pagination.statistics;

import de.uni_tuebingen.ub.nppm.util.Language;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

public class PaginationRenderer {

    public static void printPagination(JspWriter out, int nOfPages, PaginationParams params, String pageName, HttpSession session, HttpServletRequest request) throws Exception {
        out.println("<div class=\"statistica\">");
        out.println("<nav aria-label=\"Navigation for rows\">");
        out.println("<ul class=\"ut-nav__list\">");

        out.println(htmlFirstButton(params, pageName, request));

        if (params.getCurrentPage() > 1) {
            out.println(htmlPrevButton(params, pageName, request));
        }

        int currentPage = params.getCurrentPage();
        int maxVisiblePages = 10;

        int startPage = 1;
        int endPage = Math.min(nOfPages, maxVisiblePages);

        if (currentPage > 6 && nOfPages > maxVisiblePages) {
            startPage = currentPage - 4;
            endPage = currentPage + 5;

            if (endPage > nOfPages) {
                endPage = nOfPages;
                startPage = nOfPages - 9;
                if (startPage < 1) {
                    startPage = 1;
                }
            }
        }

// Seitenbuttons innerhalb des sichtbaren Bereichs
        for (int i = startPage; i <= endPage; i++) {
            if (currentPage == i) {
                out.println(htmlPageItemCurrent(i, params, pageName, request));
            } else {
                out.println(htmlPageItem(i, params, pageName, request));
            }
        }

// Ellipsis und letzter Button, wenn nötig
        if (endPage < nOfPages) {
            out.println("<li class=\"ut-nav__item\">...</li>");
            out.println(htmlPageItem(nOfPages, params, pageName, request));
        }

        if (params.getCurrentPage() < nOfPages) {
            out.println(htmlNextButton(params, pageName, request));
        }

        out.println(htmlLastButton(params, pageName, nOfPages, request));

        out.println("</ul>");
        out.println("</nav>");
        out.println("</div>");
    }

    private static String htmlPrevButton(PaginationParams params, String pageName, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage() - 1, null);
        String prev = Language.getTextfield(request.getSession(), "pagination", "Prev");
        return "<li class=\"ut-nav__item\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 prev-button\">" + prev + "</button></a>"
                + "<a class=\"ut-link page-link prev-link pagination-small\" href=\"" + url + "\" rel=\"nofollow\">&lt;</a>"
                + "</li>";
    }

    private static String htmlNextButton(PaginationParams params, String pageName, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage() + 1, null);
        String next = Language.getTextfield(request.getSession(), "pagination", "Next");
        return "<li class=\"ut-nav__item\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 next-button\">" + next + "</button></a>"
                + "<a class=\"ut-link page-link next-link pagination-small\" href=\"" + url + "\" rel=\"nofollow\">&gt;</a>"
                + "</li>";
    }

    private static String htmlPageItemCurrent(int page, PaginationParams params, String pageName, HttpServletRequest request) {
        String url = params.buildUrl(request, pageName, page, null);
        return "<li class=\"ut-nav__item\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" disabled=\"disabled\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-1 current-button\" disabled=\"disabled\">" + page + "</button></a>"
                + "<a class=\"ut-link page-link active current-link pagination-small\" href=\"" + url + "\" disabled=\"disabled\" rel=\"nofollow\">" + page + "</a>"
                + "</li>";
    }

    private static String htmlPageItem(int page, PaginationParams params, String pageName, HttpServletRequest request) {
        String url = params.buildUrl(request, pageName, page, null);

        return "<li class=\"ut-nav__item statistica\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-2 page-button\">" + page + "</button></a>"
                + "<a class=\"ut-link page-link pagination-small\" href=\"" + url + "\" rel=\"nofollow\">" + page + "</a>"
                + "</li>";
    }

    public static String htmlSortTitleUp(PaginationParams params, String pageName, HttpSession session, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage(), "titleUp");

        return "<a class=\"ut-link sort-link\" href=\"" + url + "\" rel=\"nofollow\">"
                + Language.getTextfield(session, "pagination", "SortAZ")
                + "</a>";
    }

    public static String htmlSortTitleDown(PaginationParams params, String pageName, HttpSession session, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage(), "titleDown");

        return "<a class=\"ut-link sort-link\" href=\"" + url + "\" rel=\"nofollow\">"
                + Language.getTextfield(session, "pagination", "SortZA")
                + "</a>";
    }

    public static String htmlSortBelegeUp(PaginationParams params, String pageName, HttpSession session, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage(), "belegeUp");

        return "<a class=\"ut-link sort-link\" href=\"" + url + "\" rel=\"nofollow\">"
                + Language.getTextfield(session, "pagination", "SortUp")
                + "</a>";
    }

    public static String htmlSortBelegeDown(PaginationParams params, String pageName, HttpSession session, HttpServletRequest request) throws Exception {
        String url = params.buildUrl(request, pageName, params.getCurrentPage(), "belegeDown");

        return "<a class=\"ut-link sort-link\" href=\"" + url + "\" rel=\"nofollow\">"
                + Language.getTextfield(session, "pagination", "SortDown")
                + "</a>";
    }

    public static String htmlFirstButton(PaginationParams params, String pageName, HttpServletRequest request) throws Exception {
        if (params.getCurrentPage() <= 1) {
            return "";
        }

        String url = params.buildUrl(request, pageName, 1, null);
        String first = Language.getTextfield(request.getSession(), "pagination", "First");
        return "<li class=\"ut-nav__item\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 first-button\">" + first + "</button></a>"
                + "<a class=\"ut-link page-link first-link pagination-small\" href=\"" + url + "\" rel=\"nofollow\">|&lt;</a>"
                + "</li>";
    }

    public static String htmlLastButton(PaginationParams params, String pageName, int nOfPages, HttpServletRequest request) throws Exception {
        if (params.getCurrentPage() >= nOfPages) {
            return "";
        }

        String url = params.buildUrl(request, pageName, nOfPages, null);
        String last = Language.getTextfield(request.getSession(), "pagination", "Last");
        return "<li class=\"ut-nav__item\">"
                + "<a class=\"pagination-big\" href=\"" + url + "\" rel=\"nofollow\"><button class=\"ut-btn ut-btn--color-primary-3 last-button\">" + last + "</button></a>"
                + "<a class=\"ut-link page-link last-link pagination-small\" href=\"" + url + "\" rel=\"nofollow\">&gt;|</a>"
                + "</li>";
    }
}
