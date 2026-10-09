<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringWriter"%>
<%@ page isErrorPage="true" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>

<%
// Note: We cannot use the regular "Gast" check here because the URL will change
// when this template is called. So check for the session instead:
    boolean isGast = session == null || session.getAttribute("Gast") == null || (session.getAttribute("Gast") != null && (boolean) session.getAttribute("Gast") == true);

    String guestTable = request.getParameter("jumpTableGuest");

%>

<%!
    public boolean containsCause(Throwable t, Class type) throws java.io.IOException {
        if (t.getClass().equals(type)) {
            return true;
        }
        if (t.getCause() != null) {
            return containsCause(t.getCause(), type);
        }
        return false;
    }

    String getCauseMessage(Throwable exception, Class<?> causeClass) {
        while (exception != null) {
            if (causeClass.isInstance(exception)) {
                return exception.getMessage();
            }
            exception = exception.getCause();
        }
        return null;
    }

%>

<% if (isGast) { %>
<jsp:include page="gast/servlet/header.jsp" />
<% } else { %>
<jsp:include page="servlet/header.jsp" />
<div id="titel"></div>
<div id="form">
    <% }%>

    <h1 class="ut-heading ut-heading--h1" style="color: red">
        <%= "de".equals(session.getAttribute("Sprache")) ? "Fehler" : "Error"%>
    </h1>

    <p style="font-weight: bold;">
        <% if (response.getStatus() == 404) {%>
        <span><%= "de".equals(session.getAttribute("Sprache")) ? "Die Unterseite existiert nicht." : "The subpage does not exist."%></span>
        <% } else if (exception != null) { %>
        <% if (containsCause(exception, IdNotFoundException.class)) { %>
        <%
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            String sourceId = getCauseMessage(exception, IdNotFoundException.class);
            out.println(sourceId);
        } else if(containsCause(exception, ContainsInvalidStrException.class)){
            response.setStatus(HttpServletResponse.SC_SEE_OTHER);
            String sourceId = getCauseMessage(exception, ContainsInvalidStrException.class);
            out.println(sourceId);
        }
        else if (containsCause(exception, LoginException.class)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            String sourceId = getCauseMessage(exception, LoginException.class);
            out.println(sourceId);
        } else if (containsCause(exception, BenutzerNotAdminException.class)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);%>
        <span><%= "de".equals(session.getAttribute("Sprache"))
                ? "Zugriff verweigert: Sie verfügen nicht über die erforderlichen Administratorrechte."
                : "Access denied: You do not have the required administrator privileges."%>
        </span>
        <% } else if (containsCause(exception, BenutzerNotSetException.class)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);%>
        <span><%= "de".equals(session.getAttribute("Sprache"))
                ? "Bitte melden Sie sich an, um Zugriff auf diesen Bereich zu erhalten."
                : "Please log in to access this area."%>
        </span>
        <% } else if (!"guestTable".equals(guestTable) && containsCause(exception, IdInvalidException.class)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);%>
        <span><%= "de".equals(session.getAttribute("Sprache"))
                ? "ID muss mit B, P, M, N, Q, T, oder E beginnen und mit einer Nummer enden (z.B. P7404)."
                : "ID must start with B, P, M, N, Q, T, or E and end with a number (e.g. P7404)."%>
        </span>

        <% } else if ("guestTable".equals(guestTable) && containsCause(exception, IdInvalidException.class)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);%>
        <span><%= "de".equals(session.getAttribute("Sprache"))
                ? "ID muss mit B, P, M oder Q beginnen und mit einer Nummer enden (z.B. P7404)."
                : "ID must start with B, P, M or Q and end with a number (e.g. P7404)."%>
        </span>

        <% } else if (containsCause(exception, IdNotPublicException.class)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            String sourceId = getCauseMessage(exception, IdNotPublicException.class);
            out.println(sourceId);
        } else if (Utils.isDevelopmentEnvironment()) {%>
        <%
            //Stacktrace enthält auch exception message
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            exception.printStackTrace(pw);
            String stacktrace = sw.toString();
        %>
    <pre><%= stacktrace%></pre>
    <% } else {%>
    <span>
        <%= "de".equals(session.getAttribute("Sprache"))
                ? "Eine unbehandelte Ausnahme vom Typ " + exception.getClass().getSimpleName() + " ist aufgetreten."
                : "An unhandled exception of type " + exception.getClass().getSimpleName() + " occurred."%>
    </span>

    <% } %>
    <% } else {%>
    <span>
        <%= "de".equals(session.getAttribute("Sprache"))
                ? "Keine weiteren Informationen verfügbar."
                : "No further information available."%>
    </span>
    <% } %>
</p>

<hr>

<% if (session.getAttribute("Sprache").equals("de")) { %>
<p>
    Falls Sie technischen Support benötigen, können Sie uns unter folgender Adresse kontaktieren: <a href="mailto:nppm-team@ub.uni-tuebingen.de" rel="nofollow">nppm-team@ub.uni-tuebingen.de</a>.<br>
    Bitte fügen Sie folgende Angaben hinzu:
<ul style="list-style: initial;">
    <li>Datum/Uhrzeit</li>
    <li>Screenshot (inkl. URL + Fehlermeldung)</li>
    <li>Ihr Benutzername (falls zutreffend)</li>
</ul>
</p>
<% } else { %>
<p>
    For technical support, please contact us at the following address: <a href="mailto:nppm-team@ub.uni-tuebingen.de" rel="nofollow">nppm-team@ub.uni-tuebingen.de</a>.<br>
    Please include the following information:
<ul style="list-style: initial;">
    <li>Date/Time</li>
    <li>Screenshot (including URL and error message)</li>
    <li>Your username (if applicable)</li>
</ul>
</p>

<% }
    if (isGast) { %>
<jsp:include page="gast/servlet/footer.jsp" />
<% } else { %>
</div>
<% }%>
