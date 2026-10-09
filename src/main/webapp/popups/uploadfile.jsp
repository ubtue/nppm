<%@ page import="java.io.File" isThreadSafe="false" %>
<%@ page import="java.io.InputStream" isThreadSafe="false" %>
<%@ page import="java.io.FileOutputStream" isThreadSafe="false" %>
<%@ page import="java.sql.Connection" isThreadSafe="false" %>
<%@ page import="java.sql.DriverManager" isThreadSafe="false" %>
<%@ page import="java.sql.ResultSet" isThreadSafe="false" %>
<%@ page import="java.sql.Statement" isThreadSafe="false" %>
<%@ page import="org.apache.commons.fileupload.*" isThreadSafe="false" %>
<%@ page import="org.apache.commons.fileupload.disk.*" isThreadSafe="false" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" isThreadSafe="false" %>
<%@ page import="org.apache.commons.fileupload.util.*" isThreadSafe="false" %>

<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<%
  if (session.getAttribute("BenutzerID")!=null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0) {
%>
<HTML>
  <HEAD>
    <TITLE>Nomen et Gens - Upload</TITLE>
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/layout.css")%>" type="text/css">
    <script src="<%=Utils.getVersionedHref(request, application, "/javascript/funktionen.js")%>" type="text/javascript"></script>
    <noscript></noscript>
  </HEAD>

  <BODY class="popup">
<%
  if (!ServletFileUpload.isMultipartContent(request) && request.getParameter("action") == null && request.getParameter("table") != null && request.getParameter("ID")!= null) {
    if (request.getParameter("table").equals("namenkommentar")) {
      out.println("<h2>Namenkommentar hochladen</h2>");
    }
    else if (request.getParameter("table").equals("quelle") && request.getParameter("attribute").equals("QuellenKommentarDatei")) {
      out.println("<h2>Quellenkommentar hochladen</h2>");
    }
    else if (request.getParameter("table").equals("quelle") && request.getParameter("attribute").equals("UeberlieferungsKommentarDatei")) {
      out.println("<h2>&uuml;berlieferungskommentar hochladen</h2>");
    }
    out.println("<form method=\"POST\" enctype=\"multipart/form-data\">");
    out.println("<input type=\"hidden\" name=\"action\" value=\"upload\">");
    out.println("<input type=\"hidden\" name=\"table\" value=\""+request.getParameter("table")+"\">");
    out.println("<input type=\"hidden\" name=\"attribute\" value=\""+request.getParameter("attribute")+"\">");
    out.println("<input type=\"hidden\" name=\"ID\" value=\""+request.getParameter("ID")+"\">");
    out.println("<input type=\"file\" name=\"file\">");
    out.println("<br/><br/>");
    out.println("<input type=\"submit\" value=\"hochladen\">");
    out.println("</form>");
  }
  else if(ServletFileUpload.isMultipartContent(request)) {
    // Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload();

    // Parse the request
    FileItemIterator iter = upload.getItemIterator(request);
    while (iter.hasNext()) {
      FileItemStream item = iter.next();
      String name = item.getFieldName();
      InputStream stream = item.openStream();
      if (!item.isFormField()) {
        String folder = "";
        if (request.getParameter("table").equals("person")) {
          folder = commentFolder_personenkommentar;
        }
        else if (request.getParameter("table").equals("namenkommentar")) {
          folder = commentFolder_namenkommentar;
        }
       /* else if (request.getParameter("table").equals("quelle") && request.getParameter("attribute").equals("QuellenKommentarDatei")) {
          folder = commentFolder_quellenkommentar;
        }
        else if (request.getParameter("table").equals("quelle") && request.getParameter("attribute").equals("UeberlieferungsKommentarDatei")) {
          folder = commentFolder_ueberlieferungskommentar;
        }*/

        String pathname = this.getServletContext().getRealPath("/")+ path + "\\"+folder+"\\"+item.getName();
        if ((new File(pathname)).exists()) {
          // Datei existiert bereits -> Dateiname tauschen
          out.println("<p>Datei existiert bereits!</p>");
        }
        else {
          // Datei existiert nicht und kann abgespeichert werden

          // Stream in Datei schreiben
          FileOutputStream file = new FileOutputStream(new File(pathname));
          for (int data = stream.read(); data >=0; data = stream.read()) {
            file.write(data);
          }
          file.close();

          // Datenbank aktualisieren
          Connection cn = null;
          Statement  st = null;
          try {
            Class.forName( sqlDriver );
            cn = DriverManager.getConnection( sqlURL, sqlUser, sqlPassword );
            st = cn.createStatement();
            String sql = "UPDATE "+request.getParameter("table")+" SET "+request.getParameter("attribute")+"=\""+item.getName()+"\" WHERE ID="+request.getParameter("ID")+";";
            st.execute(sql);
            out.println("<p>Datei erfolgreich hochgeladen!</p>");
            out.println("<p><a href=\"javascript:opener.location.reload();window.close();\">schlie&szlig;en</a></p>");
          }
          catch (Exception e) {
            out.println(e+"<br>");
          }
          finally {
            try { if( null != st ) st.close(); } catch( Exception ex ) {}
            try { if( null != cn ) cn.close(); } catch( Exception ex ) {}
          }
        }
      } // end else
    } // end while
  } // end if
%>
  </BODY>
</HTML>
<%
  }
  else {
    out.println("<p>Zugriff nicht erlaubt!!!</p>");
    out.println("<a href=\"../index.jsp\">Zur&uuml;ck zur Startseite</a>");
  }
%>
