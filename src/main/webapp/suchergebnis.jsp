<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>

    <div onLoad="javascript:onoff('tab4','tab1'); onoff('tab1','tab4');">

    <jsp:include page="dojump.jsp">

  <jsp:param name="form" value="gast_quelle" />
</jsp:include>
    <jsp:include page="layout/titel.suche.jsp" />
    <div id="form">
      <%
              session.setAttribute("filter", 0);
        session.setAttribute("filterParameter", "");

        if ( request.getParameter("form").equals("identischesLemma") ) {
          %><%@ include file="suche/identischesLemma.jsp" %><%
        }
        else if (  (request.getParameter("jumpID") == null || !request.getParameter("jumpID").equals("los")) &&
         request.getParameter("form").equals("freie_suche") ) {
          %><%@ include file="suche/freie_suche.jsp" %><%
        }
        else if ( request.getParameter("form").equals("namenkommentar") ) {
          %><%@ include file="suche/namenkommentar.jsp" %><%
        }
      %>
    </div>
  </div>

    
