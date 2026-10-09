<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if (feldtyp.equals("textfield") && !array) {
        if (!isReadOnly) {
            out.print("<input name=\"" + datenfeld + "\" style=\"width: 250px\"");
            if (formular.endsWith("freie_suche")) {
                out.print(" placeholder=\"" + platzhalter + "\" ");
            }
        }

        if (Integer.parseInt(id) > 0) {
            String value_zielAttribut = AbstractBase.getStringNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
            if (value_zielAttribut != null) {
                if (!isReadOnly) {
                    out.print("value=\"" + DBtoHTML(value_zielAttribut) + "\" ");
                } else {
                    String belegformHtml = DBtoHTML(value_zielAttribut);
                    if (formular.equals("einzelbeleg") && datenfeld.equals("Belegform")) {
                        belegformHtml = getBelegformExternalLinked(request, id, belegformHtml);
                    }

                    if (schemaOrgProperty != null && !schemaOrgProperty.isEmpty())
                        belegformHtml = "<span property=\"" + schemaOrgProperty + "\">" + belegformHtml + "</span>";

                    out.println(belegformHtml);
                }
            } else if (def != null) {
                if (!isReadOnly) {
                    out.print("value=\"" + def + "\" ");
                } else {
                    out.println(format(def, isKlarlemma ? "Klarlemma" : ""));
                }
            }
        }
        if (zielAttribut != null) {
            if (!isReadOnly) {
                Integer maxLength = AbstractBase.getMaxCharacterLength(zielTabelle, zielAttribut);
                out.println((size > 0 ? "size=\"" + size + "\" " : "")
                        + "maxlength=\"" + ((maxLength != null) ? maxLength : "") + "\" ");
            }
        }

        if (!isReadOnly) {
            out.println(">");
        }
        if (!tooltip.equals("")) {
            out.println("<a class=\"ut-link\" href=\"javascript:return false;\" style=\"text-decoration:none;color:gray;\" title=\"" + tooltip + "\"> ? </a>");
        }
    }
%>
