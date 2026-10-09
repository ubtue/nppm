package de.uni_tuebingen.ub.nppm.servlet;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.Benutzer;
import de.uni_tuebingen.ub.nppm.model.Einzelbeleg;
import de.uni_tuebingen.ub.nppm.model.MghLemma;
import de.uni_tuebingen.ub.nppm.model.NamenKommentar;
import de.uni_tuebingen.ub.nppm.util.AuthHelper;
import de.uni_tuebingen.ub.nppm.util.Language;
import de.uni_tuebingen.ub.nppm.util.LemmaKorrBelegRow;
import org.json.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AjaxServlet extends HttpServlet {

    protected void autocomplete(HttpServletRequest request, HttpServletResponse response) {
        try {
            String query = request.getParameter("query");
            String form = request.getParameter("form");
            String field = request.getParameter("field");
            boolean includeUnpublished = request.getParameter("backend") != null;

            if (query == null || form == null || field == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                response.setContentType("application/json; charset=UTF-8");

                JSONObject jsonObject = new JSONObject();
                JSONArray jsonArray = new JSONArray();
                List<String> matches = SucheDB.getAutocompleteText(field, form, query, includeUnpublished);
                for (String match : matches) {
                    jsonArray.put(match);
                }
                jsonObject.put("suggestions", jsonArray);
                response.getWriter().print(jsonObject.toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void detectZusatzNamenKommentar(HttpServletRequest request, HttpServletResponse response) {
        try {
            String EinzelbelegID = request.getParameter("EinzelbelegID");
            if (EinzelbelegID == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                ArrayList<String> outputList = new ArrayList<>();
                Einzelbeleg lastEinzelbeleg = EinzelbelegDB.getById(Integer.parseInt(EinzelbelegID));
                String belegform = lastEinzelbeleg.getBelegform();

                List<Einzelbeleg> einzelbelege = EinzelbelegDB.getListByBelegform(belegform);

                Map<Integer, List<Integer>> namenkommentarIdToEinzelbelegIdsMap = new HashMap<>();
                Map<Integer, String> namenkommentarIdToPlemmaMap = new HashMap<>();

                for (Einzelbeleg eb : einzelbelege) {
                    int einzelbelegId = eb.getId();

                    for (NamenKommentar namenKommentar : eb.getNamenKommentar()) {
                        if (namenKommentar != null) {
                            int namenkommentarID = namenKommentar.getId();
                            String plemma = namenKommentar.getpLemma();

                            if (!namenkommentarIdToEinzelbelegIdsMap.containsKey(namenkommentarID)) {
                                namenkommentarIdToEinzelbelegIdsMap.put(namenkommentarID, new ArrayList<>());
                            }
                            namenkommentarIdToEinzelbelegIdsMap.get(namenkommentarID).add(einzelbelegId);

                            if (!namenkommentarIdToPlemmaMap.containsKey(namenkommentarID)) {
                                namenkommentarIdToPlemmaMap.put(namenkommentarID, plemma);
                            }
                        }
                    }
                }

                if (!namenkommentarIdToEinzelbelegIdsMap.isEmpty()) {
                    String language = Language.getLanguage(request);
                    StringBuilder sb = new StringBuilder();
                    int save_namenkommentarID = -1;

                    for (Map.Entry<Integer, List<Integer>> entry : namenkommentarIdToEinzelbelegIdsMap.entrySet()) {
                        int namenkommentarID = entry.getKey();
                        List<Integer> einzelbelegIDs = entry.getValue();
                        String plemma = namenkommentarIdToPlemmaMap.get(namenkommentarID);

                        String einzelbelegIDsString = einzelbelegIDs.toString();

                        String s = DatenbankDB.getLabel(language, "einzelbeleg", "foundZusatznamenkommentar");

                        String result = String.format(s, belegform, plemma, String.valueOf(namenkommentarID), einzelbelegIDsString);

                        sb.append(result).append("\n\n");

                        if (namenkommentarIdToEinzelbelegIdsMap.size() == 1) {
                            save_namenkommentarID = namenkommentarID;
                        }
                    }

                    if (namenkommentarIdToEinzelbelegIdsMap.size() == 1) {
                        sb.append(DatenbankDB.getLabel(language, "einzelbeleg", "replaceZusatznamenkommentar"));
                    } else {
                        sb.append(DatenbankDB.getLabel(language, "einzelbeleg", "cleanData"));
                    }

                    outputList.add(sb.toString());

                    response.setContentType("application/json; charset=UTF-8");

                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("EinzelbelegID", EinzelbelegID);
                    jsonObject.put("outputListZ", outputList);

                    if (save_namenkommentarID != -1) {
                        jsonObject.put("namenkommentarID", save_namenkommentarID);
                    }

                    response.getWriter().print(jsonObject.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void confirmZusatzNamenKommentar(HttpServletRequest request, HttpServletResponse response) {
        try {
            String EinzelbelegID = request.getParameter("EinzelbelegID");
            String namenkommentarID = request.getParameter("namenkommentarID");

            if (EinzelbelegID == null || namenkommentarID == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                // Logik zum Speichern des Zusatznamen-Kommentars
                EinzelbelegDB.insertNamenkommentar(EinzelbelegID, namenkommentarID);

                response.setContentType("application/json; charset=UTF-8");
                JSONObject jsonObject = new JSONObject();
                response.getWriter().print(jsonObject.toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void detectLemma(HttpServletRequest request, HttpServletResponse response) {
        try {
            String EinzelbelegID = request.getParameter("EinzelbelegID");
            if (EinzelbelegID == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                ArrayList<String> outputList = new ArrayList<>();
                Einzelbeleg lastEinzelbeleg = EinzelbelegDB.getById(Integer.parseInt(EinzelbelegID));
                String belegform = lastEinzelbeleg.getBelegform();

                List<Einzelbeleg> einzelbelege = EinzelbelegDB.getListByBelegform(belegform);

                Map<Integer, List<Integer>> lemmaIdToEinzelbelegIdsMap = new HashMap<>();
                Map<Integer, String> lemmaIdToLemmaMap = new HashMap<>();

                for (Einzelbeleg eb : einzelbelege) {
                    int einzelbelegId = eb.getId();

                    // 5. Überprüfe, ob Einträge gefunden wurden
                    for (MghLemma lemmakommentar : eb.getMghLemma()) {
                        if (lemmakommentar != null) {
                            int lemmaID = lemmakommentar.getId();
                            String plemma = lemmakommentar.getMghLemma();

                            // Füge EinzelbelegID zur entsprechenden Liste in der Map hinzu
                            if (!lemmaIdToEinzelbelegIdsMap.containsKey(lemmaID)) {
                                lemmaIdToEinzelbelegIdsMap.put(lemmaID, new ArrayList<>());
                            }
                            lemmaIdToEinzelbelegIdsMap.get(lemmaID).add(einzelbelegId);

                            // Speichere die plemma-Strings in der Map
                            if (!lemmaIdToLemmaMap.containsKey(lemmaID)) {
                                lemmaIdToLemmaMap.put(lemmaID, plemma);
                            }
                        }
                    }

                }

                if (!lemmaIdToEinzelbelegIdsMap.isEmpty()) {
                    String language = Language.getLanguage(request);
                    StringBuilder sb = new StringBuilder();
                    int save_lemmaID = -1;

                    for (Map.Entry<Integer, List<Integer>> entry : lemmaIdToEinzelbelegIdsMap.entrySet()) {
                        int lemmaID = entry.getKey();
                        List<Integer> einzelbelegIDs = entry.getValue();
                        String lemma = lemmaIdToLemmaMap.get(lemmaID);

                        String einzelbelegIDsString = einzelbelegIDs.toString();

                        String s = DatenbankDB.getLabel(language, "einzelbeleg", "foundLemma");

                        String result = String.format(s, belegform, lemma, String.valueOf(lemmaID), einzelbelegIDsString);

                        sb.append(result).append("\n\n");

                        if (lemmaIdToEinzelbelegIdsMap.size() == 1) {
                            save_lemmaID = lemmaID;
                        }
                    }

                    if (lemmaIdToEinzelbelegIdsMap.size() == 1) {
                        sb.append(DatenbankDB.getLabel(language, "einzelbeleg", "replaceLemma"));
                    } else {
                        sb.append(DatenbankDB.getLabel(language, "einzelbeleg", "cleanData"));
                    }

                    outputList.add(sb.toString());

                    response.setContentType("application/json; charset=UTF-8");

                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("EinzelbelegID", EinzelbelegID);
                    jsonObject.put("outputListL", outputList);

                    if (save_lemmaID != -1) {
                        jsonObject.put("lemmaID", save_lemmaID);
                    }

                    response.getWriter().print(jsonObject.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void confirmLemma(HttpServletRequest request, HttpServletResponse response) {
        try {
            String EinzelbelegID = request.getParameter("EinzelbelegID");
            String lemmaID = request.getParameter("lemmaID");

            if (EinzelbelegID == null || lemmaID == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                // Logik zum Speichern des Zusatznamen-Kommentars
                // EinzelbelegDB.insertFunktion(EinzelbelegID, lemmaID);
                EinzelbelegDB.insertLemma(EinzelbelegID, lemmaID);

                response.setContentType("application/json; charset=UTF-8");
                JSONObject jsonObject = new JSONObject();
                response.getWriter().print(jsonObject.toString());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void newParentNode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // This method is called via AJAX to change the parent ID.
            Integer id = Integer.parseInt(request.getParameter("id")); // Hier die ID des verschobenen Nodes
            String table = request.getParameter("Tabelle");
            Integer parentId = null;
            String temp = request.getParameter("parentId");
            if (temp != null && !temp.isEmpty()) {
                parentId = Integer.parseInt(temp); // Hier die neue Parent-ID
            }
            SelektionDB.updateParentId(table, id, parentId);

        } catch (Exception ex) {
            Logger.getLogger(AjaxServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred while processing your request.");
        }

    }

    private void doduplicate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession(true);

            Benutzer benutzer = AuthHelper.getBenutzer(request);

            String benutzerGruppe = String.valueOf(benutzer.getGruppe().getID());

            String benutzerId = String.valueOf(benutzer.getID());


            int id = -1;
            if (request.getParameter("duplicate") != null && request.getParameter("duplicate").equals(Language.getTextfield(session, "navigation", "Duplizieren"))) {
                id = Integer.parseInt(request.getParameter("id"));

                String sql = "INSERT INTO einzelbeleg (";
                sql += "Belegnummer, Kontext_vor, Kontext, Kontext_nach, GeschlechtID, LebendVerstorbenID, EditionID, HandschriftID, ";
                sql += "QuelleID, EditionKapitel, EditionSeite, QuelleEchtheitID, QuelleDatierung, ";
                sql += "UeberlieferungDatierung, Belegform, Griechisch, Diakritisch, KasusID, GrammatikGeschlechtID, ASWQuellenzitat, ";
                sql += "Bemerkung, BearbeitungsstatusID, KommentarEthnie, KommentarAreal, KommentarVerwandtschaft, Eindeutig, ";
                sql += "VonTag, VonMonat, VonJahr, VonJahrhundert, BisTag, BisMonat, BisJahr, BisJahrhundert, GenauigkeitVonTag, ";
                sql += "GenauigkeitVonMonat, GenauigkeitVonJahr, GenauigkeitVonJahrhundert, DatierungUngewiss, KommentarDatierung, ";
                sql += "LetzteAenderung, LetzteAenderungVon, Erstellt, ErstelltVon, GehoertGruppe, GenauigkeitBisTag, GenauigkeitBisMonat, ";
                sql += "GenauigkeitBisJahr, GenauigkeitBisJahrhundert, GenauigkeitQuelleBisTag, GenauigkeitQuelleBisMonat, ";
                sql += "GenauigkeitQuelleBisJahr, GenauigkeitQuelleBisJahrhundert, GenauigkeitQuelleVonTag, GenauigkeitQuelleVonMonat, ";
                sql += "GenauigkeitQuelleVonJahr, GenauigkeitQuelleVonJahrhundert, QuelleBisTag, QuelleBisMonat, QuelleBisJahr, ";
                sql += "QuelleBisJahrhundert, QuelleVonTag, QuelleVonMonat, QuelleVonJahr, QuelleVonJahrhundert, KommentarPerson, ";
                sql += "MGHLemmaKorrigiert, KonventID, BeziehungGemeinschaftID, KritikID, KontextID, TitelText, pal_abgrenzung, ";
                sql += "inh_abgrenzung, nr_in_strukt, seite, raster, schreiber) ";
                sql += "SELECT ";
                sql += "Belegnummer, Kontext_vor, Kontext, Kontext_nach, GeschlechtID, LebendVerstorbenID, EditionID, HandschriftID, ";
                sql += "QuelleID, EditionKapitel, EditionSeite, QuelleEchtheitID, QuelleDatierung, ";
                sql += "UeberlieferungDatierung, Belegform, Griechisch, Diakritisch, KasusID, GrammatikGeschlechtID, ASWQuellenzitat, ";
                sql += "Bemerkung, BearbeitungsstatusID, KommentarEthnie, KommentarAreal, KommentarVerwandtschaft, Eindeutig, ";
                sql += "VonTag, VonMonat, VonJahr, VonJahrhundert, BisTag, BisMonat, BisJahr, BisJahrhundert, GenauigkeitVonTag, ";
                sql += "GenauigkeitVonMonat, GenauigkeitVonJahr, GenauigkeitVonJahrhundert, DatierungUngewiss, KommentarDatierung, ";
                sql += "NOW()," + benutzerId + ", NOW()," + benutzerId + "," + benutzerGruppe + ", GenauigkeitBisTag, GenauigkeitBisMonat, ";
                sql += "GenauigkeitBisJahr, GenauigkeitBisJahrhundert, GenauigkeitQuelleBisTag, GenauigkeitQuelleBisMonat, ";
                sql += "GenauigkeitQuelleBisJahr, GenauigkeitQuelleBisJahrhundert, GenauigkeitQuelleVonTag, GenauigkeitQuelleVonMonat, ";
                sql += "GenauigkeitQuelleVonJahr, GenauigkeitQuelleVonJahrhundert, QuelleBisTag, QuelleBisMonat, QuelleBisJahr, ";
                sql += "QuelleBisJahrhundert, QuelleVonTag, QuelleVonMonat, QuelleVonJahr, QuelleVonJahrhundert, KommentarPerson, ";
                sql += "MGHLemmaKorrigiert, KonventID, BeziehungGemeinschaftID, KritikID, KontextID, TitelText, pal_abgrenzung, ";
                sql += "inh_abgrenzung, nr_in_strukt, seite, raster, schreiber ";
                sql += "FROM einzelbeleg WHERE ID=" + id + ";";

                EinzelbelegDB.insertBySql(sql);

                // This is a risky strategy because it is not thread-safe.
                // However, there is no better solution when using direct sql queries right now.
                Integer idNeu = EinzelbelegDB.getIntNative("SELECT ID FROM einzelbeleg ORDER BY ID DESC LIMIT 0, 1;");

                if (idNeu != null) {
                    //Einzelbeleg Textkritik
                    sql = "INSERT INTO einzelbeleg_textkritik";
                    sql += " (EinzelbelegID, EditionID, HandschriftID, Variante, Bemerkung, provenance_source, provenance_id) SELECT '" + idNeu + "', EditionID, HandschriftID, Variante, Bemerkung, provenance_source, provenance_id FROM einzelbeleg_textkritik WHERE EinzelbelegID=" + id + ";";
                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Bemerkunngen
                    sql = "INSERT INTO bemerkung (Bemerkung, EinzelbelegID, GruppeID, BenutzerID)\n" +
                          "SELECT Bemerkung, " + idNeu + ", GruppeID, BenutzerID\n" +
                          "FROM bemerkung\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                     EinzelbelegDB.insertBySql(sql);

                     //Einzelbeleg Angabe zur Person
                    sql = "INSERT INTO einzelbeleg_hatangabe (EinzelbelegID, AngabeID)\n" +
                          "SELECT " + idNeu + ", AngabeID\n" +
                          "FROM einzelbeleg_hatangabe\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Philologischer Kommentar
                    sql = "INSERT INTO einzelbeleg_hatnamenkommentar (EinzelbelegID, NamenkommentarID)\n" +
                          "SELECT " + idNeu + ", NamenkommentarID\n" +
                          "FROM einzelbeleg_hatnamenkommentar\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Lemma
                    sql = "INSERT INTO einzelbeleg_hatmghlemma (EinzelbelegID, MGHLemmaID)\n" +
                          "SELECT " + idNeu + ", MGHLemmaID\n" +
                          "FROM einzelbeleg_hatmghlemma\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg PersonID
                    sql = "INSERT INTO einzelbeleg_hatperson (EinzelbelegID, PersonID, gesichert)\n" +
                          "SELECT " + idNeu + ", PersonID, gesichert\n" +
                          "FROM einzelbeleg_hatperson\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Amt / Weihe
                    sql = "INSERT INTO einzelbeleg_hatamtweihe (EinzelbelegID, AmtWeiheID)\n" +
                          "SELECT " + idNeu + ", AmtWeiheID\n" +
                          "FROM einzelbeleg_hatamtweihe\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Ethnie
                    sql = "INSERT INTO einzelbeleg_hatethnie (EinzelbelegID, EthnieID)\n" +
                          "SELECT " + idNeu + ", EthnieID\n" +
                          "FROM einzelbeleg_hatethnie\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Stand
                    sql = "INSERT INTO einzelbeleg_hatstand (EinzelbelegID, StandID)\n" +
                          "SELECT " + idNeu + ", StandID\n" +
                          "FROM einzelbeleg_hatstand\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Titel Kritik
                     sql = "INSERT INTO einzelbeleg_hattitelkritik (EinzelbelegID, TitelkritikID)\n" +
                          "SELECT " + idNeu + ", TitelkritikID\n" +
                          "FROM einzelbeleg_hattitelkritik\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Funktion Nummer
                    sql = "INSERT INTO einzelbeleg_hatfunktion (EinzelbelegID, FunktionID, Nummer)\n" +
                          "SELECT " + idNeu + ", FunktionID, Nummer\n" +
                          "FROM einzelbeleg_hatfunktion\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);

                    //Einzelbeleg Areal Areal-Typ
                    sql = "INSERT INTO einzelbeleg_hatareal (EinzelbelegID, ArealID, ArealTypID)\n" +
                          "SELECT " + idNeu + ", ArealID, ArealTypID\n" +
                          "FROM einzelbeleg_hatareal\n" +
                          "WHERE EinzelbelegID = " + id + ";";

                    EinzelbelegDB.insertBySql(sql);
                }

            } // ENDE if (springen)
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("confirmLemma".equals(action)) {
            confirmLemma(request, response);
        } else if ("confirmZusatzNamenKommentar".equals(action)) {
            confirmZusatzNamenKommentar(request, response);
        } else if ("newParentNode".equals(action)) {
            newParentNode(request, response);
        } else if ("doduplicate".equals(action)) {
            doduplicate(request, response);
        }
        //Lemmakorr Funktionen
        else if ("Lemmakorr_getAllInitials".equals(action)) {
            Lemmakorr_getAllInitials(response);
        } else if ("Lemmakorr_getFromInitial".equals(action)) {
            Lemmakorr_getFromInitial(request, response);
        } else if ("Lemmakorr_updateLemma".equals(action)) {
            Lemmakorr_updateLemma(request, response);
        } else if ("Lemmakorr_setLemmaKorr".equals(action)) {
            Lemmakorr_setLemmaKorr(request, response);
        } else if ("Lemmakorr_keepAlive".equals(action)) {
            Lemmakorr_keepAlive(response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Falsche Methode\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("autocomplete")) {
                autocomplete(request, response);
            } else if (action.equals("detectZusatzNamenKommentar")) {
                detectZusatzNamenKommentar(request, response);
            } else if (action.equals("detectLemma")) {
                detectLemma(request, response);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_IMPLEMENTED);
            }
            return;
        }

        response.setStatus(HttpServletResponse.SC_NOT_IMPLEMENTED);
    }

    private void Lemmakorr_getAllInitials(HttpServletResponse response) throws IOException {
        try {
            // Holt die echten Initials aus der DB
            Map<String, Integer> initials = EinzelbelegDB.getAllBelegInitials();
            JSONObject result = new JSONObject().put("result", initials);
            writeJson(response, result);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(e.getLocalizedMessage());
        }
    }

    private void Lemmakorr_getFromInitial(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String initial = request.getParameter("initial");
        List<LemmaKorrBelegRow> list = new ArrayList<>();
        try {
            // Nur noch die Datenbank "neg" verwenden
            list.addAll(EinzelbelegDB.getLemmaBelegRowsFromBelegInitial(initial,"neg"));

            // Sortierung
            list.sort((a, b) -> {
                int cmp = a.lemma.compareTo(b.lemma);
                if (cmp != 0) {
                    return cmp;
                }
                cmp = a.beleg.compareToIgnoreCase(b.beleg);
                if (cmp != 0) {
                    return cmp;
                }
                return Boolean.compare(a.korr, b.korr);
            });

            // In JSON umwandeln
            JSONArray arr = new JSONArray();
            for (LemmaKorrBelegRow row : list) {
                arr.put(new JSONObject()
                        .put("lemma", row.lemma)
                        .put("beleg", row.beleg)
                        .put("korr", row.korr)
                        .put("id", row.id)
                        .put("db", row.db)
                );
            }
            JSONObject result = new JSONObject().put("result", arr);
            writeJson(response, result);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(e.getLocalizedMessage());
        }
    }

    private void Lemmakorr_updateLemma(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject result = new JSONObject();
        String lemma = request.getParameter("value");
        String belegIdListStr = request.getParameter("list");
        if (lemma == null || belegIdListStr == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Missing Parameters");
            return;
        }
        List<Integer> belegIdList = new ArrayList<>();
        try {
            JSONArray arr = new JSONArray(belegIdListStr);
            for (int i = 0; i < arr.length(); i++) {
                belegIdList.add(arr.getInt(i));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(e.getLocalizedMessage());
            return;
        }
        // Datenbank-Update
        boolean ok = LemmaDB.updateLemma(belegIdList, lemma);
        result.put("result", ok);
        writeJson(response, result);
    }

    private void Lemmakorr_setLemmaKorr(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject result = new JSONObject();
        String belegIdListStr = request.getParameter("list");
        String korrStr = request.getParameter("value");
        if (belegIdListStr == null || korrStr == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Missing Parameters");
            return;
        }

        List<Integer> belegIdList = new ArrayList<>();
        try {
            JSONArray arr = new JSONArray(belegIdListStr);
            for (int i = 0; i < arr.length(); i++) {
                JSONObject obj = arr.getJSONObject(i);
                if(obj.has("id")) {
                    belegIdList.add(obj.getInt("id"));
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(e.getLocalizedMessage());
            return;
        }

        boolean korr = korrStr.equals("1") || korrStr.equalsIgnoreCase("true");

        boolean ok = LemmaDB.setLemmaKorr(belegIdList, korr);
        result.put("result", ok);
        writeJson(response, result);
    }

    private void Lemmakorr_keepAlive(HttpServletResponse response) throws IOException {
        JSONObject result = new JSONObject().put("result", true);
        writeJson(response, result);
    }

    private void writeJson(HttpServletResponse response, JSONObject obj) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(obj.toString());
        out.flush();
    }

}
