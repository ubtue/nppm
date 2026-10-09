package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class QuelleServlet extends AbstractGastServlet {
    @Override
    protected String getTitle() {
        return "quelle";
    }

    @Override
    protected String getNavigationTitle() {
        return "quelle";
    }

    @Override
    protected String getCanonicalUrl(HttpServletRequest request) {
        if (request.getParameter("ID") != null) {
            return Utils.getPidUrl(request, "Q" + request.getParameter("ID"));
        }
        return null;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(request.getParameter("page") != null && request.getParameter("page").equals("stat")){
            RequestDispatcher rd = request.getRequestDispatcher("stat.jsp");
            rd.include(request, response);
        }
        else if (request.getParameter("ID") == null) {
          response.sendRedirect(Utils.getPidUrl(request, QuelleDB.getFirstPublicQuelle().getPersistentIdentifier()));
        }
        else {
            RequestDispatcher rd = request.getRequestDispatcher("quelle.jsp");
            rd.include(request, response);
        }
    }
}
