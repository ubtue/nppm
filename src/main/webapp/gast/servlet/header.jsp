<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="###LANGUAGE_CODE###" class="no-js mod_picture mod_localstorage mod_cssremunit mod_placeholder mod_srcset mod_mediaqueries mod_no-touchevents mod_formvalidation mod_flexbox mod_csstransitions js-state__ut-nav-is-closed">
  <head>
    <%
    String fullTitle = "NPPM";
    String title = (String)request.getAttribute("title");
    if (title != null && !title.isEmpty()) {
        fullTitle += " | " + title;
    }
    %>
    <title><%=fullTitle%></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- CSS includes (vendor) -->
    <link rel="stylesheet" type="text/css" href="<%=Utils.getVersionedHref(request, application, "/gast/vendor/ut-typo3/css/merged.css")%>" media="all">
    <link rel="stylesheet" type="text/css" href="<%=Utils.getVersionedHref(request, application, "/gast/vendor/ut-typo3/css/ut.fixes.local.css")%>" media="all">
    <link rel="stylesheet" type="text/css" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/fonts/open-sans.css")%>" >
    <link rel="stylesheet" type="text/css" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/fonts/alegreya-sans-sc.css")%>">
    <link rel="stylesheet" type="text/css" href="<%=Utils.getVersionedHref(request, application, "/webjars/jquery-ui/1.14.2/jquery-ui.min.css")%>">


    <!-- CSS includes (local) -->
    <link rel="icon" href="<%=Utils.getBaseUrl(request) + "/gast/layout/images/nppm.ico"%>" type="image/gif">
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/layout.css")%>" type="text/css">

    <!-- ut dependencies (rest of JS dependencies is behind navigation, needs to stay there or navigation cannot be rendered correctly -->
    <script src="<%=Utils.getVersionedHref(request, application, "/gast/vendor/ut-typo3/js/merged_top.js")%>"></script>


    ${additionalCss}

    <% if (request.getAttribute("canonicalUrl") != null) { %>
        <!-- Canonical URL for SEO -->
        <link href="<%=request.getAttribute("canonicalUrl")%>" rel="canonical">
    <% } %>

  </head>
  <body>
    <div class="ut-page">

        <jsp:include page="../layout/header.inc.jsp">
          <jsp:param name="current" value="${navigationTitle}"/>
        </jsp:include>

        <!-- ut => MUST BE BEHIND HEADER, ELSE WE HAVE PROBLEMS RENDERING/EXTENDING THE NAVIGATION -->
        <script src="<%=Utils.getVersionedHref(request, application, "/gast/vendor/ut-typo3/js/merged_bottom.js")%>"></script>
        <!-- merged_bottom.js resets the jQuery version, so we need to include the plugins afterwards -->
        <script src="<%=Utils.getVersionedHref(request, application, "/webjars/jquery/3.7.1/jquery.min.js")%>" type="text/javascript"></script>
        <script src="<%=Utils.getVersionedHref(request, application, "/webjars/jquery-ui/1.14.2/jquery-ui.min.js")%>" type="text/javascript"></script>
        <script src="<%=Utils.getVersionedHref(request, application, "/webjars/jQuery-Autocomplete/1.4.11/jquery.autocomplete.min.js")%>" type="text/javascript"></script>
        <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
        <script src="<%=Utils.getVersionedHref(request, application, "/javascript/javascript.js")%>" type="text/javascript"></script>


        <!-- (these ut-typo3 dependencies are currently not needed and can be added later if necessary) -->
        <!--
        <script src="vendor/modernizr/modernizr.min.js"></script>
        <script src="vendor/popper/popper.js"></script>
        <script src="vendor/yepnope/yepnope-2.0.0.min.js"></script>
        -->

        ${additionalJs}

        <div class="ut-page__main">
            <div class="ut-wrapper">
                <div class="container">
