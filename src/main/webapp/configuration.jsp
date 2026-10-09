<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.AuthHelper"%>
<%
    request.setCharacterEncoding("UTF-8");
    String sqlDriver = "com.mysql.cj.jdbc.Driver";

    // Zugangsdaten für die Datenbank (nur für die Anwendung) => siehe tomcat
    javax.naming.InitialContext initialContext = new javax.naming.InitialContext();
    String sqlURL = (String) initialContext.lookup("java:comp/env/sqlURL");
    String sqlUser = (String) initialContext.lookup("java:comp/env/sqlUser");
    String sqlPassword = (String) initialContext.lookup("java:comp/env/sqlPassword");

    // Zugangsdaten für die NEUE Datenbank (nur für den Import)
    String sqlURLnew = sqlURL;
    String sqlUserNew = sqlUser;
    String sqlPasswordNew = sqlPassword;

    // Zugangsdaten für die ALTE Datenbank (nur für den Import)
    String sqlURLold = sqlURL;
    String sqlUserOld = sqlUser;
    String sqlPasswordOld = sqlPassword;

    // Speicherort der Datei "tabellen.txt" (nur für den Import)
    String tblFile = "E:/tabellen.txt";

    int pageLimit = 10;		// Wichtig für Abfragen
    int sessionTimeout = 60 * 60;
    int numberSize = 5;		// Anzahl der Nummerierungsstellen in PKZ, Belegnummer, etc.

    String txt_search = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/search2.gif\" border=\"0\" alt=\"suchen\" title=\"suchen\">";  // "suchen";
    String txt_delete = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/delete2.gif\" border=\"0\" alt=\"l&ouml;schen\" title=\"l&ouml;schen\">"; // "l&ouml;schen";
    String txt_newentry = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/newentry2.gif\" border=\"0\" alt=\"neuer Eintrag\" title=\"neuer Eintrag\">";  // "neuer Eintrag";

    String gndIcon = "";
    if (AuthHelper.isGastLogin(request)) {
        gndIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/gast/layout/icons/gnd.png\" border=\"0\" alt=\"GND Link\" title=\"GND suchen\">";
    } else {
        gndIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/gnd.png\" border=\"0\" alt=\"GND Link\" title=\"GND suchen\">";
    }

    String prometheusIcon = "";
    if (AuthHelper.isGastLogin(request)) {
        prometheusIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/gast/layout/icons/lmu.ico\" height=\"36\" border=\"0\" alt=\"Prometheus Link\" title=\"Prometheus suchen\">";
    } else {
        prometheusIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/lmu.ico\" height=\"36\" border=\"0\" alt=\"Prometheus Link\" title=\"Prometheus suchen\">";
    }

    String wikidataIcon = "";
    if (AuthHelper.isGastLogin(request)) {
         wikidataIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/gast/layout/icons/wikidata.png\" border=\"0\" alt=\"Wikidata Link\" title=\"Wikidata suchen\">";
    } else {
         wikidataIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/wikidata.png\" border=\"0\" alt=\"Wikidata Link\" title=\"Wikidata suchen\">";
    }

    String geschichtsquellenIcon = "";
    if (AuthHelper.isGastLogin(request)) {
         geschichtsquellenIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/gast/layout/icons/geschichtsquellen.png\" border=\"0\" alt=\"Geschichtsquellen Link\" title=\"Geschichtsquellen suchen\">";
    } else {
         geschichtsquellenIcon = "<img src=\"" + Utils.getBaseUrl(request) + "/layout/icons/geschichtsquellen.png\" border=\"0\" alt=\"Geschichtsquellen Link\" title=\"Geschichtsquellen suchen\">";
    }

    String commentFolder_personenkommentar = "personenkommentar";
    String commentFolder_namenkommentar = "namenkommentar";
    String path = "nppm";
%>
