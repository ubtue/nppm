<%@ page import="java.math.BigInteger" isThreadSafe="false" %>
<%@ page import="java.security.MessageDigest" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.BenutzerDB" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.Benutzer" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.AuthHelper" isThreadSafe="false" %>

<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>


<%
if (AuthHelper.isBenutzerLogin(request)) {
    %>
    <jsp:forward page="einzelbeleg" />
    <%
} else  {
    response.sendRedirect(Utils.getBaseUrl(request) + "/gast/infos?sharedHtml=start&current=start");
}
%>
