<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
  int id = -1;
  String title = request.getParameter("title");
  if (title.contains("gast_")) {
    title = title.substring(5);
  }

  try {
    id = Integer.parseInt(request.getParameter("ID"));
  } catch (NumberFormatException e) {}
%>
    <select name="jumpType">
      <option value="1">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
          <jsp:param name="Formular" value="jump"/>
          <jsp:param name="Textfeld" value="vor"/>
        </jsp:include>
      </option>
      <option value="-1">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
          <jsp:param name="Formular" value="jump"/>
          <jsp:param name="Textfeld" value="zurück"/>
        </jsp:include>
      </option>
      <option value="0">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
          <jsp:param name="Formular" value="jump"/>
          <jsp:param name="Textfeld" value="zu"/>
        </jsp:include>
      </option>
    </select>
    <input type="text" name="jumpValue" size="5">
    <input type="hidden" name="jumpTable" value="<%= title %>">
    <input type="hidden" name="akt" value="<%= id %>">
    <input type="hidden" name="jump" value="los">
    <button name="jump" type="submit" value="los">
        <% Language.printTextfield(out, session, "jump", "Los");%>
    </button>
