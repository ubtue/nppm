<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("textfield") && array) {

        List<Object[]> rowlist = AbstractBase.getListNative("SELECT ID, " + zielAttribut + " FROM " + zielTabelle + " WHERE " + formular + "ID=\"" + id + "\"");

        if ((rowlist != null && !rowlist.isEmpty()) || !isReadOnly) {
            out.println("<table class=\"ut-table--color-primary-1 \">");
            out.println("<thead class=\"ut-table__header \">");

            int i = 0;
            for (Object[] row : rowlist) {
                String row_id = String.valueOf(row[0]);
                String row_zielAttribut = String.valueOf(row[1]);

                out.println("<tr class=\"ut-table__row\">");
                out.println("<td class=\"ut-table__item ut-table__body__item\">");
                if (!isReadOnly) {
                    out.print("<input name=\"" + datenfeld + "[" + i + "]\" ");
                }
                String hidden = "";
                hidden = "<input type=\"hidden\" name =\"" + datenfeld + "[" + i + "]" + "_entryid\" value=\"" + row_id + "\">";
                if (!isReadOnly) {
                    out.print("value=\"");
                }

                if (!isReadOnly) {
                    out.print(DBtoHTML(row_zielAttribut));
                } else {
                    String output = DBtoHTML(row_zielAttribut);
                    if (schemaOrgProperty != null && !schemaOrgProperty.isEmpty()) {
                        output = "<span property=\"" + schemaOrgProperty + "\">" + output + "</span>";
                    }
                    out.print(output);
                }
                if (!isReadOnly) {
                    out.println("\" ");
                }

                if (!isReadOnly) {
                    Integer maxLength = AbstractBase.getMaxCharacterLength(zielTabelle, zielAttribut);
                    out.println((size > 0 ? "size=\"" + size + "\" " : "")
                            + "maxlength=\"" + ((maxLength != null) ? maxLength : "") + "\" "
                            + "/>");
                }
                if (!isReadOnly) {
                    out.println(hidden);
                }
                out.println("</td>");

                String href = "";
                if (returnId.equals("-1")) {
                    href = "javascript:deleteEntry('" + zielTabelle + "', '" + row_id + "', '" + returnpage + "', '" + id + "');";
                } else {
                    href = "javascript:deleteEntry('" + zielTabelle + "', '" + row_id + "', '" + returnpage + "', '" + returnId + "');";
                }

                out.println("<td class=\"ut-table__item ut-table__body__item\">");
                if (!isReadOnly) {
                    out.println("<a href=\"" + href + "\">");
                    out.println(txt_delete);
                    out.println("</a>");
                }

                out.println("</td>");
                out.println("</tr>");
                i++;
            }

            //Create new drop down list when Backend/Admin, not Guest
            if (!isReadOnly) {
                Integer maxLength = AbstractBase.getMaxCharacterLength(zielTabelle, zielAttribut);
                out.println("<tr>");
                out.println("<td>");
                out.print("<input name=\"" + datenfeld + "[" + i + "]\" " + (size > 0 ? "size=\"" + size + "\" " : "") + "maxlength=\"" + ((maxLength != null) ? maxLength : "") + "\" />");
                out.println("</td>");
                out.println("</tr>");
            }

            out.println("</thead>");
            out.println("</table>");
        }
    }
%>
