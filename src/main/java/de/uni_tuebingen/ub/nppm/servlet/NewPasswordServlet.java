package de.uni_tuebingen.ub.nppm.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.*;
import de.uni_tuebingen.ub.nppm.util.*;
import javax.servlet.http.HttpSession;

public class NewPasswordServlet extends HttpServlet {

    private void writeHTMLMessage(HttpServletResponse response, String[] messages) throws IOException {
        PrintWriter pw = response.getWriter();
        pw.println("<!DOCTYPE html>");
        pw.println("<html>");
        pw.println("<head>");
        pw.println("<title>Nomen et Gens</title>");
        pw.println("</head>");
        pw.println("<body>");
        for (String message : messages) {
            pw.println(message);
        }
        pw.println("</body>");
        pw.println("</html>");
    }

    private void renewPassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String URLemail = request.getParameter("url_email"); //<input type hidden >---> form -->forgotPassword
        String password = request.getParameter("newPassword");
        String repeatPassword = request.getParameter("repeatPassword");
        HttpSession session = request.getSession();

        Benutzer benutzer = BenutzerDB.getByMail(URLemail);

        if (password != null && password.length() >= 6 && password.equals(repeatPassword)) {

            byte[] salt = SaltHash.GenerateRandomSalt(AuthHelper.getPasswordSaltLength());
            String passHash = SaltHash.GenerateHash(password, AuthHelper.getPasswordHashingAlgorithm(), salt);

            benutzer.setSalt(SaltHash.BytesToBase64String(salt));
            benutzer.setPassword(passHash);
            benutzer.setResetToken(null);
            benutzer.setResetTokenValidUntil(null);
            BenutzerDB.saveOrUpdate(benutzer);

            String[] message = new String[2];
            message[0] = "<h1 style=\"text-align: center;\"> " + Language.getTextfield(session, "login", "PasswortGesetzt") + "</h1>";
            message[1] = "<h1 style=\"text-align: center;\"><a href=\"" + Utils.getBaseUrl(request) + "/logout?go=intern\">" + Language.getTextfield(session, "login", "ZumLogin") + "</a></h1>";
            writeHTMLMessage(response, message);

        } else if (password != null && password.length() < 6) {
            String[] message = new String[1];
            message[0] = "<h1 style=\"text-align: center;\">" + Language.getTextfield(session, "login", "ZuKurz") + "</h1>";
            writeHTMLMessage(response, message);

        } else if (!repeatPassword.equals(password)) {
            String[] message = new String[1];
            message[0] = "<h1 style=\"text-align: center;\">" + Language.getTextfield(session, "login", "ErrorPasswortWiederholung") + "</h1>";
            writeHTMLMessage(response, message);
        } else { //User should generate a new Link
            String[] message = new String[2];
            message[0] = "<h1 style=\"text-align: center;\">" + Language.getTextfield(session, "login", "LinkUngueltig") + "</h1>";
            message[1] = "<h1 style=\"text-align: center;\"><a href=\"" + Utils.getBaseUrl(request) + "/forgotPassword\">" + Language.getTextfield(session, "login", "NeuerLink") + "</a></h1>";
            writeHTMLMessage(response, message);
        }
    }

    private void sendLink(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, Exception {
        HttpSession session = request.getSession();
        LocalDateTime timeOfGeneratedUUID = LocalDateTime.now();
        //2. Generate UUID
        String uuid_content = String.valueOf(UUID.randomUUID());

        String errorEmail = Language.getTextfield(session, "login", "ErrorEmailAdresse");

        //1. take the e-mail Address from user
        String email = request.getParameter("email");
        //Check if E-Mail is reguistered in database

        if (email == null || email.equals("")) {
            String[] message = new String[1];
            message[0] = "<h1 style=\"text-align: center;\">" + Language.getTextfield(session, "login", "KeineEmailEingegeben") + "</h1>";
            writeHTMLMessage(response, message);
        } else {
            boolean emailIsRegistered = BenutzerDB.hasEmail(email);
            if (emailIsRegistered == false) {
                String[] message = new String[1];
                message[0] = "<h1 style=\"text-align: center;\">" + errorEmail + "</h1>";
                writeHTMLMessage(response, message);
            } else {
                response.setContentType("text/html");

                String myLinkString = Utils.getBaseUrl(request) + "/forgotPassword?varURLUUID=" + Utils.escapeURL(uuid_content) + "&varURLEmail=" + Utils.escapeURL(email) + "&varURLTime=" + Utils.escapeURL(timeOfGeneratedUUID.toString());

                //Message in usesers email
                String htmlMessage = "<html>";
                htmlMessage += "<head>";
                htmlMessage += "<meta charset=\"UTF-8\">";
                htmlMessage += "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">";
                htmlMessage += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
                htmlMessage += "</head>";
                htmlMessage += "<body>";
                htmlMessage += "<h1>" + Language.getTextfield(session, "login", "PasswortZuruecksetzen") + "</h1>";
                htmlMessage += "<p>" + Language.getTextfield(session, "login", "MessageOne") + "</p>";
                htmlMessage += "<p>" + Language.getTextfield(session, "login", "MessageTwo") + "</p>";
                htmlMessage += "<a href=\"";
                htmlMessage += myLinkString;
                htmlMessage += "\">" + Language.getTextfield(session, "login", "Zuruecksetzen") + "</a>";
                htmlMessage += "</body>";
                htmlMessage += "</html>";

                try {
                    //write UUUID & timeOfGeneratedUUID in (database) table benutzer
                    Benutzer benutzer = BenutzerDB.getByMail(email);
                    benutzer.setResetToken(uuid_content);
                    benutzer.setResetTokenValidUntil(timeOfGeneratedUUID);
                    BenutzerDB.saveOrUpdate(benutzer);

                    //write in Servlet Succesfull created for the user
                    String[] message = new String[1];
                    message[0] = "<h1 style=\"text-align: center;\">" + Language.getTextfield(session, "login", "ErfolgGeheZuEmail") + "</h1>";
                    writeHTMLMessage(response, message);
                    MailSender.Send("no-reply@ub.uni-tuebingen.de", "NPPM Mailer", email, Language.getTextfield(session, "login", "EmailBetreff"), htmlMessage);
                } catch (Exception ex) {
                    String errorMessage = ex.toString();
                    String[] message = new String[1];
                    message[0] = "<h1" + errorMessage + "  </h1>";
                    writeHTMLMessage(response, message);
                    Logger
                            .getLogger(NewPasswordServlet.class
                                    .getName()).log(Level.SEVERE, null, ex);
                    throw new ServletException(ex);
                }
            }
        }
    }//end renewPassword

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NoSuchAlgorithmException, Exception {

        String URLuuid = request.getParameter("url_uuid"); //<input type hidden >---> form -->forgotPassword
        String URLemail = request.getParameter("url_email"); //<input type hidden >---> form -->forgotPassword

        if (URLuuid != null && !URLuuid.equals("") && URLemail != null && !URLemail.equals("")) {
            renewPassword(request, response);
        } else {
            sendLink(request, response);
        }
    }//end processRequest()

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);

        } catch (Exception ex) {
            Logger.getLogger(NewPasswordServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }//end doGet()

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);

        } catch (Exception ex) {
            Logger.getLogger(NewPasswordServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }//end doPost()

}//end Class NewPasswordServlet
