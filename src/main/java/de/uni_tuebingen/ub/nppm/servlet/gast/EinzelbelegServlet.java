package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EinzelbelegServlet extends AbstractGastServlet {
    @Override
    protected String getTitle() {
        return "einzelbeleg";
    }

    @Override
    protected String getNavigationTitle() {
        return "einzelbeleg";
    }

    @Override
    protected String getCanonicalUrl(HttpServletRequest request) {
        if (request.getParameter("ID") != null) {
            return Utils.getPidUrl(request, "B" + request.getParameter("ID"));
        }
        return null;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getParameter("ID") == null) {
            response.sendRedirect(Utils.getPidUrl(request, EinzelbelegDB.getFirstPublicEinzelbeleg().getPersistentIdentifier()));
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("einzelbeleg.jsp");
            rd.include(request, response);
        }
    }
}
