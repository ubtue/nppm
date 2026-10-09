package de.uni_tuebingen.ub.nppm.servlet;

import de.uni_tuebingen.ub.nppm.db.LemmaDB;
import de.uni_tuebingen.ub.nppm.model.Einzelbeleg;
import de.uni_tuebingen.ub.nppm.model.MghLemma;
import de.uni_tuebingen.ub.nppm.model.NamenKommentar;
import de.uni_tuebingen.ub.nppm.model.Person;
import de.uni_tuebingen.ub.nppm.model.Quelle;
import de.uni_tuebingen.ub.nppm.util.IdentifierMapper;
import de.uni_tuebingen.ub.nppm.exception.IdNotPublicException;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.*;
/*
    Example of REST implementation with json output
    Call URL -> http://localhost:8080/nppm/rest/item/M1
                http://localhost:8080/nppm/rest/item/N1
                http://localhost:8080/nppm/rest/item/B1
             -> http://localhost:8080/nppm/rest/items/M1,M2,M3
                http://localhost:8080/nppm/rest/items/N1,N2,N3
                http://localhost:8080/nppm/rest/items/B1,N2,N3
             Show Help Page
             -> http://localhost:8080/nppm/rest
                http://localhost:8080/nppm/rest/
 */
public class RESTServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            // Extrahiere die Identifier aus der URL
            String pathInfo = request.getPathInfo(); // Holt den Pfad (/items/N2,N3,N4)
            if (pathInfo != null) {
                String[] parts = pathInfo.split("/"); // Teilt den Pfad

                if (parts.length >= 2) {
                    String action = parts[1]; // "item" oder "items"
                    if (("item".equals(action) || "items".equals(action) || "lemma".equals(action) || "lemmas".equals(action)) && parts.length >= 3) {
                        String[] identifiers = parts[2].split(","); // IDs aufteilen

                        if ("item".equals(action) && identifiers.length == 1) {
                            processSingleIdentifier(identifiers[0], response);
                        } else if ("items".equals(action)) {
                            processMultipleIdentifiers(identifiers, response);
                        } else if ("lemma".equals(action) && identifiers.length == 1) {
                            processSingleLemma(identifiers[0], response);
                        } else if ("lemmas".equals(action)) {
                            processMultipleLemmas(identifiers, response);
                        } else {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request format: " + pathInfo);
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path format: " + pathInfo);
                    }
                } else {
                    response.setCharacterEncoding("UTF-8");
                    RequestDispatcher rd = request.getRequestDispatcher("../resthelp.jsp");
                    rd.include(request, response);
                }
            } else {
                response.setCharacterEncoding("UTF-8");
                RequestDispatcher rd = request.getRequestDispatcher("resthelp.jsp");
                rd.include(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void processSingleIdentifier(String identifier, HttpServletResponse response) throws Exception {
        try {
            JSONObject jsonObject = getJsonForIdentifier(identifier);

            if (jsonObject.has("error")) {
                if (jsonObject.getString("error").contains("is not public")) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, jsonObject.getString("error"));
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, jsonObject.getString("error"));
                }
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            //Nicht als Array zurückliefern
            response.getWriter().println(jsonObject.toString(2));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error: " + e.getMessage());
        }
    }

    private void processMultipleIdentifiers(String[] identifiers, HttpServletResponse response) throws Exception {
        try {
            JSONArray jsonArray = new JSONArray();

            for (String id : identifiers) {
                if (id != null) {
                    jsonArray.put(getJsonForIdentifier(id));
                }
            }

            // Immer ein Array zurückgeben, auch wenn nur ein Element enthalten ist
            JSONObject finalJson = new JSONObject();
            finalJson.put("items", jsonArray);

            // JSON als Antwort senden
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().println(finalJson.toString(2));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error: " + e.getMessage());
        }
    }

    private JSONObject getJsonForIdentifier(String id) throws Exception {
        JSONObject jsonObject = new JSONObject();
        Object o = null;
        String errorSuffix = " with ID " + id + " not found";

        try {
            o = IdentifierMapper.getModelByIdentifier(id);
        } catch (IdNotPublicException e) {
            errorSuffix = " with ID " + id + " is not public";
        } catch (Exception e) {
            errorSuffix = " with ID " + id + " could not be resolved";
        }

        if (id.startsWith("M")) {
            if (o != null) {
                MghLemma lemma = (MghLemma)o;
                jsonObject = lemma.getJSON();
            } else {
                jsonObject.put("error", "Lemma" + errorSuffix);
                jsonObject.put("id", id);
            }
        } else if (id.startsWith("N")) {
            if (o != null) {
                NamenKommentar nk = (NamenKommentar)o;
                jsonObject = nk.getJSON();
            } else {
                jsonObject.put("error", "Namenkommentar" + errorSuffix);
                jsonObject.put("id", id);
            }
        } else if (id.startsWith("B")) {
            if (o != null) {
                Einzelbeleg einzelbeleg = (Einzelbeleg)o;
                jsonObject = einzelbeleg.getJSON();
            } else {
                jsonObject.put("error", "Einzelbeleg" + errorSuffix);
                jsonObject.put("id", id);
            }
        } else if (id.startsWith("P")) {
            if (o != null) {
                Person person = (Person)o;
                jsonObject = person.getJSON();
            } else {
                jsonObject.put("error", "Person" + errorSuffix);
                jsonObject.put("id", id);
            }
        } else if (id.startsWith("Q")) {
            if (o != null) {
                Quelle quelle = (Quelle)o;
                jsonObject = quelle.getJSON();
            } else {
                jsonObject.put("error", "Quelle" + errorSuffix);
                jsonObject.put("id", id);
            }
        }
        return jsonObject;
    }

    private JSONObject getJsonForLemma(String belegform) throws Exception {
        JSONObject jsonObject = new JSONObject();
        List<MghLemma> lemmas = LemmaDB.getLemmaByBelegform(belegform);

        if (lemmas.isEmpty()) {
            jsonObject.put("error", "Lemma not found for Belegform: " + belegform);
        } else if (lemmas.size() == 1) {
            MghLemma lemma = lemmas.get(0);
            jsonObject.put("ID", "M" + lemma.getId());
            jsonObject.put("Lemma", lemma.getMghLemma());
        } else {
            JSONArray lemmaArray = new JSONArray();
            for (MghLemma lemma : lemmas) {
                JSONObject lemmaObj = new JSONObject();
                lemmaObj.put("ID", "M" + lemma.getId());
                lemmaObj.put("Lemma", lemma.getMghLemma());
                lemmaArray.put(lemmaObj);
            }
            jsonObject.put("error", "More than one Lemma found for Belegform: " + belegform);
            jsonObject.put("results", lemmaArray);
        }

        return jsonObject;
    }

    private void processSingleLemma(String belegform, HttpServletResponse response) throws Exception {
        JSONObject jsonObject;
        try {
            jsonObject = getJsonForLemma(belegform);

            if (jsonObject.has("error")) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, jsonObject.getString("error"));
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().println(jsonObject.toString(2));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error: " + e.getMessage());
        }
    }

    private void processMultipleLemmas(String[] belegformen, HttpServletResponse response) throws Exception {
        try {
            JSONArray jsonArray = new JSONArray();
            for (String b : belegformen) {
                if (b != null) {
                    jsonArray.put(getJsonForLemma(b));
                }
            }
            JSONObject finalJson = new JSONObject();
            //immer als array zurückgeben
            finalJson.put("items", jsonArray);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().println(finalJson.toString(2));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error: " + e.getMessage());
        }
    }
}
