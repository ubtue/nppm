package de.uni_tuebingen.ub.nppm.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import de.uni_tuebingen.ub.nppm.db.BenutzerDB;
import de.uni_tuebingen.ub.nppm.model.Benutzer;
import de.uni_tuebingen.ub.nppm.util.AuthHelper;
import de.uni_tuebingen.ub.nppm.util.SaltHash;
import de.uni_tuebingen.ub.nppm.util.Utils;
import de.uni_tuebingen.ub.nppm.exception.*;
import de.uni_tuebingen.ub.nppm.util.Language;

public class LoginServlet extends HttpServlet {

    protected void processLoginAction(HttpServletRequest request, HttpServletResponse response) throws Exception, LoginException {
        String login = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();



        if (login == null || login.isEmpty() || !BenutzerDB.hasLogin(login)) {
            throw new LoginException(Language.getTextfield(session, "login", "BenutzerExistiertNicht"));
        }

        Benutzer benutzer = BenutzerDB.getByLogin(login);

        if (!benutzer.isAktiv()) {
            throw new LoginException(Language.getTextfield(session, "login", "AktivSchalten"));
        }

        if (benutzer == null) {
            throw new LoginException(Language.getTextfield(session, "login", "NichtErlaubt"));
        }

        String saltString = benutzer.getSalt();
        if (saltString == null || saltString.isEmpty()) {
            throw new LoginException(Language.getTextfield(session, "login", "PasswortNeuSetzen") + " <a href=\"" + Utils.getBaseUrl(request) + "/forgotPassword\">" + Language.getTextfield(session, "login", "LinkGenerieren") + "</a>");
        }

        byte[] saltBytes = SaltHash.Base64StringToBytes(saltString);
        String passwordSalted = SaltHash.GenerateHash(password, AuthHelper.getPasswordHashingAlgorithm(), saltBytes);
        if (!passwordSalted.equals(benutzer.getPassword())) {
            throw new LoginException(Language.getTextfield(session, "login", "PasswortUngueltig"));
        }

        // Falls Session vorhanden, löschen
        if (session != null) {
            session.invalidate();
        }

        // Neue Session erzeugen
        session = request.getSession(true);
        session.setAttribute("BenutzerID", benutzer.getID());
        session.setAttribute("GruppeID", benutzer.getGruppe().getID());
        session.setAttribute("Benutzername", benutzer.getLogin());
        session.setAttribute("Administrator", benutzer.isAdmin());
        session.setAttribute("Gast", benutzer.isGast());
        session.setAttribute("Sprache", benutzer.getSprache());
        session.setMaxInactiveInterval(AuthHelper.getSessionTimeout());

        // Weiterleiten
        if (benutzer.isGast()) {
            response.sendRedirect(Utils.getBaseUrl(request) + "/gast/infos?sharedHtml=start&current=start");
        } else {
            response.sendRedirect(Utils.getBaseUrl(request) + "/einzelbeleg");
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            if (AuthHelper.isBenutzerLogin(request)) {
                response.sendRedirect(Utils.getBaseUrl(request) + "/einzelbeleg");
            } else if (request.getParameter("action") != null) {
                if (request.getParameter("action").equals("login")) {
                    processLoginAction(request, response);
                }
            } else {
                if (request.getParameter("language") != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("Sprache", request.getParameter("language"));
                    session.setMaxInactiveInterval(AuthHelper.getSessionTimeout());
                }

                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.include(request, response);
            }
        }catch (LoginException e) {
            request.setAttribute("javax.servlet.error.exception", e);
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, e.getMessage());
        }
        catch (Exception e) {
            response.sendError(500, e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
