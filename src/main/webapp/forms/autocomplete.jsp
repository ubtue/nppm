<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>

<%
    if (feldtyp.equals("autocomplete")) {
        String cssClass = "autocomplete-input";
        if ("filterTitle".equals(datenfeld)) {
            cssClass += " filter-title";
        }

        out.print("<input type=\"text\" class=\"" + cssClass + "\" id=\"" + datenfeld + "\" name=\"" + datenfeld + "\" ");
        if (size > 0) {
            out.print("size=\"" + size + "\" ");
        }
        if (valueAutomcomplete != null && !valueAutomcomplete.trim().isEmpty()) {
            out.print("value=\"" + Utils.escapeHTML(valueAutomcomplete) + "\" ");
        }
        if (formular.endsWith("freie_suche") || formular.equals("statistik")) {
            out.print("placeholder=\"" + platzhalter + "\" ");
        }
        out.println("/>");

        out.println("<script>");
        String autocompleteParams = "{action: \"autocomplete\", form:\"" + auswahlherkunft + "\", field:\"" + formularAttribut + "\"";
        if (!Utils.isGastEnvironment(request)) {
            autocompleteParams += ", backend: \"true\"";
        }
        autocompleteParams += "}";
        out.println("$(\"#" + datenfeld + "\").devbridgeAutocomplete({serviceUrl: \""+ Utils.getBaseUrl(request) + "/ajax\", params: " + autocompleteParams + "});");
        out.println("</script>");

        if (!tooltip.equals("")) {
            out.println("<a href=\"javascript:return false;\" class=\"tooltip-link\" title=\"" + tooltip + "\"> ? </a>");
        }
    }
%>
