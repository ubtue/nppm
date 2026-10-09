<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>

<%
    if (feldtyp.equals("dateRO") && !array) {

        // Build Query + get all relevant field from DB table
        String[] zielattributArray = zielAttribut.split(";");
        for (int i = 0; i < zielattributArray.length; i++) {
            zielattributArray[i] = zielattributArray[i].trim();
        }
        String results[] = new String[zielattributArray.length * 2];

        String zielattribute = "Genauigkeit" + zielattributArray[0]
                + ", " + zielattributArray[0];
        for (int i = 1; i < zielattributArray.length; i++) {
            zielattribute += ", Genauigkeit" + zielattributArray[i]
                    + ", " + zielattributArray[i];
        }

        Map row = AbstractBase.getMappedRow("SELECT " + zielattribute + " FROM "
                + zielTabelle + " WHERE ID ='" + id + "'");

        if (row != null) {
            // Build up "results" array with same indexes as zielAttributArray
            int resultIndex = 0;
            for (String zielattribut : zielattributArray) {
                String zielattributGen = "Genauigkeit" + zielattribut;
                results[resultIndex++] = row.get(zielattributGen) == null ? null : String.valueOf(row.get(zielattributGen));
                results[resultIndex++] = row.get(zielattribut) == null ? null : String.valueOf(row.get(zielattribut));
            }

            // Initialize all display variables
            String von = "";
            String vonGen = "";
            String bis = "";
            String bisGen = "";

            // Generate von + vonGen
            for (int i = 0; i < zielattributArray.length - 1; i++) {
                if (i % 2 == 0) {
                    if (vonGen == null || vonGen.equals("") || vonGen.equals("-1")) {
                        vonGen = results[i];
                    }
                } else if (results[i] != null
                        && !results[i].equals("")
                        && !results[i].equals("0")) {
                    von += results[i]
                            + (((i % (zielattributArray.length)) < 4) ? "."
                                    : "");
                }
            }

            // Special handling if "von" is empty to use last 2 fields (GenauigkeitBisJahrhundert, BisJahrhundert)
            if (von.equals("")
                    && results[zielattributArray.length - 1] != null
                    && !results[zielattributArray.length - 1]
                            .equals("0")) {
                if (vonGen.equals("") || vonGen.equals("-1")) {
                    vonGen = results[zielattributArray.length - 2];
                }
                von = results[zielattributArray.length - 1];
            }

            // Generate bis + bisGen
            for (int i = zielattributArray.length; i < zielattributArray.length * 2 - 1; i++) {
                if (i % 2 == 0) {
                    if (bisGen == null || bisGen.equals("") || bisGen.equals("-1")) {
                        bisGen = results[i];
                    }
                } else if (results[i] != null
                        && !results[i].equals("")
                        && !results[i].equals("0")) {
                    bis += results[i]
                            + (((i % (zielattributArray.length)) < 4) ? "."
                                    : "");
                }
            }

            // Lookup vonGen vs selektion_datgenauigkeit
            Map row2 = AbstractBase.getMappedRow("SELECT * FROM selektion_datgenauigkeit WHERE ID=" + vonGen);
            vonGen = row2 != null && !vonGen.equals("-1") ? String.valueOf(row2.get("Bezeichnung")) : "";

            // Special handling if "bis" is empty to use last 2 fields (GenauigkeitBisJahrhundert, BisJahrhundert)
            if (bis.equals("")
                    && results[zielattributArray.length - 1] != null
                    && !results[zielattributArray.length - 1]
                            .equals("0")) {
                if (bisGen == null || bisGen.equals("") || bisGen.equals("-1")) {
                    bisGen = results[zielattributArray.length * 2 - 2];
                }
                bis = results[zielattributArray.length * 2 - 1];
            }

            // Lookup bisGen vs selektion_datgenauigkeit
            row2 = AbstractBase.getMappedRow("SELECT * FROM selektion_datgenauigkeit WHERE ID=" + bisGen);
            bisGen = row2 != null && !bisGen.equals("-1") ? String.valueOf(row2.get("Bezeichnung")) : "";

            // Print output depeding on whether "bis" is set as well or not
            if (bis != null && von != null && !bis.equals(von) && !bis.equals("0") && !bis.equals("")) {
                String vonTotal = vonGen + " " + von;
                String bisTotal = bisGen + " " + bis;
                vonTotal = vonTotal.trim();
                bisTotal = bisTotal.trim();
                out.println(vonTotal + " - " + bisTotal);
            } else {
                if (von != null) {
                    out.println(vonGen + " " + von);
                }
            }
        }
    }
%>
