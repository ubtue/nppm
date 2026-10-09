<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page import="java.sql.*" isThreadSafe="false"%>
<%@ page import="java.sql.Date" isThreadSafe="false"%>
<%@ page import="java.sql.Time" isThreadSafe="false"%>

<%@ include file="configuration.jsp"%>
<%@ include file="functions.jsp"%>

<%
    boolean isGast = Utils.isGastEnvironment(request);
    String id = request.getParameter("ID");
    String formular = request.getParameter("Formular");
    String modul = request.getParameter("Modul");

    if (formular.equals("einzelbeleg")) {
        //Gast: Einzelbeleg Katagorie/Bereich Textkritik (Edition, Sigle, Varianten, Datierung d. Textzeugen, Bemerkung)
        if (modul.equals("lesartenRO")) {
%>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
<thead class="ut-table__header ">
    <tr class="ut-table__row">
        <th class="ut-table__item ut-table__header__item" scope="col">
            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Textfeld" value="Edition" />
            </jsp:include>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Textfeld" value="Sigle" />
            </jsp:include>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Textfeld" value="Varianten" />
            </jsp:include>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Textfeld" value="DatierungTextzeuge" />
            </jsp:include>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <jsp:include page="inc.erzeugeBeschriftung.jsp">
                <jsp:param name="Formular" value="einzelbeleg" />
                <jsp:param name="Textfeld" value="Bemerkung" />
            </jsp:include>
        </th>
    </tr>
</thead>
<tbody class="ut-table__body ">
<%
            try {

                List<Object[]> resultList = ModulIncDB.getListEinzelbelegTextkritik(id);

                for (Object[] row : resultList) {

                    out.println("<tr class=\"ut-table__row\">");

                    String zitierweise = row[0] != null ? String.valueOf(row[0]) : "";
                    String sigle = row[1] != null ? String.valueOf(row[1]) : "";
                    String variante = row[2] != null ? String.valueOf(row[2]) : "";

                    String vonTag = row[3] != null ? String.valueOf(row[3]) : "";
                    String vonMonat = row[4] != null ? String.valueOf(row[4]) : "";
                    String vonJahr = row[5] != null ? String.valueOf(row[5]) : "";
                    String vonJhdt = row[6] != null ? String.valueOf(row[6]) : "";

                    String bisTag = row[7] != null ? String.valueOf(row[7]) : "";
                    String bisMonat = row[8] != null ? String.valueOf(row[8]) : "";
                    String bisJahr = row[9] != null ? String.valueOf(row[9]) : "";
                    String bisJhdt = row[10] != null ? String.valueOf(row[10]) : "";

                    String bemerkung = row[11] != null ? String.valueOf(row[11]) : "";

                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + zitierweise + "</td>");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + sigle + "</td>");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + variante + "</td>");

                    String von = "";

                    if (vonTag != null && !vonTag.equals("")
                            && !vonTag.equals("0")) {
                        von = vonTag + ".";
                    }
                    if (vonMonat != null && !vonMonat.equals("")
                            && !vonMonat.equals("0")) {
                        von = von + vonMonat + ".";
                    }
                    if (vonJahr != null && !vonJahr.equals("")
                            && !vonJahr.equals("0")) {
                        von = von + vonJahr;
                    }
                    if (von.equals("") && vonJhdt != null) {
                        von = vonJhdt;
                    }

                    if (!von.equals("") && !von.contains("J") && !von.equals("0")
                            && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                            && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                            && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                        von = von + " Jh.";
                    }

                    String bis = "";

                    if (bisTag != null && !bisTag.equals("")
                            && !bisTag.equals("0")) {
                        bis = bisTag + ".";
                    }
                    if (bisMonat != null && !bisMonat.equals("")
                            && !bisMonat.equals("0")) {
                        bis = bis + bisMonat + ".";
                    }
                    if (bisJahr != null && !bisJahr.equals("")
                            && !bisJahr.equals("0")) {
                        bis = bis + bisJahr;
                    }
                    if (bis.equals("") && bisJhdt != null) {
                        bis = bisJhdt;
                    }

                    if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                            && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                            && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                            && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                        bis = bis + " Jh.";
                    }

                    if (!bis.equals(von) && !bis.equals("")) {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + " - " + bis + "</td>");
                    } else {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + "</td>");
                    }

                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + bemerkung + "</td>");
                    out.println("</tr>");
                }

            } catch (Exception e) {
                out.println(e);
            } finally {

            }
            out.println("</tbody>");
            out.println("</table>\n");
        }
    }

    if (formular.equals("person")) { //Table wid in person.jsp erstellt
        //Backend: Personen, Feld Namen z.b Gudalandaz (zweite Zeile) G?dalandaz
        if (modul.equals("namen")) {
            out.println("<tr><td>\n");

            try {
                // Abfrage der Anzahl der Kommentare
                int count = ModulIncDB.countNamenkommentar(id);
                out.print("<label>");
                if (count > 1) {
                    out.print(Language.getTextfield(session, "modul", "Namen"));
                }else{
                    out.print(Language.getTextfield(session, "modul", "Name"));
                }
                out.println("</label></td><td>");

                // Abfrage der Namenkommentare
                List<Object[]> resultList = ModulIncDB.getListPersonNamenkommentarPlemma(id);

                // Schleife durch die Ergebnisse
                if (resultList != null && !resultList.isEmpty()) {
                    for (Object[] row : resultList) {
                        String plemma = String.valueOf(row[0]);
                        String plemmaID = String.valueOf(row[1]);

                        if (plemma != null && !plemma.isEmpty() && !plemma.equalsIgnoreCase("null")) {
                            if (isGast)
                                out.println("<a href=\"" + Utils.getPidUrl(request, "N" + plemmaID) + "\">" + format(plemma, "PLemma") + "<br>");
                            else
                                out.println("<a href=\"namenkommentar?ID=" + plemmaID + "\">" + format(plemma, "PLemma") + "<br>");
                        }
                    }
                }

                out.println("</td></tr>");
            } catch (Exception e) {
                out.println(e);
            }

            out.println("</ul>\n");
        }

        //Gast: Personen, Katagorie/Bereich: Einzelbeleg (Beleg, Belegform, Datierung, Amt/Weihe, Stand, Kontext)
        if (modul.equals("nachweiseRO")) {
%>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <thead class="ut-table__header ">
        <tr class="ut-table__row">
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="Beleg" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="Belegform" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="Datierung" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="AmtWeihe" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="Stand" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="person" />
                    <jsp:param name="Textfeld" value="Kontext" />
                </jsp:include>
            </th>
        </tr>
    </thead>
    <tbody class="ut-table__body">
<%
    try {

        List<Object[]> resultList = ModulIncDB.getListPersonenEinzelbelege(id);



        for (Object[] row : resultList) {

            out.println("<tr class=\"ut-table__row\">");

            String eId = String.valueOf(row[0]);
            String belegform = row[2] != null ? String.valueOf(row[2]) : "";

            out.println("<td class=\"ut-table__item ut-table__body__item\">");

            if (isGast)
                out.println("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "B" + eId) + "\">");
            else
                out.println("<a class=\"ut-link\" href=\"einzelbeleg?ID=" + eId + "\">");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="person" />
    <jsp:param name="Textfeld" value="BelegLink" />
</jsp:include>
<%
                out.println("</a></td>");
                out.println("<td class=\"ut-table__item ut-table__body__item\">" + getBelegformExternalLinked(eId, belegform) + "</td>");

                String vonTag = row[3] != null ? String.valueOf(row[3]) : "";
                String vonMonat = row[4] != null ? String.valueOf(row[4]) : "";
                String vonJahr = row[5] != null ? String.valueOf(row[5]) : "";
                String vonJhdt = row[6] != null ? String.valueOf(row[6]) : "";
                String bisTag = row[7] != null ? String.valueOf(row[7]) : "";
                String bisMonat = row[8] != null ? String.valueOf(row[8]) : "";
                String bisJahr = row[9] != null ? String.valueOf(row[9]) : "";
                String bisJhdt = row[10] != null ? String.valueOf(row[10]) : "";

                String kontext = row[11] != null ? String.valueOf(row[11]) : "";

                String von = "";

                if (vonTag != null && !vonTag.equals("")
                        && !vonTag.equals("0")) {
                    von = vonTag + ".";
                }
                if (vonMonat != null && !vonMonat.equals("")
                        && !vonMonat.equals("0")) {
                    von = von + vonMonat + ".";
                }
                if (vonJahr != null && !vonJahr.equals("")
                        && !vonJahr.equals("0")) {
                    von = von + vonJahr;
                }
                if (von.equals("") && vonJhdt != null) {
                    von = vonJhdt;
                }

                if (!von.equals("") && !von.contains("J") && !von.equals("0")
                        && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                        && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                        && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                    von = von + " Jh.";
                }

                String bis = "";

                if (bisTag != null && !bisTag.equals("")
                        && !bisTag.equals("0")) {
                    bis = bisTag + ".";
                }
                if (bisMonat != null && !bisMonat.equals("")
                        && !bisMonat.equals("0")) {
                    bis = bis + bisMonat + ".";
                }
                if (bisJahr != null && !bisJahr.equals("")
                        && !bisJahr.equals("0")) {
                    bis = bis + bisJahr;
                }
                if (bis.equals("") && bisJhdt != null) {
                    bis = bisJhdt;
                }

                if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                        && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                        && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                        && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                    bis = bis + " Jh.";
                }

                if (!bis.equals(von) && !bis.equals("")) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + " - " + bis + "</td>");

                } else {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + "</td>");
                }

                List<EinzelbelegHatAmtWeihe_MM> listAmtWeihe = EinzelbelegDB.getListEinzelbelegHatAmtWeihe(Integer.parseInt(eId));

                if (listAmtWeihe == null || listAmtWeihe.isEmpty()) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">-</td>");
                } else {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">");

                    for (EinzelbelegHatAmtWeihe_MM rowAmtWeihe : listAmtWeihe) {

                        String tempAmtWeihe = rowAmtWeihe.getAmtWeihe().getBezeichnung();

                        if (tempAmtWeihe == null || tempAmtWeihe.equals("") || tempAmtWeihe.equalsIgnoreCase("null")) {
                            out.println("-<br>");
                        } else {
                            out.println(tempAmtWeihe + "<br>");
                        }

                    }
                    out.println("</td>");
                }
                out.println("</td>");

                List<EinzelbelegHatStand> listStand = EinzelbelegDB.getListEinzelbelegHatStand(Integer.parseInt(eId));

                if (listStand == null || listStand.isEmpty()) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">-</td>");
                } else {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">");

                    for (EinzelbelegHatStand rowStand : listStand) {

                        String tempStand = rowStand.getSelektionStand().getBezeichnung();

                        if (tempStand == null || tempStand.equals("") || tempStand.equalsIgnoreCase("null")) {
                            out.println("-<br>");
                        } else {
                            out.println(tempStand + "<br>");
                        }
                    }
                    out.println("</td>");
                }

                if (kontext == null || kontext.equals("") || kontext.equalsIgnoreCase("null")) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">-</td>");
                } else {
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + kontext + "</td>");
                }

                out.println("</tr>");

            }//end for

        } catch (Exception e) {
            out.println(e);
        }
        out.println("</tbody>");
        out.println("</table>\n");
    }

    //Gast: Personen Katagorie/Feld Verwandte (Name d. person), Verwandschaftsgrade (z.b Gottfried, Vater)
    if (modul.equals("Verwandte")) {
%>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <thead class="ut-table__header ">
        <tr class="ut-table__row">
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="gast_person" />
                    <jsp:param name="Textfeld" value="PersonName" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="gast_person" />
                    <jsp:param name="Textfeld" value="Verwandtschaftsgrade" />
                </jsp:include>
            </th>
        </tr>
    </thead>
    <tbody class="ut-table__body">
<%
            try {

                List<Object[]> resultList = ModulIncDB.getListPersonenVerwandte(id);

                boolean atLeastOne = false;

                for (Object[] row : resultList) {

                    String pId = row[0] != null ? String.valueOf(row[0]) : "";
                    String standardname = row[1] != null ? String.valueOf(row[1]) : "";
                    String bezeichnung = row[2] != null ? String.valueOf(row[2]) : "";

                    out.println("<tr class=\"ut-table__row\">");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">");
                    if (isGast)
                        out.println("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + pId) + "\">" + Utils.escapeHTML(standardname) + "</a>");
                    else
                        out.println("<a class=\"ut-link\" href=\"person?ID=" + pId + "\">" + Utils.escapeHTML(standardname) + "</a>");
                    out.println("</td>");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + Utils.escapeHTML(bezeichnung) + "</td>");
                    out.println("</tr>");
                    atLeastOne = true;
                }//end for

                if (!atLeastOne) {
                    out.println("<tr class=\"ut-table__row\">");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">-</td>");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">-</td>");
                    out.println("</tr>");
                }

            } catch (Exception e) {
                out.println(e);
            }

            out.println("</tbody>");
            out.println("</table>\n");
        }
    }

    if (formular.equals("edition")) {
        //Backend: Edition, Tab �berlieferung (�berlieferung, Signatur/Bezeichnung, Sigle, Datierung, Schriftheimat) [z.b E125]
        if (modul.equals("ueberlieferung")) {
            out.println("<table>\n");
%>
<tr>
    <th></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Ueberlieferung" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Signatur" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Sigle" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Datierung" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Schriftheimat" />
        </jsp:include></th>
</tr>
<%
    try {

        List<Object[]> resultList = ModulIncDB.getListQuellenbezeichnungen(id);

        for (Object[] row : resultList) {

            String qId = String.valueOf(row[0]);
            String bezeichnung = String.valueOf(row[1]);

            List<Object[]> resultList_2 = ModulIncDB.getListQuellenInformationen(qId, id);

            out.println("<tr><td colspan=6>");
            out.println("Quelle: " + bezeichnung + "</td></tr>");

            for (Object[] row_2 : resultList_2) {

                String handschriftId = String.valueOf(row_2[0]);
                String bibliothekssignatur = row_2[1] != null ? String.valueOf(row_2[1]) : "";
                String sigel = row_2[3] != null ? String.valueOf(row_2[3]) : "";

                String vonTag = row_2[4] != null ? String.valueOf(row_2[4]) : "";
                String vonMonat = row_2[5] != null ? String.valueOf(row_2[5]) : "";
                String vonJahr = row_2[6] != null ? String.valueOf(row_2[6]) : "";
                String vonJhdt = row_2[7] != null ? String.valueOf(row_2[7]) : "";
                String bisTag = row_2[8] != null ? String.valueOf(row_2[8]) : "";
                String bisMonat = row_2[9] != null ? String.valueOf(row_2[9]) : "";
                String bisJahr = row_2[10] != null ? String.valueOf(row_2[10]) : "";
                String bisJhdt = row_2[11] != null ? String.valueOf(row_2[11]) : "";

                String bezeichnungOrt = row_2[12] != null ? String.valueOf(row_2[12]) : "";

                out.println("<tr>");
                out.println("<td>&nbsp;</td><td>");
                if (isGast)
                    out.println("<a href=\"" + Utils.getPidUrl(request, "T" + handschriftId) + "\">");
                else
                    out.println("<a href=\"handschrift?ID=" + handschriftId + "\">");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="quelle" />
    <jsp:param name="Textfeld" value="ZurHandschrift" />
</jsp:include>

<%
                        out.println("</a></td>");

                        out.println("<td>" + bibliothekssignatur + "</td>");

                        out.println("<td>" + sigel + "</td>");

                        String von = "";

                        if (vonTag != null && !vonTag.equals("")
                                && !vonTag.equals("0")) {
                            von = vonTag + ".";
                        }
                        if (vonMonat != null && !vonMonat.equals("")
                                && !vonMonat.equals("0")) {
                            von = von + vonMonat + ".";
                        }
                        if (vonJahr != null && !vonJahr.equals("")
                                && !vonJahr.equals("0")) {
                            von = von + vonJahr;
                        }
                        if (von.equals("") && vonJhdt != null) {
                            von = vonJhdt;
                        }

                        if (!von.equals("") && !von.contains("J") && !von.equals("0")
                                && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                                && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                                && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                            von = von + " Jh.";
                        }

                        String bis = "";

                        if (bisTag != null && !bisTag.equals("")
                                && !bisTag.equals("0")) {
                            bis = bisTag + ".";
                        }
                        if (bisMonat != null && !bisMonat.equals("")
                                && !bisMonat.equals("0")) {
                            bis = bis + bisMonat + ".";
                        }
                        if (bisJahr != null && !bisJahr.equals("")
                                && !bisJahr.equals("0")) {
                            bis = bis + bisJahr;
                        }
                        if (bis.equals("") && bisJhdt != null) {
                            bis = bisJhdt;
                        }

                        if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                                && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                                && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                                && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                            bis = bis + " Jh.";
                        }

                        if (!bis.equals(von) && !bis.equals("")) {
                            out.println("<td>" + von + " - " + bis
                                    + "</td>");
                        } else {
                            out.println("<td>" + von + "</td>");
                        }

                        out.println("<td>" + bezeichnungOrt + "</td>");

                        out.println("</tr>");

                    } //end row_2
                } //end row

            } catch (Exception e) {
                out.println(e);
            }
            out.println("</table>\n");
        }
    }

    //Backend: Quellen --> Tab: Überlieferung (Überlieferung, Signatur/Bezeichnung, Sigle, Datierung, Schriftheimat)
    if (formular.equals("quelle")) {
        if (modul.equals("ueberlieferung")) {
            out.println("<table>\n");
%>
<tr>
    <th></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Ueberlieferung" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Signatur" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Sigle" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Datierung" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle" />
            <jsp:param name="Textfeld" value="Schriftheimat" />
        </jsp:include></th>
</tr>
<%
    try {

        List<Object[]> resultList = ModulIncDB.getListQuelleEditionen(id);

        for (Object[] row : resultList) {

            String edId = String.valueOf(row[0]);
            String bez = String.valueOf(row[1]);

            List<Object[]> resultList_2 = ModulIncDB.getListQuelleSignaturen(edId, id);
            out.println("<tr><td colspan=6>");
%><jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="quelle" />
    <jsp:param name="Textfeld" value="Edition" />
</jsp:include>
<%
    out.println(": " + bez + "</td></tr>");

    for (Object[] row_2 : resultList_2) {

        String handschriftId = String.valueOf(row_2[0]);
        String bibliothekssignatur = row_2[1] != null ? String.valueOf(row_2[1]) : "";
        String sigel = row_2[3] != null ? String.valueOf(row_2[3]) : "";

        String vonTag = row_2[4] != null ? String.valueOf(row_2[4]) : "";
        String vonMonat = row_2[5] != null ? String.valueOf(row_2[5]) : "";
        String vonJahr = row_2[6] != null ? String.valueOf(row_2[6]) : "";
        String vonJhdt = row_2[7] != null ? String.valueOf(row_2[7]) : "";

        String bisTag = row_2[8] != null ? String.valueOf(row_2[8]) : "";
        String bisMonat = row_2[9] != null ? String.valueOf(row_2[9]) : "";
        String bisJahr = row_2[10] != null ? String.valueOf(row_2[10]) : "";
        String bisJhdt = row_2[11] != null ? String.valueOf(row_2[11]) : "";

        String bezeichnung = row_2[12] != null ? String.valueOf(row_2[12]) : "";

        out.println("<tr>");
        out.println("<td>&nbsp;</td><td>");
        if (isGast)
            out.println("<a href=\"" + Utils.getPidUrl(request, "T" + handschriftId) + "\">");
        else
            out.println("<a href=\"handschrift?ID=" + handschriftId + "\">");
%>

<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="quelle" />
    <jsp:param name="Textfeld" value="ZurHandschrift" />
</jsp:include>

<%
                    out.println("</a></td>");
                    out.println("<td>" + bibliothekssignatur + "</td>");
                    out.println("<td>" + sigel + "</td>");

                    String von = "";

                    if (vonTag != null && !vonTag.equals("")
                            && !vonTag.equals("0")) {
                        von = vonTag + ".";
                    }
                    if (vonMonat != null && !vonMonat.equals("")
                            && !vonMonat.equals("0")) {
                        von = von + vonMonat + ".";
                    }
                    if (vonJahr != null && !vonJahr.equals("")
                            && !vonJahr.equals("0")) {
                        von = von + vonJahr;
                    }
                    if (von.equals("") && vonJhdt != null) {
                        von = vonJhdt;
                    }

                    if (!von.equals("") && !von.contains("J") && !von.equals("0")
                            && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                            && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                            && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                        von = von + " Jh.";
                    }

                    String bis = "";

                    if (bisTag != null && !bisTag.equals("")
                            && !bisTag.equals("0")) {
                        bis = bisTag + ".";
                    }
                    if (bisMonat != null && !bisMonat.equals("")
                            && !bisMonat.equals("0")) {
                        bis = bis + bisMonat + ".";
                    }
                    if (bisJahr != null && !bisJahr.equals("")
                            && !bisJahr.equals("0")) {
                        bis = bis + bisJahr;
                    }
                    if (bis.equals("") && bisJhdt != null) {
                        bis = bisJhdt;
                    }

                    if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                            && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                            && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                            && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                        bis = bis + " Jh.";
                    }

                    if (!bis.equals(von) && !bis.equals("")) {
                        out.println("<td>" + von + " - " + bis
                                + "</td>");
                    } else {
                        out.println("<td>" + von + "</td>");
                    }

                    out.println("<td>" + bezeichnung + "</td>");
                    out.println("</tr>");
                }
            }
        } catch (Exception e) {
            out.println(e);
        }
        out.println("</table>\n");
    }

