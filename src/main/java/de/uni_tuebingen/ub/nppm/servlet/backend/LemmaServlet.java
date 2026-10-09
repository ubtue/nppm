package de.uni_tuebingen.ub.nppm.servlet.backend;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LemmaServlet extends AbstractBackendServlet {

    @Override
    protected String getTitle() {
        return "mgh_lemma";
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher("lemma.jsp");
        rd.include(request, response);
    }
}
