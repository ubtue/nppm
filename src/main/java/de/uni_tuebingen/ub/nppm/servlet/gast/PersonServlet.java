package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class PersonServlet extends AbstractGastServlet {
    @Override
    protected String getTitle() {
        return "person";
    }

    @Override
    protected String getNavigationTitle() {
        return "person";
    }

    @Override
    protected String getCanonicalUrl(HttpServletRequest request) {
        if (request.getParameter("ID") != null) {
            return Utils.getPidUrl(request, "P" + request.getParameter("ID"));
        }
        return null;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getParameter("ID") == null) {
            response.sendRedirect(Utils.getPidUrl(request, PersonDB.getFirstPublicPerson().getPersistentIdentifier()));
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("person.jsp");
            rd.include(request, response);
        }
    }
}
