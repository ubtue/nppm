package de.uni_tuebingen.ub.nppm.servlet.backend;

import de.uni_tuebingen.ub.nppm.db.ContentDB;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;




/**
 *
 * @author root
 */
public class BerechneDateiSpracheServlet extends HttpServlet {


     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileName = request.getParameter("param1");
        String fileLanguage = request.getParameter("param2");

        // Überprüfen, ob fileName und fileLanguage nicht null und nicht leer sind
        if (fileName != null && !fileName.equals("") && fileLanguage != null && !fileLanguage.equals("")) {
            try {
                // Suchen Sie in der Datenbank nach der Datei basierend auf dem Namen und der Sprache
                boolean fileExist = ContentDB.searchNameAndLanguage(fileName, fileLanguage);

                // Setzen des Antwortinhalts
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");

                // Senden der Antwort basierend auf dem Ergebnis der Suche
                if (fileExist) {
                    response.getWriter().write("true");
                } else {
                    response.getWriter().write("false");
                }
            } catch (Exception ex) {
                // Fehlerbehandlung bei auftretenden Ausnahmen
                ex.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Setzen des HTTP-Statuscodes für interne Serverfehler
                response.getWriter().write("Error occurred: " + ex.getMessage()); // Senden einer Fehlermeldung als Antwort
            }
        } else {
            // Senden einer Fehlermeldung, wenn fileName oder fileLanguage null oder leer sind
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Setzen des HTTP-Statuscodes für eine ungültige Anfrage
            response.getWriter().write("Both fileName and fileLanguage parameters are required.");
        }
    }

}
