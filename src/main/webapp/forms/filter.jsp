<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@page import="java.util.Locale"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
    int id = -1;
    String title = request.getParameter("title");
    int filter = 0;
    String filterParameter = null;
    String formular = request.getParameter("formular");

    try {
        id = Integer.parseInt(request.getParameter("ID"));
    } catch (Exception e) {
    }
    try {
        filter = ((Integer) session.getAttribute(formular + "filter")).intValue();
        filterParameter = (String) session.getAttribute(formular + "filterParameter");
    } catch (Exception e) {
    }

    if (!title.contains("gast_")) {
        List<DatenbankFilter> filters = DatenbankDB.getListFilter();
        out.println("<select class=\"ut-form__select ut-form__field \" name=\"filter\" id=\"id_field\">");
        for (DatenbankFilter datenbankFilter : filters) {
            if (datenbankFilter.getFormular().equals(title)) {

                String bezeichnung = "";
                String language =  Language.getLanguage(request);
                if(language.equals("de")){
                    bezeichnung = datenbankFilter.getBezeichnung();
                }else if(language.equals("gb")){
                    bezeichnung = datenbankFilter.getGb();
                }else if(language.equals("fr")){
                    bezeichnung = datenbankFilter.getFr();
                }else if(language.equals("la")){
                    bezeichnung = datenbankFilter.getLa();
                }

                out.println("<option label=\"" + DBtoHTML(bezeichnung) + "\"value=\"" + datenbankFilter.getNummer() + "\"" + (datenbankFilter.getNummer() == filter ? " selected" : "") + ">" + DBtoHTML(datenbankFilter.getBezeichnung()) + "</option>");
            }
        }
        out.println("</select>");
        out.println("<input class=\"ut-form__input ut-form__field\" type=\"text\" name=\"filterParameter\" value=\"" + (filterParameter == null ? "" : filterParameter) + "\" size=\"10\" maxlength=\"50\">");

        %>
        <input class="ut-form__input" type="submit" value="<% Language.printTextfield(out, session, "navigation", "Filter");%>">
        <%
    }
%>
