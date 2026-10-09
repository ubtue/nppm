<%@page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@page import="java.math.BigInteger" isThreadSafe="false" %>
<%@page import="java.util.*" isThreadSafe="false" %>
<%@page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>
<%@include file="configuration.jsp" %>

<div>
    <jsp:include page="layout/titel.administration.jsp" />
    <div id="form">
        <div id="main">
        <%
            List<Selektion> bezList = SelektionDB.getList(request.getParameter("Tabelle"));
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>");
            out.println(Language.getTextfield(session, "admin", "Bezeichnung"));
            out.println("</th>");
            out.println("<th>");
            out.println(Language.getTextfield(session, "admin", "ProvenanceSource"));
            out.println("</th>");
            out.println("<th>");
            out.println(Language.getTextfield(session, "admin", "ProvenanceID"));
            out.println("</th>");
            out.println("</tr>");
            for(Selektion sel: bezList){
                String bez = SelektionDB.getBezeichnungByID(String.valueOf(sel.getId()),request.getParameter("Tabelle"));
                String proSrc = SelektionDB.getProvenanceSource(String.valueOf(sel.getId()),request.getParameter("Tabelle"));
                String proID = SelektionDB.getProvenanceId(String.valueOf(sel.getId()),request.getParameter("Tabelle"));
                out.println("<tr>");
                out.println("<td>");
                out.println(bez);
                out.println("</td>");
                out.println("<td>");
                out.println(proSrc);
                out.println("</td>");
                out.println("<td>");
                out.println(proID);
                out.println("</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        %>
        </div>
    </div>
</div>
