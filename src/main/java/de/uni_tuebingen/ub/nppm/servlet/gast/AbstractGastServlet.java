package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.exception.IdInvalidException;
import de.uni_tuebingen.ub.nppm.servlet.AbstractServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class AbstractGastServlet extends AbstractServlet {
    @Override
    protected String getHeaderTemplate() {
        return "servlet/header.jsp";
    }

    @Override
    protected String getFooterTemplate() {
        return "servlet/footer.jsp";
    }

    /**
     * Get the canonical URL of this page
     *
     * This should deliver the canonical URL of the current page, if applicable.
     * e.g. a person ID page can be accessed via multiple URLs:
     * 1) /id/P7404
     * 2) /gast/person.jsp?ID=7404
     *
     * The canonical URL should always be set to page 1,
     * so that bots know it is technically the same page.
     *
     * @return String
     */
    protected String getCanonicalUrl(HttpServletRequest request) {
        return null;
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws Exception, IdInvalidException {
        request.setAttribute("canonicalUrl", getCanonicalUrl(request));
        super.processRequest(request, response);
    }
}
