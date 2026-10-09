<%@page import="de.uni_tuebingen.ub.nppm.db.BenutzerDB"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<div id="navigation">
    <a href="<%=Utils.getBaseUrl(request)%>/einzelbeleg">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/person">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="person"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/namenkommentar">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="namenkommentar"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/lemma">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="mgh_lemma"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/quelle">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="quelle"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/edition">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="edition"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/handschrift">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="handschrift"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/suche">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="suche"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/datenpflege">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="datenpflege"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/freie_suche">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="freie_suche"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <hr>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/einstellungen">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="einstellungen"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <%      if (session.getAttribute("BenutzerID") != null
                && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0
                && ((Boolean) session.getAttribute("Administrator")).booleanValue()) {
    %>

    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/administration">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="administration"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/file">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="inhaltBearbeiten"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <%
        }
    %>
    <br>
    <hr>
    <hr>
    <a href="<%=Utils.getBaseUrl(request)%>/logout?go=gast">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="abmelden"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
    <br>
    <br>
    <%
        if (session.getAttribute("BenutzerID") != null
                && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0) {

            Benutzer user = BenutzerDB.getById((Integer) session.getAttribute("BenutzerID"));

            if (user != null) {
    %>
    <center>
        <font size="1">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="navigation"/>
            <jsp:param name="Textfeld" value="AngemeldetAls"/>
        </jsp:include>
        <%= DBtoHTML(user.getVorname())%>
        <%= DBtoHTML(user.getNachname())%>
        (<%= DBtoHTML(user.getLogin())%>)
        (<%= DBtoHTML(user.getGruppe().getBezeichnung())%>)
        </font>
    </center>
    <%
            }
        }
    %>
    <br>
    <FORM method="POST">
        <jsp:include page="../forms/language.jsp">
            <jsp:param name="ID" value='<%= request.getParameter("ID")%>'/>
            <jsp:param name="title" value='<%= request.getParameter("title")%>'/>
        </jsp:include>
    </form>
</div>
