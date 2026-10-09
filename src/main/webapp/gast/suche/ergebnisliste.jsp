<%@page import="de.uni_tuebingen.ub.nppm.util.pagination.search.PrintPagination"%>
<%@page import="java.io.IOException"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@ page import="java.util.*"%>

<%!
    private static <T> void moveItem(List<T> list, T item, int newIndex) {
        if (list.remove(item)) {
            list.add(newIndex, item);
        }
    }
%>


<%
    if (true) {

        for (int i = 0; i < fields.size(); i++) {
            if ("edition.Titel".equals(fields.get(i))) {
                fields.set(i, "edition.Zitierweise");
                break; // falls es nur einmal vorkommt
            }
        }

        conditions = removeDuplicates(conditions);
        fields = removeDuplicates(fields);
        tables = removeDuplicates(tables);
        joins = removeDuplicates(joins);

        // Bedingungen
        String conditionsString = "";
        if (conditions.size() > 0) {
            conditionsString += conditions.get(0);
            for (int i = 1; i < conditions.size(); i++) {
                conditionsString += " AND " + conditions.get(i);
            }
        } else {
            conditionsString += "1";
        }

        // Ausgabefelder
        String fieldsString = "";
        if (fields.size() > 0) {
            fieldsString += QueryHelper.getFieldAliasSelect(fields.get(0));
            for (int i = 1; i < fields.size(); i++) {
                fieldsString += ", " + QueryHelper.getFieldAliasSelect(fields.get(i));
            }
        }

        String[] fieldArray = fieldsString.split(",\\s*");  // Aufteilen an Komma + optionalen Leerzeichen
        List<String> fieldList = new ArrayList<>(Arrays.asList(fieldArray));

        int index = fieldNames.indexOf("edition.Titel");
        if (index != -1) {
            fieldNames.set(index, "edition.Zitierweise");
        }

        // Belegform ganz nach vorne
        String feld = "einzelbeleg.Belegform AS einzelbeleg_Belegform";
        moveItem(fieldList, feld, 0);
        moveItem(fieldNames, "einzelbeleg.Belegform", 0);
        moveItem(headlines, "Belegform", 0);

        // Quelle an zweite Stelle (Index 1)
        feld = "quelle.Bezeichnung AS quelle_Bezeichnung";
        moveItem(fieldList, feld, 1);
        moveItem(fieldNames, "quelle.Bezeichnung", 1);
        moveItem(headlines, "Quelle", 1);

        // Neues Feld an Position 3 einfügen (Index 2)
        feld = "einzelbeleg.Seite AS einzelbeleg_Seite";
        fieldList.add(2, feld);
        fieldNames.add(2, "einzelbeleg.Seite");
        headlines.add(2, "Nr./Seite");

        // Neues Feld an Position 4 einfügen (Index 3)
        feld = "einzelbeleg.Raster AS einzelbeleg_Raster";
        fieldList.add(3, feld);
        fieldNames.add(3, "einzelbeleg.Raster");
        headlines.add(3, "Rast.");

        feld = "edition.Zitierweise AS editionZitierweise";
        moveItem(fieldList, feld, 4);
        moveItem(fieldNames, "edition.Zitierweise", 4);
        moveItem(headlines, "Edition", 4);

        feld = "einzelbeleg.EditionKapitel AS einzelbeleg_EditionKapitel";
        moveItem(fieldList, feld, 5);
        moveItem(fieldNames, "einzelbeleg.EditionKapitel", 5);
        moveItem(headlines, "Kapitel in der Edition", 5);

        feld = "einzelbeleg.EditionSeite AS einzelbeleg_EditionSeite";
        moveItem(fieldList, feld, 6);
        moveItem(fieldNames, "einzelbeleg.EditionSeite", 6);
        moveItem(headlines, "Seiten in der Edition", 6);

        feld = "einzelbeleg.Kontext AS einzelbeleg_Kontext";
        moveItem(fieldList, feld, 7);
        moveItem(fieldNames, "einzelbeleg.Kontext", 7);
        moveItem(headlines, "Kontext", 7);

        // fieldsString wieder zusammensetzen
        fieldsString = String.join(", ", fieldList);

        // Tabellen
        String tablesString = "";
        if (tables.size() > 0) {
            tablesString += tables.get(0);
            for (int i = 1; i < tables.size(); i++) {
                tablesString += ", " + tables.get(i);
            }
        }

        // Joins
        String joinsString = "";
        if (joins.size() > 0) {
            joinsString += joins.get(0);
            for (int i = 1; i < joins.size(); i++) {
                joinsString += " " + joins.get(i);
            }
        }

        tablesString = tableString;
        int pageoffset = 0;
        if (request.getParameter("pageoffset") != null) {
            pageoffset = Integer.parseInt(request.getParameter("pageoffset"));
        }

        if (fields.size() == 0) {
            out.println(Language.getTextfield(session, "suche", "schritt2"));
            return;
        }

        int linecount = SucheDB.getLinecount(tablesString, conditionsString);

        out.println("<h3 class=\"ut-heading ut-heading--h3\">"+Language.getTextfield(session, "suche", "gesamteTreffer") +" "+ linecount + "</h3>");
        // ########## SEITENNAVIGATION #########
        PrintPagination.printPageNavigation(out, request, pageoffset, pageLimit, linecount, export);

        String sql = "SELECT " + fieldsString + " FROM " + tablesString + " WHERE (" + conditionsString + ") " + order; //GROUP BY "+fieldsString+"
        if (export.equals("liste") || export.equals("browse")) {
            sql += " LIMIT " + (pageoffset * pageLimit) + ", " + pageLimit;
        }

        List<Map> rowlist = SucheDB.getMappedList(sql);

        // ########## LISTE/BROWSE ##########
        if (export.equals("liste") || export.equals("browse")) {
            String oldValue[] = new String[5];

            out.println("<table class=\"ut-table ut-table--striped ut-table--striped--color-primary-3\">");
            out.println("<tbody class=\"ut-table__body\">");
            out.println("<tr class=\"ut-table__row\">");
            for (int i = 0; i < headlines.size(); i++) {
                out.println("<th class=\"ut-table__item ut-table__header__item\" scope=\"col\">");
                // Link für Seite erzeugen
                String direction = "";
                if (order.contains(fieldNames.get(i))) {
                    direction = order.substring(order.indexOf(fieldNames.get(i) + " ") + fieldNames.get(i).length() + 1, min(order.length(), order.indexOf(fieldNames.get(i) + " ") + fieldNames.get(i).length() + 5));
                    if (direction.contains("DESC")) {
                        direction = "DESC";
                    } else {
                        direction = "ASC";
                    }
                }

                String parameter = "?neworder=" + fieldNames.get(i);
                if (direction.equals("ASC")) {
                    parameter += "&newdirection=DESC";
                } else {
                    parameter += "&newdirection=ASC";
                }

                for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
                    String paramName = e.nextElement();
                    if (!paramName.contains("order") && !paramName.equals("newdirection")) {
                        parameter += "&" + paramName + "=" + urlEncode(request.getParameter(paramName));
                    }
                }

                out.print("<a class=\"ut-link\" href=\"" + parameter + "\">");
                out.print(headlines.get(i));
                if (direction.equals("ASC")) {
                    out.print("<img src='layout/icons/arrowup.gif'>");
                } else if (direction.equals("DESC")) {
                    out.print("<img src='layout/icons/arrowdown.gif'>");
                }
                out.println("</a>");
                out.println("</th>");
            }

            for (Map<String, String> row : rowlist) {

                out.println("<tr class=\"ut-table__row\">");
                if (!formular.equals("favorit") && !formular.equals("freie_suche") && !formular.equals("mgh_lemma") && !formular.equals("namenkommentar") && !formular.equals("literatur")) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\" valign=\"top\" align=\"center\"><a class=\"ut-link\" href=\"" + formular + ".jsp?ID=" + row.get(formular + ".ID").toString() + "\">Gehe zu</a></td>");
                }

                for (int i = 0; i < fieldNames.size(); i++) {
                    out.println("<td class=\"ut-table__item ut-table__body__item\" valign=\"top\">");
                    String fieldName = fieldNames.get(i);
                    String fieldAlias = QueryHelper.getFieldAliasResult(fieldName);
                    if (row.get(fieldAlias) != null && !String.valueOf(row.get(fieldAlias)).equals("")) {
                        String fieldValue = String.valueOf(row.get(fieldAlias));
                        String cell = DBtoHTML(fieldValue);
                        if (export.equals("browse")) {
                            boolean link = false;
                            if (fieldName.contains("einzelbeleg.Belegform") && row.get(QueryHelper.getFieldAliasResult("einzelbeleg.ID")) != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "B" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("einzelbeleg.ID")))) + "\">");
                                link = true;
                            } else if (fieldName.contains("person.Standardname") && row.get(QueryHelper.getFieldAliasResult("person.ID")) != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("person.ID")))) + "\">");
                                link = true;
                            } else if (fieldName.contains("perszu.Standardname") && row.get(QueryHelper.getFieldAliasResult("perszu.ID")) != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "P" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("perszu.ID")))) + "\">");
                                link = true;
                            } else if (fieldName.contains("namenkommentar.PLemma") && row.get(QueryHelper.getFieldAliasResult("namenkommentar.ID")) != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "N" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("namenkommentar.ID")))) + "\">");
                                link = true;
                            } else if (fieldName.contains("quelle.Bezeichnung") && row.get(QueryHelper.getFieldAliasResult("quelle.ID")) != null) {
                                out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "Q" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("quelle.ID")))) + "\">");
                                link = true;
                            } else if (fieldName.contains("edition.Zitierweise") && row.get(QueryHelper.getFieldAliasResult("edition.ID")) != null) {
                                try {
                                    out.print("<a class=\"ut-link\" href=\"" + Utils.getPidUrl(request, "E" + String.valueOf(row.get(QueryHelper.getFieldAliasResult("edition.ID")))) + "\">");
                                    link = true;
                                } catch (Exception e) {
                                    link = false;
                                }
                            } else if (fieldName.contains("ID")) {
                                out.println("<a class=\"ut-link\" href=\"" + formular + ".jsp?ID=" + row.get(formular + ".ID").toString() + "\">Gehe zu: ");
                                link = true;
                            }
                            out.print(cell);
                            if (link) {
                                out.println("</a>");
                            }
                        } else {
                            out.println(cell);
                        }
                    } else {
                        out.println("&nbsp;");
                    }
                    out.println("</td>");
                }
                out.println("</tr>");
            }
            out.println("</tr>");
            out.println("</tbody>");
            out.println("</table>");
        }
        // ########## LISTE/BROWSE #########

        // ########## EXCEL #########
        if (export.equals("excel")) {
            PrintWriter excel = new PrintWriter(new FileWriter(this.getServletContext().getRealPath("/") + "print\\output_" + session.getAttribute("Benutzername") + ".csv"));
            for (int i = 0; i < headlines.size(); i++) {
                excel.print("\"" + headlines.get(i) + "\";");
            }
            excel.println();
            for (Map<String, String> row : rowlist) {
                for (int i = 0; i < fieldNames.size(); i++) {
                    if (row.get(fieldNames.get(i)) == null || row.get(fieldNames.get(i)).toString().equals("null")) {
                        excel.print("\"\";");
                    } else {
                        excel.print("\"" + row.get(fieldNames.get(i)).toString() + "\";");
                    }
                }
                excel.println();
            }
            excel.close();
            out.println("<a  class=\"ut-link\" href='../../print/output_" + session.getAttribute("Benutzername") + ".csv'>herunterladen</a>");
        }
        // ########## EXCEL #########

        // ########## SEITENNAVIGATION #########
        PrintPagination.printPageNavigation(out, request, pageoffset, pageLimit, linecount, export);
    }
%>
