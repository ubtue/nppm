<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

    <div id="content" style="overflow: auto;">
      <%
        if (  request.getParameter("form")!=null && request.getParameter("form").equals("freie_suche") ) {
          %><%@ include file="suche/freie_suche.jsp" %><%
        }
      %>
    </div>
