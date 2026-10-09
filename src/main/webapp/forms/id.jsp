<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ include file="../configuration.jsp" %>

<%
    String id = request.getParameter("ID");
    String title = request.getParameter("title");
    String provenanceId = null;
    String provenanceSrc = null;
    String DMPtype = null;
    String DMPprimaryColumn = null;
    if (title.contains("gast_")) {
        title = title.substring(5);
    }

    out.println("ID: ");
    if (title.toLowerCase().equals("einzelbeleg")) {
        out.print("B");
        provenanceId = EinzelbelegDB.getProvenanceId(id, "einzelbeleg");
        provenanceSrc = EinzelbelegDB.getProvenanceSource(id, "einzelbeleg");
        DMPtype = "namen";
        DMPprimaryColumn = "g_index";
    } else if (title.toLowerCase().equals("person")) {
        out.print("P");
        provenanceId = PersonDB.getProvenanceId(id, "person");
        provenanceSrc = PersonDB.getProvenanceSource(id, "person");
    } else if (title.toLowerCase().equals("namenkommentar")) {
        out.print("N");
        provenanceId = NamenKommentarDB.getProvenanceId(id, "namenkommentar");
        provenanceSrc = NamenKommentarDB.getProvenanceSource(id, "namenkommentar");
    } else if (title.toLowerCase().equals("quelle")) {
        out.print("Q");
        provenanceId = QuelleDB.getProvenanceId(id, "quelle");
        provenanceSrc = QuelleDB.getProvenanceSource(id, "quelle");
        DMPtype = "quelle";
        DMPprimaryColumn = "quelle";
    } else if (title.toLowerCase().equals("edition")) {
        out.print("E");
        provenanceId = EditionDB.getProvenanceId(id, "edition");
        provenanceSrc = EditionDB.getProvenanceSource(id, "edition");
    } else if (title.toLowerCase().equals("handschrift")) {
        out.print("T");
        provenanceId = HandschriftDB.getProvenanceId(id, "handschrift");
        provenanceSrc = HandschriftDB.getProvenanceSource(id, "handschrift");
    } else if (title.toLowerCase().equals("mghlemma")) {
        out.print("M");
        provenanceId = LemmaDB.getProvenanceId(id, "mgh_lemma");
        provenanceSrc = LemmaDB.getProvenanceSource(id, "mgh_lemma");
    }

    out.println(id);
    if (!Utils.isGastEnvironment(request)) {
        if(provenanceSrc != null)
            out.println("<br>" + Language.getTextfield(session, "admin", "ProvenanceDB") + ": " + provenanceSrc);
        if(provenanceId != null) {
            if (provenanceSrc != null && provenanceSrc.equals("DMP") && DMPtype != null && DMPprimaryColumn != null) {
                out.println("<br>" + Language.getTextfield(session, "admin", "ProvenanceDB") + ": <a class=\"ut-link ut-link--external ut-link--context-icon\" href=\"https://dmp.ub.uni-tuebingen.de/?table=" + DMPtype + "&mode=view&" + DMPprimaryColumn + "=" + provenanceId + "\" target=\"_blank\">"+ provenanceId + "</a>");
            } else {
                out.println("<br>" + Language.getTextfield(session, "admin", "ProvenanceDB") + ": " + provenanceId);
            }
        }
    }
%>

