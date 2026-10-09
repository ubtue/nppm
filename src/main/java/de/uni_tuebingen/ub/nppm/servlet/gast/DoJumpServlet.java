package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.db.EinzelbelegDB;
import de.uni_tuebingen.ub.nppm.db.LemmaDB;
import de.uni_tuebingen.ub.nppm.db.PersonDB;
import de.uni_tuebingen.ub.nppm.db.QuelleDB;
import de.uni_tuebingen.ub.nppm.exception.IdInvalidException;
import de.uni_tuebingen.ub.nppm.util.Utils;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DoJumpServlet extends AbstractGastServlet {

    @Override
    protected String getTitle() {
        return setTitel(currentRequest);
    }

    private String setTitel(HttpServletRequest request) {
        String current = (String) request.getParameter("current");
        if (current == null) {
            current = "start"; // Fallback nur wenn nicht gesetzt
        }
        return current;
    }

    @Override
    protected String getNavigationTitle(HttpServletRequest request, HttpServletResponse response) {
        String current = (String) request.getParameter("current");
        if (current == null) {
            current = "start"; // Fallback nur wenn nicht gesetzt
        }
        return current;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception, IdInvalidException {
        HttpSession session = request.getSession();

        String title = request.getParameter("form");
        String newID = request.getParameter("jumpValueID");
        if (newID != null) {
            newID = newID.trim();
        }

        if (newID != null && !newID.isEmpty() && request.getParameter("jumpID") != null && (request.getParameter("jumpID").equals("los") || request.getParameter("jumpID").equals(">"))) {
            String guestTable = request.getParameter("jumpTableGuest");
            String jumpTable = request.getParameter("jumpTable");
            String newForm = "";

            /*
            // e.g. if the jump target is just 7404 (without P prefix) and we do not have a default form given
            if (title.equals("") && !newID.matches("^[A-Z]")) {
                throw new IdInvalidException();
            }
             */
            if (newID.startsWith("B") || newID.startsWith("b") || ("einzelbeleg".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Einzelbelege".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "einzelbeleg";
            } else if (newID.startsWith("P") || newID.startsWith("p") || ("person".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Personen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "person";
            } else if (!"guestTable".equals(guestTable) && (newID.startsWith("N") || newID.startsWith("n") || ("namenkommentar".equals(jumpTable) && newID.matches("^[0-9].*")))) {
                newForm = "namenkommentar";
            } else if (newID.startsWith("Q") || newID.startsWith("q") || ("quelle".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Quellen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "quelle";
            } else if (newID.startsWith("E") || newID.startsWith("e") || ("edition".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "edition";
            } else if (newID.startsWith("T") || newID.startsWith("t") || ("handschrift".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "handschrift";
            } else if (newID.startsWith("M") || newID.startsWith("m") || ("mgh_lemma".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Namen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "lemma";
            } else {
                throw new IdInvalidException();
            }

            String url = request.getRequestURL().toString();

            session.setAttribute(title + "filter", 0);
            session.setAttribute(title + "filterParameter", "");
            url = url.substring(0, url.lastIndexOf('/') + 1);
            String publicID = null;

            if (url.endsWith("gast/") && (newForm.equals("edition") || newForm.equals("handschrift"))) {
                throw new IdInvalidException();
            } else {
                if (newID.matches("^[BPNQETMbpnqetm].*")) { // Alle gewünschten Buchstaben
                    newID = newID.substring(1);
                }

                switch (newForm) {
                    case "quelle":
                        publicID = "Q" + QuelleDB.getNextPublicQuelleID(Integer.parseInt(newID));
                        break;

                    case "einzelbeleg":
                        publicID = "B" + EinzelbelegDB.getNextPublicEinzelbeleg(Integer.parseInt(newID));
                        break;

                    case "lemma":
                        publicID = "M" + LemmaDB.getNextPublicMGHLemmaID(Integer.parseInt(newID));
                        break;

                    case "person":
                        publicID = "P" + PersonDB.getNextPublicPersonId(Integer.parseInt(newID));
                        break;
                }

                if (publicID != null) {
                    response.sendRedirect(Utils.getPidUrl(request, publicID));
                } else {
                    throw new IdInvalidException();
                }
            }
        }
    }
}
