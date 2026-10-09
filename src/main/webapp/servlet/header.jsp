<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false"%>
<!DOCTYPE html>
<HTML>
  <HEAD>
    <TITLE>NPPM - ${title}</TITLE>
    <meta http-equiv="Content-Type"
      content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
    <script>
        const AJAX_URL = '<%= Utils.getAjaxUrl(request) %>';
    </script>
    <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
    <script src="<%=Utils.getVersionedHref(request, application, "/webjars/jquery/3.7.1/jquery.min.js")%>" type="text/javascript"></script>
    <script src="<%=Utils.getVersionedHref(request, application, "/webjars/jQuery-Autocomplete/1.4.11/jquery.autocomplete.min.js")%>" type="text/javascript"></script>

    ${additionalCss}

    ${additionalJs}
    <noscript></noscript>
  </HEAD>

  <BODY>
    <div id="sidebar">
      <jsp:include page="../layout/image.inc.html" />
      <jsp:include page="../layout/navigation.inc.jsp" />
    </div>