//Gast:  Quellen --> Bereich/Katagorie �berlieferung
    if (modul.equals("ueberlieferungRO")) {
%>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <thead class="ut-table__header ">
        <tr class="ut-table__row">
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Signatur" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Sigle" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Datierung" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Schriftheimat" />
                </jsp:include>
            </th>
        </tr>
    </thead>
    <tbody class="ut-table__body">

<%
    try {

        List<Object[]> resultList = ModulIncDB.getListQuelleEditionen(id);

        for (Object[] row : resultList) {
            String edId = String.valueOf(row[0]);
            String bez = row[1] != null ? String.valueOf(row[1]) : "";

            List<Object[]> resultList_2 = ModulIncDB.getListGastQuelleSignaturen(edId, id);

            out.println("<tr class=\"ut-table__row\"><th class=\"ut-table__item ut-table__header__item\" scope=\"col\" colspan=\"4\"><b>");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="quelle" />
    <jsp:param name="Textfeld" value="Edition" />
</jsp:include>

<%
                out.println(": " + bez + "</b></td></tr>");

                for (Object[] row_2 : resultList_2) {

                    String bibliothekssignatur = row_2[1] != null ? String.valueOf(row_2[1]) : "";
                    String sigel = row_2[3] != null ? String.valueOf(row_2[3]) : "";

                    String vonTag = row_2[10] != null ? String.valueOf(row_2[10]) : "";
                    String vonMonat = row_2[8] != null ? String.valueOf(row_2[8]) : "";
                    String vonJahr = row_2[6] != null ? String.valueOf(row_2[6]) : "";
                    String vonJhdt = row_2[4] != null ? String.valueOf(row_2[4]) : "";

                    String bisTag = row_2[11] != null ? String.valueOf(row_2[11]) : "";
                    String bisMonat = row_2[9] != null ? String.valueOf(row_2[9]) : "";
                    String bisJahr = row_2[7] != null ? String.valueOf(row_2[7]) : "";
                    String bisJhdt = row_2[5] != null ? String.valueOf(row_2[5]) : "";

                    String bezeichnung = row_2[12] != null ? String.valueOf(row_2[12]) : "";

                    out.println("<tr class=\"ut-table__row\">");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + bibliothekssignatur + "</td>");
                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + sigel + "</td>");

                    String von = "";

                    if (vonTag != null && !vonTag.equals("")
                            && !vonTag.equals("0")) {
                        von = vonTag + ".";
                    }
                    if (vonMonat != null && !vonMonat.equals("")
                            && !vonMonat.equals("0")) {
                        von = von + vonMonat + ".";
                    }
                    if (vonJahr != null && !vonJahr.equals("")
                            && !vonJahr.equals("0")) {
                        von = von + vonJahr;
                    }
                    if (von.equals("") && vonJhdt != null) {
                        von = vonJhdt;
                    }

                    if (!von.equals("") && !von.contains("J") && !von.equals("0")
                            && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                            && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                            && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                        von = von + " Jh.";
                    }

                    String bis = "";

                    if (bisTag != null && !bisTag.equals("")
                            && !bisTag.equals("0")) {
                        bis = bisTag + ".";
                    }
                    if (bisMonat != null && !bisMonat.equals("")
                            && !bisMonat.equals("0")) {
                        bis = bis + bisMonat + ".";
                    }
                    if (bisJahr != null && !bisJahr.equals("")
                            && !bisJahr.equals("0")) {
                        bis = bis + bisJahr;
                    }
                    if (bis.equals("") && bisJhdt != null) {
                        bis = bisJhdt;
                    }

                    if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                            && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                            && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                            && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                        bis = bis + " Jh.";
                    }

                    if (!bis.equals(von) && !bis.equals("")) {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + " - " + bis
                                + "</td>");
                    } else {
                        out.println("<td class=\"ut-table__item ut-table__body__item\">" + von + "</td>");
                    }

                    out.println("<td class=\"ut-table__item ut-table__body__item\">" + bezeichnung + "</td>");

                    out.println("</tr>");
                }
            }
        } catch (Exception e) {
            out.println(e);
        }
        out.println("</tbody>");
        out.println("</table>\n");
    }

    //Gast:  Quellen --> Bereich/Katagorie Standard Edition &n Weitere Editionen (Qeullen, Reihe, Bd., Ort, Jahr, Seiten, Herausgeber)
    if (modul.equals("edition")) {

%>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <thead class="ut-table__header ">
        <tr class="ut-table__row">
            <th class="ut-table__item ut-table__header__item" scope="col">&nbsp;</th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Titel" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Reihe" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">Bd.</th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Ort" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Jahr" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Seiten" />
                </jsp:include>
            </th>
            <th class="ut-table__item ut-table__header__item" scope="col">Nummer</th>
            <th class="ut-table__item ut-table__header__item" scope="col">
                <jsp:include page="inc.erzeugeBeschriftung.jsp">
                    <jsp:param name="Formular" value="quelle" />
                    <jsp:param name="Textfeld" value="Herausgeber" />
                </jsp:include>
            </th>
        </tr>
    </thead>
    <tbody class="ut-table__body ">
        <tr class="ut-table__row">
            <td class="ut-table__item ut-table__body__item">
                <strong>
                    <jsp:include page="inc.erzeugeBeschriftung.jsp">
                        <jsp:param name="Formular" value="quelle" />
                        <jsp:param name="Textfeld" value="StandardEdition" />
                    </jsp:include>
                </strong>
            </td>

<%    boolean firstEdition = true;
    boolean showNummer = false;

    try {

        List<Object[]> resultList = ModulIncDB.getListGastQuelleEditionen("1", id);

        for (Object[] row : resultList) {

            if (!firstEdition) {

                out.println("<tr class=\"ut-table__row\">");
                out.println("<td class=\"ut-table__item ut-table__body__item\"></td>");  //to have empty space below the standard edition
            }

            firstEdition = false;

            String eId = row[0] != null ? String.valueOf(row[0]) : "-1";
            String titel = row[1] != null ? String.valueOf(row[1]) : "";
            String reihe = row[2] != null ? String.valueOf(row[2]) : "--";
            String band = row[3] != null ? String.valueOf(row[3]) : "--";
            String ort = row[4] != null ? String.valueOf(row[4]) : "--";
            String jahr = row[5] != null ? String.valueOf(row[5]) : "--";
            String qiSeiten = row[6] != null ? String.valueOf(row[6]) : row[7] != null ? String.valueOf(row[7]) : "--";
            String nummer = (row[8] != null && !String.valueOf(row[8]).trim().equals("")) ? String.valueOf(row[8]) : "--";

            out.println("<td class=\"ut-table__item ut-table__body__item\">" + titel + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(reihe) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(band) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(ort) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(jahr) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(qiSeiten) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(nummer) + "</td>");

            if (nummer != null && !nummer.trim().equals("")) {
                showNummer = true;
            }

            out.println("<td class=\"ut-table__item ut-table__body__item\">");

            List<String> resultList_2 = ModulIncDB.getListGastQuelleEditionHerausgeber(eId);
            boolean first = true;

            for (String row_2 : resultList_2) {

                String bezeichnung = row_2 != null ? row_2 : "";

                if (!first) {
                    out.print(" / ");
                }
                out.print(bezeichnung);
                first = false;
            } //end for 2
            out.println("</td>");
            out.println("</tr>");
        } //end for 1

        if (firstEdition) {
            out.println("<td class=\"ut-table__item ut-table__body__item\" colspan=\"8\"></td></tr>");
        }

        out.println("<tr class=\"ut-table__row\">");
%>
<td  class="ut-table__item ut-table__body__item">
    <jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="gast_quelle" />
        <jsp:param name="Datenfeld" value="WeitereEditionen" />
    </jsp:include>
</td>

<%
        firstEdition = true;

        List<Object[]> resultList_3 = ModulIncDB.getListGastQuelleEditionen("0", id);

        for (Object[] row_3 : resultList_3) {

            if (!firstEdition) {
                out.println("<tr class=\"ut-table__row\">");
                out.println("<td class=\"ut-table__item ut-table__body__item\"></td>");
            }
            firstEdition = false;

            String eId = row_3[0] != null ? String.valueOf(row_3[0]) : "-1";
            String titel = row_3[1] != null ? String.valueOf(row_3[1]) : "";
            String reihe = row_3[2] != null ? String.valueOf(row_3[2]) : "--";
            String band = row_3[3] != null ? String.valueOf(row_3[3]) : "--";
            String ort = row_3[4] != null ? String.valueOf(row_3[4]) : "--";
            String jahr = row_3[5] != null ? String.valueOf(row_3[5]) : "--";
            String qiSeiten = row_3[6] != null ? String.valueOf(row_3[6]) : row_3[7] != null ? String.valueOf(row_3[7]) : "--";
            String nummer = (row_3[8] != null && !String.valueOf(row_3[8]).trim().equals("")) ? String.valueOf(row_3[8]) : "--";

            out.println("<td class=\"ut-table__item ut-table__body__item\">" + titel + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(reihe) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(band) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(ort) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(jahr) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(qiSeiten) + "</td>");
            out.println("<td class=\"ut-table__item ut-table__body__item\">" + DBtoHTML(nummer) + "</td>");

            if (nummer != null && !nummer.trim().equals("")) {
                showNummer = true;
            }

            out.println("<td class=\"ut-table__item ut-table__body__item\">");

            List<String> resultList_4 = ModulIncDB.getListGastQuelleEditionHerausgeber(eId);

            boolean first = true;

            for (String row_4 : resultList_4) {

                String bezeichnung = row_4 != null ? row_4 : "";

                if (!first) {
                    out.print(" / ");
                }
                out.print(bezeichnung);
                first = false;
            } //end for 4
            out.println("</td>");
            out.println("</tr>");
        } //end for 3

    } catch (Exception e) {
        out.println(e);
    }

    if (firstEdition) {
        out.println("<td class=\"ut-table__item ut-table__body__item\" colspan=\"8\"></td></tr>");
    }

    out.println("</tbody>");
    out.println("</table>\n");
    if (!showNummer) {
%>
<script type="text/javascript">
    var rows = document.getElementById('edition').getElementsByTagName('tr');
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].getElementsByTagName('th')[7])
            rows[i].getElementsByTagName('th')[7].style.display = 'none';
        if (rows[i].getElementsByTagName('td')[7])
            rows[i].getElementsByTagName('td')[7].style.display = 'none';
    }
