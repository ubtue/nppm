<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ include file="../configuration.jsp" %>

<%
  int id = -1;
  String title = request.getParameter("title");
  String duplicate = Language.getTextfield(session, "navigation", "Duplizieren");

  try {
    id = Integer.parseInt(request.getParameter("ID"));
  } catch (NumberFormatException e) {}

  if ((title.toLowerCase()).equals("einzelbeleg")) {
%>

    <!-- Formular mit Duplizieren-Button -->
    <form id="duplicateForm">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="button" name="duplicate" value="<%= duplicate %>" id="duplicateButton">
    </form>

    <script>

        $(document).ready(function () {
            let einzelbelegID = <%= id %>;
            let duplicate = "<%= duplicate %>";
            let ajaxUrl = '<%= Utils.getAjaxUrl(request) %>';

            let duplicateSuccess = "<%= Language.getTextfield(session, "duplizieren", "DuplizierenEinzelbeleg") %>";
            let duplicateError = "<%= Language.getTextfield(session, "duplizieren", "ErrorDuplizierenEinzelbeleg") %>";

            // Event für den Button
            $("#duplicateButton").on("click", function () {

                if (confirm(duplicateSuccess)) {
                    $.ajax({
                        type: "POST",
                        url: ajaxUrl,
                        data: { action: "doduplicate", id: einzelbelegID, duplicate: duplicate },
                        success: function () {
                            window.location = window.location.href;
                        },
                        error: function (jqXHR) {
                            alert(duplicateError + " " + jqXHR.status);
                        }
                    });
                }
            });
        });
    </script>

<% } %>
