<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ page import="java.util.List" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.model.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<HTML>
    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <TITLE>
            NPPM | Login
        </TITLE>
        <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
        <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/login.css")%>" type="text/css">
    </HEAD>
    <BODY>
        <form method="POST">
            <input type="hidden" name="action" value="login">
            <div class="flexbox-container" >
                <div class="flex-item-title">
                    <h1 class="login"><%= DBtoHTML(Language.getTextfield(session, "logo", "NPPM"))%></h1>
                </div>
                <div class="flex-item-title flex-item-table">
                    <table border="0">

                        <tr><td colspan="2"><h2 class="login">
                                    <jsp:include page="../inc.erzeugeBeschriftung.jsp">
                                        <jsp:param name="Formular" value="login"/>
                                        <jsp:param name="Textfeld" value="Anmeldung"/>
                                    </jsp:include>
                                </h2></td></tr>
                        <tr>
                            <th><label for="username">
                                    <jsp:include page="../inc.erzeugeBeschriftung.jsp">
                                        <jsp:param name="Formular" value="login"/>
                                        <jsp:param name="Textfeld" value="Benutzername"/>
                                    </jsp:include>
                                </label></th>
                            <td><input name="username" placeholder="<%= DBtoHTML(Language.getTextfield(session, "login", "Benutzername"))%>" /></td>
                        </tr>
                        <tr>
                            <th><label for="password">
                                    <jsp:include page="../inc.erzeugeBeschriftung.jsp">
                                        <jsp:param name="Formular" value="login"/>
                                        <jsp:param name="Textfeld" value="Passwort"/>
                                    </jsp:include>
                                </label></th>
                            <td>
                                <div class="input-container">
                                    <input type="password" id="passwordx" name="password" placeholder="<%= DBtoHTML(Language.getTextfield(session, "login", "Passwort"))%>" />
                                    <span class="toggle-eye" onclick="togglePassword('passwordx', this)">&#128065;</span> <!-- Auge -->

                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <input type="submit" value='<%= DBtoHTML(Language.getTextfield(session, "login", "DatenSenden"))%>' style="margin:5px 0px 0px 50px"/>



                <p> &nbsp; </p><!-- comment -->
                <a href="../forgotPassword"><%= DBtoHTML(Language.getTextfield(session, "login", "PasswortVergessen"))%></a>
            </div>  <!-- ende flexbox-container -->
        </form>
    <center>
        <form method="POST">
            <jsp:include page="../forms/language.jsp">
                <jsp:param name="ID" value='<%= request.getParameter("ID")%>'/>
                <jsp:param name="title" value='<%= request.getParameter("title")%>'/>
            </jsp:include>
        </form>
    </center>
</BODY>
</HTML>

<script>
    function togglePassword(fieldId, eyeIcon) {
        let inputField = document.getElementById(fieldId);
        if (inputField.type === "password") {
            inputField.type = "text";
            eyeIcon.innerHTML = "&#128274;"; // Schloss-Symbol 🔒
        } else {
            inputField.type = "password";
            eyeIcon.innerHTML = "&#128065;"; // Auge-Symbol 👁
        }
    }
</script>
