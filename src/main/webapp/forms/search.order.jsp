<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
    List<String> rowlist = AbstractBase.getStringListNative("SELECT Textfeld FROM datenbank_texte WHERE Formular='freie_suche' AND Textfeld LIKE \"Order%\" ORDER BY Textfeld");

    String radio = request.getParameter("name") + "ASCDESC";
    String zeitraum = request.getParameter("name") + "zeit";

    out.println("<select name=\"" + request.getParameter("name") + "\">");
    out.println("  <option value=\"-1\">--</option>");
    for (String textfeldValue : rowlist) {
%>
<option value="<%=textfeldValue%>">
    <jsp:include page="../inc.erzeugeBeschriftung.jsp">
        <jsp:param name="Formular" value="freie_suche"/>
        <jsp:param name="Textfeld" value="<%=textfeldValue%>"/>
    </jsp:include>
</option>
<%
    }
    out.println("</select>");
%>
<input type="radio" name="<%= radio%>" value="ASC" checked/>
<jsp:include page="../inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="freie_suche"/>
    <jsp:param name="Textfeld" value="SortierungASC"/>
</jsp:include>
&nbsp;
<input type="radio" name="<%= radio%>" value="DESC" />
<jsp:include page="../inc.erzeugeBeschriftung.jsp">
    <jsp:param name="Formular" value="freie_suche"/>
    <jsp:param name="Textfeld" value="SortierungDESC"/>
</jsp:include>
<br><% Language.printTextfield(out, session, "gast_freie_suche", "ZeitraumDatierung");%> <input type="text" name="<%= zeitraum%>" />
