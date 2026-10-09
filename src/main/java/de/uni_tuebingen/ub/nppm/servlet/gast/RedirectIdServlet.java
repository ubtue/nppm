package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.exception.*;
import de.uni_tuebingen.ub.nppm.util.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Note: due to the dynamic URL schema configured in web.xml, this may not extend our regular
// abstract servlet classes.
public class RedirectIdServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String URI = request.getRequestURI();                 // e.g. /nppm/id/P7404
        String PID = URI.substring(URI.lastIndexOf("/") + 1); // e.g. P7404
        String ID = PID.substring(1);                         // e.g. 7404

        try {
            String form = IdentifierMapper.getFormByIdentifier(PID);
            String target = "/gast/" + form + "?ID=" + ID;

            // Use forward instead of redirect so the URL stays the same
            request.getRequestDispatcher(target).forward(request, response);
        } catch (IdInvalidException e) {
            throw new ServletException(e);
        }
    }
}
