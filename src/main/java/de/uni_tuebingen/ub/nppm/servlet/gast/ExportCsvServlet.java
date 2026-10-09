package de.uni_tuebingen.ub.nppm.servlet.gast;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

import com.opencsv.CSVWriter;
import de.uni_tuebingen.ub.nppm.db.SucheDB;
import de.uni_tuebingen.ub.nppm.util.Language;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExportCsvServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = request.getParameter("query");
        if (query == null || query.trim().length() < 3) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Query");
            return;
        }

        response.setContentType("text/csv; charset=UTF-8");
        String filename = "searchResult.csv"; //fallback filename
        try {
            filename = Language.getTextfield(request.getSession(), "such_ergebnis", "Titel")+".csv";
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,ex.getLocalizedMessage());
        }
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(filename, StandardCharsets.UTF_8) + "\"");

        List<String> fieldNames = Arrays.asList(
                "Belegform", "Bezeichnung", "seite",
                "raster", "editionZitierweise", "EditionKapitel", "EditionSeite",
                "quelleVonJahr", "quelleVonJahrhundert", "quelleBisJahr", "quelleBisJahrhundert",
                "VonJahr", "VonJahrhundert", "BisJahr", "BisJahrhundert", "quelleBerJahr", "Standardname"
        );

        List<String> headlines = new ArrayList<>();

        try {
            headlines.add(Language.getTextfield(request.getSession(), "suche", "Belegform"));
            headlines.add(Language.getTextfield(request.getSession(), "freie_suche", "Quelle"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "NummerSeite"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "Raster"));
            headlines.add(Language.getTextfield(request.getSession(), "quelle", "Edition"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "Cap"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "Pag"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "QvJ"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "QvJh"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "QbJ"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "QbJh"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "EBvJ"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "EBvJh"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "EBbJ"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "EBbJh"));
            headlines.add(Language.getTextfield(request.getSession(), "suche", "QJahr"));
            headlines.add(Language.getTextfield(request.getSession(), "person", "Person"));

        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,ex.getLocalizedMessage());
        }


        List<Map> result;
        try {
            result = SucheDB.getEinfacheSucheResult(query);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve search results: " + e.getMessage());
            return;
        }

        try (
                OutputStreamWriter osw = new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8); CSVWriter csvWriter = new CSVWriter(osw, ';', CSVWriter.DEFAULT_QUOTE_CHARACTER,
                        CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END)) {
            // Kopfzeile
            csvWriter.writeNext(headlines.toArray(new String[0]));

            // Datenzeilen
            for (Map row : result) {
                String[] data = new String[fieldNames.size()];
                for (int i = 0; i < fieldNames.size(); i++) {
                    Object val = row.get(fieldNames.get(i));
                    // Spezialfall Standardname
                    if (fieldNames.get(i).equals("Standardname")) {
                        if (val == null || "".equals(String.valueOf(val).trim())) {
                            try {
                                data[i] = Language.getTextfield(request.getSession(), "suche", "pzuordnung");
                            } catch (Exception ex) {
                                data[i] = "-";
                            }
                        } else {
                            data[i] = val.toString();
                        }
                    } // Spezialfall quelleBerJahr
                    else if (fieldNames.get(i).equals("quelleBerJahr") && val != null && "99999".equals(String.valueOf(val))) {
                        data[i] = "-";
                    } // Standard-Fall
                    else {
                        data[i] = val == null ? "" : val.toString();
                    }
                }
                csvWriter.writeNext(data);
            }
            csvWriter.flush();
        }
    }
}
