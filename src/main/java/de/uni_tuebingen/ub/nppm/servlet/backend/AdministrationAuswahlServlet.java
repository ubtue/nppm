package de.uni_tuebingen.ub.nppm.servlet.backend;

import de.uni_tuebingen.ub.nppm.db.AbstractBase;
import de.uni_tuebingen.ub.nppm.db.DatenbankDB;
import de.uni_tuebingen.ub.nppm.db.EinzelbelegDB;
import de.uni_tuebingen.ub.nppm.db.SelektionDB;
import de.uni_tuebingen.ub.nppm.model.Einzelbeleg;
import de.uni_tuebingen.ub.nppm.model.EinzelbelegHatFunktion_MM;
import de.uni_tuebingen.ub.nppm.model.SelektionFunktion;
import de.uni_tuebingen.ub.nppm.util.Language;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.resource.transaction.spi.TransactionStatus;

public class AdministrationAuswahlServlet extends AbstractBackendServlet {

    String editMessage = "";
    String moveMessage = "";
    String funktionSelektionBezeichnung = "";

    @Override
    protected String getTitle() {
        return "administration";
    }

    @Override
    protected boolean isAdminRequired() {
        return true;
    }

    @Override
    protected List<String> getAdditionalCss() {
        List<String> additionalCss = new ArrayList<>();
        additionalCss.add("webjars/jstree/3.3.16/themes/default/style.min.css");
        return additionalCss;
    }

