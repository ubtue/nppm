package de.uni_tuebingen.ub.nppm.servlet.gast;

import de.uni_tuebingen.ub.nppm.db.ContentDB;
import de.uni_tuebingen.ub.nppm.model.Content;
import de.uni_tuebingen.ub.nppm.util.Constants;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import javax.persistence.NoResultException;

public class SharedHtmlServlet extends AbstractGastServlet {

    @Override
    protected String getTitle() {
        return setTitel(currentRequest);
    }

    private String setTitel(HttpServletRequest request) {
        if (request != null) {
            String myFile = request.getParameter("sharedHtml");
            return myFile != null ? myFile : "";
        }
        return "";
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // Überprüfen, ob eine neue Sprache ausgewählt wurde und in der Session speichern
        String newLanguage = request.getParameter("language");
        if (newLanguage != null && !newLanguage.isEmpty()) {
            request.getSession().setAttribute("Sprache", newLanguage);
        }

        // Sprache aus der Session holen
        String selectedLanguage = (String) request.getSession().getAttribute("Sprache");

        // Wenn keine Sprache in der Session gespeichert ist, eine Standardsprache setzen
        if (selectedLanguage == null) {
            selectedLanguage = Constants.DEFAULT_LANG; // Standard: Englisch
            request.getSession().setAttribute("Sprache", selectedLanguage);
        }

        // HTML-Dateiname aus der Anfrage holen und .html anhängen, wenn nötig
        String myFile = request.getParameter("sharedHtml");
        if (myFile != null && !myFile.endsWith(".html")) {
            myFile += ".html";
        }
        try {
            // Inhalt aus der Datenbank basierend auf dem Dateinamen und der Sprache holen
            Content content = ContentDB.getByNameAndLanguage(myFile, selectedLanguage);
            if (content != null) {
                response.setContentType("text/html; charset=UTF-8");
                // Inhalt senden
                PrintWriter writer = response.getWriter();
                byte[] htmlBytes = content.getContent();
                writer.write(new String(htmlBytes, "UTF-8"));
                writer.flush();
            }

        } catch (NoResultException e) {
            Content content = null;
            try{
                //Versuche erst englisch zu holen
                content = ContentDB.getByNameAndLanguage(myFile, Constants.DEFAULT_LANG);
            }catch(NoResultException e1){
                // Fehlerbehandlung benutze Standard Sprache Deutsch, da für nicht alle wie Hilfe.html eine Englische Version vorhanden ist
                content = ContentDB.getByNameAndLanguage(myFile, Constants.FALLBACK_LANG);
            }
            if(content == null){
                throw new NoResultException("No Content found for "+myFile);
            }
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter writer = response.getWriter();
            byte[] htmlBytes = content.getContent();
            writer.write(new String(htmlBytes, "UTF-8"));
            writer.flush();
        }
    }

    @Override
    protected String getDynamicNavigationTitle(HttpServletRequest request, HttpServletResponse response) {
        String current = (String) request.getParameter("current");

        //Wenn current == null und sharedHtml == start muss current trotzdem gesetzt sein,
        //da sonst der Start Button nicht gehighlightet wird
        String sharedHtml = (String) request.getParameter("sharedHtml");
        if(current == null && sharedHtml != null && sharedHtml.trim().equals("start")){
            current = "start";
        }

        if(current != null && current.equals("start")){
            return "start";
        }

        return "";
    }
}
