package de.uni_tuebingen.ub.nppm.servlet.gast;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StaticHtmlServlet extends AbstractGastServlet {
    protected String page;

    @Override
    protected String getTitle() {
        return page;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getParameter("page") == null) {
            throw new Exception("No page given");
        }
        page = request.getParameter("page");

        RequestDispatcher rd = request.getRequestDispatcher("static/" + page + ".jsp");
        rd.include(request, response);
    }
}