    @Override
    protected List<String> getAdditionalJavaScript() {
        List<String> additionalJs = new ArrayList<>();
        additionalJs.add("webjars/jstree/3.3.16/jstree.min.js");
        return additionalJs;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "navigation", "Neu"))) {
            newFunction(request);
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Umbenennen"))) {
            renameFunction(request);
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Verschieben"))) {
            moveFunction(request);
        } else if (request.getParameter("action") != null && request.getParameter("action").equals(Language.getTextfield(session, "admin", "Aufteilen"))) {
            divideFunction(request, response);
        }
        // Weiterleiten an die JSP
        if (request.getParameter("Formular") != null && request.getParameter("Formular").equals("showProvenance")) {
            RequestDispatcher rd = request.getRequestDispatcher("admin.auswahlfelder.provenance.jsp");
            rd.include(request, response);
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("admin.auswahlfelder.jsp");
            rd.include(request, response);
        }

    }

    private void newFunction(HttpServletRequest request) throws Exception {
        if (request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung").equals("")) {
            editMessage = "blankLabel";
        } else {
            if (SelektionDB.hasBezeichnung(request.getParameter("Tabelle"), request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung"))) {
                editMessage = "alreadyExists";

            } else {
                SelektionDB.insertBezeichnung(request.getParameter("Tabelle"), request.getParameter(request.getParameter("Tabelle") + "_Bezeichnung"));
                Integer maxId = DatenbankDB.getMaxId(request.getParameter("Tabelle"));
                if (maxId != null) {
                    editMessage = "success";
                }
            }
        }
        request.setAttribute("editMessage", editMessage);
    }

    private void renameFunction(HttpServletRequest request) throws Exception {
        String tableName = request.getParameter("Tabelle");
        String newName = request.getParameter(tableName + "_Bezeichnung");
        String oldName = request.getParameter("selectedBezeichnung");

        if (newName == null || newName.trim().isEmpty()) {
            editMessage = "blankLabel";
        } else if ("-".equals(oldName)) {
            editMessage = "cannotRenameDash";
        } else {
            List<Object> result = SelektionDB.getBezeichnung(tableName, newName);
            if (!result.isEmpty() && result.get(0).toString().equals(newName)) {
                editMessage = "alreadyExists";
            } else {
                SelektionDB.updateBezeichnung(tableName, newName, request.getParameter(tableName));
                editMessage = "success";
            }
        }

        request.setAttribute("editMessage", editMessage);
        request.setAttribute("oldName", oldName != null ? oldName : "");
    }

    private void moveFunction(HttpServletRequest request) throws Exception {

        if (request.getParameter("Feld_neu").equals(request.getParameter("Feld_alt"))) {
            moveMessage = "sameSelection";
        } else if ("-".equals(SelektionDB.getBezeichnungByID(request.getParameter("Feld_alt"), request.getParameter("Tabelle")))) {
            moveMessage = "cannotMoveDash";
        } else {
            String fieldOld = SelektionDB.getBezeichnungByID(request.getParameter("Feld_alt"), request.getParameter("Tabelle"));
            String fieldNew = SelektionDB.getBezeichnungByID(request.getParameter("Feld_neu"), request.getParameter("Tabelle"));
            request.setAttribute("fieldOld", fieldOld != null ? fieldOld : "");
            request.setAttribute("fieldNew", fieldNew != null ? fieldNew : "");

            DatenbankDB.updateAuswahlfelder(request.getParameter("Tabelle"), request.getParameter("Feld_alt"), request.getParameter("Feld_neu"));
            DatenbankDB.deleteAuswahlfeld(request.getParameter("Tabelle"), request.getParameter("Feld_alt"));
            moveMessage = "success";
        }
        request.setAttribute("moveMessage", moveMessage);
    }

    private void divideFunction(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Session session = null;
        Transaction transaction = null;
        try {

            String selectionTag = SelektionDB.getBezeichnungByID(request.getParameter("Feld_selektionFunktion"), request.getParameter("Tabelle"));
            if ("-".equals(selectionTag)) {
                funktionSelektionBezeichnung = "cannotDivideDash";
                request.setAttribute("funktionSelektionBezeichnung", funktionSelektionBezeichnung);
            } else {

                // Holen der ID und Bezeichnung von selektion_funktion
                String funktionIdStr = request.getParameter("Feld_selektionFunktion");

                int funktionId = Integer.parseInt(funktionIdStr);
                SelektionFunktion f_temp = SelektionDB.getById(funktionId, SelektionFunktion.class);
                funktionSelektionBezeichnung = f_temp.getBezeichnung();

                boolean sameFunktion = false;
                String StringfunktionId = "";
                String einzelbelegId = "";

                // Verarbeitung der dynamischen Felder
                List<Integer> splitIds = new ArrayList<>();
                Map<String, String[]> parameterMap = request.getParameterMap();

                //   int aufteilen_1Id = 0;  //Erstes Aufteilen feld, dies soll nun in einzelbeleg_hatfunktion die FunktionID ersetzen
                for (String key : parameterMap.keySet()) {
                    if (key.startsWith("Split[")) {
                        String[] values = request.getParameterValues(key);
                        if (values != null && values.length > 0) {
                            int id = Integer.parseInt(values[0]); // Annahme: Ein Wert pro Parameter

                            // Extrahiere den Index aus dem Schlüssel
                            String indexString = key.substring("Split[".length(), key.length() - 1);
                            int index = Integer.parseInt(indexString);

                            if (index >= 0) {
                                // -1 ist - in selektion_funktion und soll nicht in die Liste aufgenommen werden
                                if (id != -1) {
                                    splitIds.add(id);
                                }

                                if (id == funktionId) {
                                    sameFunktion = true;
                                    break;
                                }
                            }
                        }
                    }
                }

                //Feld 1 Aufteilen Lade die SelektionFunktion, die die neue ID repräsentiert (ersetzen)
                if (splitIds.isEmpty()) {
                    request.setAttribute("funktionSelektionBezeichnung", "noDivideSelektionFunktion");
                } else {

                    SelektionFunktion neueFunktion = SelektionDB.getById(splitIds.get(0), SelektionFunktion.class);

                    if (sameFunktion) {
                        request.setAttribute("funktionSelektionBezeichnung", "sameSelektionFunktion");
                    } else {
                        //Liste von EinzelbelgHatFunktionen die aus der ausgangs selektion_funktion beinhlaten FunktionIDs hat
                        List<EinzelbelegHatFunktion_MM> einzelbelgFunktionList = EinzelbelegDB.getListEinzelbelegHatFunktion(funktionId);

                        session = AbstractBase.getSession();
                        transaction = session.beginTransaction();

                        for (EinzelbelegHatFunktion_MM ef : einzelbelgFunktionList) {

                            ef.setFunktion(neueFunktion); // hier wird die neue funktion ersetzt, also FunktionID in der tabelle geändert
                            session.update(ef);
                        }
                        transaction.commit();

                        // Ab Feld 2 wird ein Insert in einzelbeleg_hatfunktion durchgeführt
                        if (splitIds.size() >= 1) {
                            splitIds.remove(0);  //wurde bereits verarbeitet als update, nun aus der liste löschen
                            session = AbstractBase.getSession();
                            transaction = session.beginTransaction();

                            for (EinzelbelegHatFunktion_MM ef : einzelbelgFunktionList) {

                                Einzelbeleg eb = ef.getEinzelbeleg();

                                einzelbelegId = String.valueOf(eb.getId()); // EinzelbelegID aus der List

                                for (int funktionIdToInsert : splitIds) {

                                    // Umwandeln der Integer ID in String für die Methode insertFunktion
                                    StringfunktionId = String.valueOf(funktionIdToInsert);
                                    // Einfügen in die Datenbank
                                    EinzelbelegDB.insertFunktion(einzelbelegId, StringfunktionId);
                                }
                            }
                            transaction.commit();
                        }

                        List<String> values = new ArrayList<>();
                        Map<String, String[]> parameterMap2 = request.getParameterMap();

                        for (String key : parameterMap2.keySet()) {
                            if (key.startsWith("Split[")) { // Alle Split[n]-Felder erfassen
                                String[] val = request.getParameterValues(key);

                                if (val != null) {
                                    values.addAll(Arrays.asList(val));
                                }
                            }
                        }

                        String[] myarray = values.toArray(new String[0]);
                        request.setAttribute("myarray", myarray);

                        //Lösche die Bezeichnung die aufgeteilt wurde aus der tabelle selektion_funktion
                        EinzelbelegDB.remove(SelektionFunktion.class, funktionId);
                        request.setAttribute("funktionSelektionBezeichnung", "success");
                        request.setAttribute("selectionTag", selectionTag);

                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Fehlerprotokollierung
            if (transaction != null && transaction.getStatus() != TransactionStatus.COMMITTED) {
                transaction.rollback(); // Rollback nur wenn nicht bereits committet
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}
