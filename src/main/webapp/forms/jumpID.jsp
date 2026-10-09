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
    } catch (NumberFormatException e) {
    }
%>

<div  style="display: flex; align-items: center; ">
    <span id="jumpLabel"><% Language.printTextfield(out, session, "jump", "JumpTo");%></span>
    <input class="ut-form__input ut-form__field " id="id_field" type="text" name="jumpValueID" placeholder="z.B. P7404">
    <input type="hidden" name="jumpTable" value="<%= title%>">
    <input type="hidden" name="akt" value="<%= id%>">
    <input type="hidden" name="jumpID" value="los">
    <button name="jumpID" type="submit" value="los">
        <% Language.printTextfield(out, session, "jump", "Los");%>
    </button>
</div>