</script>
<%	}
        }
    }

    //Backend: (mgh)lemma --> Tab Bearbeiter (Bearbeiter, Datum, Uhrzeit
    if (formular.equals("mgh_lemma")) {
        if (modul.equals("bearbeiter") || modul.equals("korrektor")) {
            out.println("<table>\n");
            out.print("<tr><th width=\"200\">");
            if (modul.equals("bearbeiter")) {
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="mgh_lemma" />
    <jsp:param name="Textfeld" value="Bearbeiter" />
</jsp:include>

<%
} else {
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="mgh_lemma" />
    <jsp:param name="Textfeld" value="Korrektor" />
</jsp:include>
<%
    }
%>
</th>
<th width="100"><jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="mgh_lemma" />
        <jsp:param name="Textfeld" value="Datum" />
    </jsp:include></th>

<th width="100"><jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="mgh_lemma" />
        <jsp:param name="Textfeld" value="Uhrzeit" />
    </jsp:include></th>
</tr>
<%
        try {

            List<Object[]> resultList = ModulIncDB.getListLemmaBearbeiterKorrektor(modul, id);

            for (Object[] row : resultList) {

                Date date = null;
                Time time = null;

                String nachname = String.valueOf(row[0]);
                String vorname = String.valueOf(row[1]);
                String zeitstempelString = String.valueOf(row[2]);                           //besser !!!

                Timestamp zeitstempel = Timestamp.valueOf(zeitstempelString);

                // LocalDateTime aus Timestamp holen
                LocalDateTime localDateTime = zeitstempel.toLocalDateTime();

                // Date und Time extrahieren
                date = Date.valueOf(localDateTime.toLocalDate());   // Nur Datum
                time = Time.valueOf(localDateTime.toLocalTime());   // Nur Uhrzeit

                out.println("<tr>");
                out.println("<td>" + DBtoHTML(nachname) + ", " + DBtoHTML(vorname) + "</td>");
                out.println("<td>" + (date == null ? "--" : date) + "</td>");
                out.println("<td>" + (time == null ? "--" : time) + "</td>");
                out.println("</tr>");
            }//end for
        } catch (Exception e) {
            out.println(e);
        }
        out.println("</table>\n");
    } //korrektor

    //Backend: (mgh)lemma --> Tab Belege (Beleg, Belegform, Person, Standardname, Datierung)
    if (modul.equals("belege")) {
        out.println("<table>\n");
%>
<tr>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="mgh_lemma" />
            <jsp:param name="Textfeld" value="Beleg" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="mgh_lemma" />
            <jsp:param name="Textfeld" value="Belegform" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="mgh_lemma" />
            <jsp:param name="Textfeld" value="Person" />
        </jsp:include></th>
    <th></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="mgh_lemma" />
            <jsp:param name="Textfeld" value="Datierung" />
        </jsp:include></th>
</tr>
<%
    try {
        List<Object[]> resultList = ModulIncDB.getListNamenLemmaBelege("mghlemma", id);

        for (Object[] row : resultList) {

            String einzelbelegId = String.valueOf(row[0]);
            String einzelbelegBelegform = row[2] != null ? String.valueOf(row[2]) : "";
            String personId = String.valueOf(row[3]);
            String personPkz = row[4] != null ? String.valueOf(row[4]) : "";
            String standardname = row[5] != null ? String.valueOf(row[5]) : "";

            String vonTag = row[6] != null ? String.valueOf(row[6]) : "";
            String vonMonat = row[7] != null ? String.valueOf(row[7]) : "";
            String vonJahr = row[8] != null ? String.valueOf(row[8]) : "";
            String vonJhdt = row[9] != null ? String.valueOf(row[9]) : "";

            String bisTag = row[10] != null ? String.valueOf(row[10]) : "";
            String bisMonat = row[11] != null ? String.valueOf(row[11]) : "";
            String bisJahr = row[12] != null ? String.valueOf(row[12]) : "";
            String bisJhdt = row[13] != null ? String.valueOf(row[13]) : "";

            out.println("<tr><td>");
            if (isGast)
                out.println("<a href=\"" + Utils.getPidUrl(request, "B" + einzelbelegId) + "\">");
            else
                out.println("<a href=\"einzelbeleg?ID=" + einzelbelegId + "\">");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="mgh_lemma" />
    <jsp:param name="Textfeld" value="ZumBeleg" />
</jsp:include>

<%
    out.println("</a></td>");
    if (einzelbelegBelegform.equals("")) {
        out.println("<td> &nbsp; </td>");
    } else {
        out.println("<td>" + einzelbelegBelegform + "</td>");
    }

    out.println("<td>");

    if (personPkz.equals("")) {
        out.println("--");
    } else {
        if (isGast)
            out.println("<a href=\"" + Utils.getPidUrl(request, "P" + personId) + "\">");
        else
            out.println("<a href=\"person?ID=" + personId + "\">");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="mgh_lemma" />
    <jsp:param name="Textfeld" value="ZurPerson" />
</jsp:include>
<%
                    }

                    out.println("</a></td>");

                    if (standardname.equals("")) {
                        out.println("<td>--</td>");
                    } else {
                        out.println("<td>" + DBtoHTML(standardname) + "</td>");
                    }

                    String von = "";

                    if (vonTag != null && !vonTag.equals("")
                            && !vonTag.equals("0")) {
                        von = vonTag + ".";
                    }
                    if (vonMonat != null && !vonMonat.equals("")
                            && !vonMonat.equals("0")) {
                        von = von + vonMonat + ".";
                    }
                    if (vonJahr != null && !vonJahr.equals("")
                            && !vonJahr.equals("0")) {
                        von = von + vonJahr;
                    }
                    if (von.equals("") && vonJhdt != null) {
                        von = vonJhdt;
                    }

                    if (!von.equals("") && !von.contains("J") && !von.equals("0")
                            && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                            && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                            && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                        von = von + " Jh.";
                    }

                    String bis = "";

                    if (bisTag != null && !bisTag.equals("")
                            && !bisTag.equals("0")) {
                        bis = bisTag + ".";
                    }
                    if (bisMonat != null && !bisMonat.equals("")
                            && !bisMonat.equals("0")) {
                        bis = bis + bisMonat + ".";
                    }
                    if (bisJahr != null && !bisJahr.equals("")
                            && !bisJahr.equals("0")) {
                        bis = bis + bisJahr;
                    }
                    if (bis.equals("") && bisJhdt != null) {
                        bis = bisJhdt;
                    }

                    if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                            && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                            && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                            && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                        bis = bis + " Jh.";
                    }

                    if (!bis.equals(von) && !bis.equals("")) {
                        out.println("<td>" + von + " - " + bis
                                + "</td>");
                    } else {
                        out.println("<td>" + von + "</td>");
                    }

                    out.println("</tr>");
                }
            } catch (Exception e) {
                out.println(e);
            }

            out.println("</table>\n");
        }
    }//mgh-lemma

    if (formular.equals("namenkommentar")) {
        //Backend: Namen bzw. namenkommentar  Tab Bearbeiter (Bearbeiter, Datum Uhrzeit) z.b ( Team, NPPM , 2024-09-16, 9:57:21)
        if (modul.equals("bearbeiter") || modul.equals("korrektor")) {
            out.println("<table>\n");
            out.print("<tr><th width=\"200\">");
            if (modul.equals("bearbeiter")) {
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="namenkommentar" />
    <jsp:param name="Textfeld" value="Bearbeiter" />
</jsp:include>

<%
} else {
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="namenkommentar" />
    <jsp:param name="Textfeld" value="Korrektor" />
</jsp:include>
<%
    }
%>
</th>
<th width="100"><jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="namenkommentar" />
        <jsp:param name="Textfeld" value="Datum" />
    </jsp:include></th>

<th width="100"><jsp:include page="inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="namenkommentar" />
        <jsp:param name="Textfeld" value="Uhrzeit" />
    </jsp:include></th>
</tr>
<%
        try {
            List<Object[]> resultList = ModulIncDB.getListNamenBearbeiterKorrektor(modul, id);

            for (Object[] row : resultList) {

                Date date = null;
                Time time = null;

                String nachname = String.valueOf(row[0]);
                String vorname = String.valueOf(row[1]);
                String zeitstempelString = String.valueOf(row[2]);                           //besser !!!

                Timestamp zeitstempel = Timestamp.valueOf(zeitstempelString);

                // LocalDateTime aus Timestamp holen
                LocalDateTime localDateTime = zeitstempel.toLocalDateTime();

                // Date und Time extrahieren
                date = Date.valueOf(localDateTime.toLocalDate());   // Nur Datum
                time = Time.valueOf(localDateTime.toLocalTime());   // Nur Uhrzeit

                out.println("<tr>");
                out.println("<td>" + DBtoHTML(nachname) + ", " + DBtoHTML(vorname) + "</td>");
                out.println("<td>" + (date == null ? "--" : date) + "</td>");
                out.println("<td>" + (time == null ? "--" : time) + "</td>");
                out.println("</tr>");
            }//end for
        } catch (Exception e) {
            out.println(e);
        }
        out.println("</table>\n");
    }

    //Backend: Namen (bzw. namenkommentar) Tab Belege (Beleg, Belegform, Person, Standardname, Datierung)
    if (modul.equals("belege")) {
        out.println("<table>\n");
%>
<tr>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="namenkommentar" />
            <jsp:param name="Textfeld" value="Beleg" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="namenkommentar" />
            <jsp:param name="Textfeld" value="Belegform" />
        </jsp:include></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="namenkommentar" />
            <jsp:param name="Textfeld" value="Person" />
        </jsp:include></th>
    <th></th>
    <th><jsp:include page="inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="namenkommentar" />
            <jsp:param name="Textfeld" value="Datierung" />
        </jsp:include></th>
</tr>
<%
    List<Object[]> resultList = ModulIncDB.getListNamenLemmaBelege("namenkommentar", id);

    for (Object[] row : resultList) {

        String einzelbelegId = String.valueOf(row[0]);
        String einzelbelegBelegform = row[2] != null ? String.valueOf(row[2]) : "";
        String personId = String.valueOf(row[3]);
        String personPkz = row[4] != null ? String.valueOf(row[4]) : "";
        String standardname = row[5] != null ? String.valueOf(row[5]) : "";

        String vonTag = row[6] != null ? String.valueOf(row[6]) : "";
        String vonMonat = row[7] != null ? String.valueOf(row[7]) : "";
        String vonJahr = row[8] != null ? String.valueOf(row[8]) : "";
        String vonJhdt = row[9] != null ? String.valueOf(row[9]) : "";

        String bisTag = row[10] != null ? String.valueOf(row[10]) : "";
        String bisMonat = row[11] != null ? String.valueOf(row[11]) : "";
        String bisJahr = row[12] != null ? String.valueOf(row[12]) : "";
        String bisJhdt = row[13] != null ? String.valueOf(row[13]) : "";

        out.println("<tr><td>");
        if (isGast)
            out.println("<a href=\"" + Utils.getPidUrl(request, "B" + einzelbelegId) + "\">");
        else
            out.println("<a href=\"einzelbeleg?ID=" + einzelbelegId + "\">");

%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="namenkommentar" />
    <jsp:param name="Textfeld" value="ZumBeleg" />
</jsp:include>

<%    out.println("</a></td>");
    if (einzelbelegBelegform.equals("")) {
        out.println("<td> &nbsp; </td>");
    } else {
        out.println("<td>" + einzelbelegBelegform + "</td>");
    }

    out.println("<td>");

    if (personPkz.equals("")) {
        out.println("--");
    } else {
        if (isGast)
            out.println("<a href=\"" + Utils.getPidUrl(request, "P" + personId) + "\">");
        else
            out.println("<a href=\"person?ID=" + personId + "\">");
%>
<jsp:include page="inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="namenkommentar" />
    <jsp:param name="Textfeld" value="ZurPerson" />
</jsp:include>
<%
                }

                out.println("</a></td>");

                if (standardname.equals("")) {
                    out.println("<td>--</td>");
                } else {
                    out.println("<td>" + DBtoHTML(standardname) + "</td>");
                }

                String von = "";

                if (vonTag != null && !vonTag.equals("")
                        && !vonTag.equals("0")) {
                    von = vonTag + ".";
                }
                if (vonMonat != null && !vonMonat.equals("")
                        && !vonMonat.equals("0")) {
                    von = von + vonMonat + ".";
                }
                if (vonJahr != null && !vonJahr.equals("")
                        && !vonJahr.equals("0")) {
                    von = von + vonJahr;
                }
                if (von.equals("") && vonJhdt != null) {
                    von = vonJhdt;
                }

                if (!von.equals("") && !von.contains("J") && !von.equals("0")
                        && (vonTag == null || vonTag.equals("") || vonTag.equals("0"))
                        && (vonMonat == null || vonMonat.equals("") || vonMonat.equals("0"))
                        && (vonJahr == null || vonJahr.equals("") || vonJahr.equals("0"))) {
                    von = von + " Jh.";
                }

                String bis = "";

                if (bisTag != null && !bisTag.equals("")
                        && !bisTag.equals("0")) {
                    bis = bisTag + ".";
                }
                if (bisMonat != null && !bisMonat.equals("")
                        && !bisMonat.equals("0")) {
                    bis = bis + bisMonat + ".";
                }
                if (bisJahr != null && !bisJahr.equals("")
                        && !bisJahr.equals("0")) {
                    bis = bis + bisJahr;
                }
                if (bis.equals("") && bisJhdt != null) {
                    bis = bisJhdt;
                }

                if (!bis.equals("") && !bis.contains("J") && !bis.equals("0")
                        && (bisTag == null || bisTag.equals("") || bisTag.equals("0"))
                        && (bisMonat == null || bisMonat.equals("") || bisMonat.equals("0"))
                        && (bisJahr == null || bisJahr.equals("") || bisJahr.equals("0"))) {
                    bis = bis + " Jh.";
                }

                if (!bis.equals(von) && !bis.equals("")) {
                    out.println("<td>" + von + " - " + bis
                            + "</td>");
                } else {
                    out.println("<td>" + von + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>\n");
        }

        //backend: namenkommtar, Philologischer Kommentar (...) z.b (Idwiniz)
        if (modul.equals("PLemma")) {
            try {
                List<String> plemmaList = ModulIncDB.getListPlemma(id);

                if (plemmaList != null && !plemmaList.isEmpty()) {

                    for (String plemma : plemmaList) {
                        String lemma = plemma;

                        if (lemma != null) {
                            out.println(format(lemma, "PLemma"));
                        } else {
                            out.println("");
                        }
                    }
                }
            } catch (Exception e) {
                out.println(e);
            }
        }
    }
%>
