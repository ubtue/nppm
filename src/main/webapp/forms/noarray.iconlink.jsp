<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>

<%
    if ((feldtyp.equals("gndlink") && !array) || (feldtyp.equals("wikidatalink") && !array) || (feldtyp.equals("geschichtsquellenlink") && !array)) {
        String iconId = AbstractBase.getStringNative("SELECT " + zielAttribut + " FROM " + zielTabelle + " WHERE ID=\"" + id + "\"");
        if (iconId != null && !iconId.trim().equals("")) {
            String link = "";
            if(feldtyp.equals("gndlink")){
                link += "<a class=\"ut-link ut-link--external ut-link--context-icon\" href=\"https://d-nb.info/gnd/" + DBtoHTML(iconId) + "\" target=\"_blank\" style=\"display: inline-block; vertical-align: middle;\"> " + gndIcon + "</a>";
                link += "<a class=\"ut-link ut-link--external ut-link--context-icon\" href=\"https://prometheus.lmu.de/gnd/" + DBtoHTML(iconId) + "\" target=\"_blank\" style=\"display: inline-block; vertical-align: middle; padding-left:10px;\"> " + prometheusIcon + "</a>";
            } else if(feldtyp.equals("wikidatalink")){
                link += "<a class=\"ut-link ut-link--external ut-link--context-icon\" href=\"https://www.wikidata.org/wiki/" + DBtoHTML(iconId) + "\" target=\"_blank\" style=\"display: inline-block; vertical-align: middle;\"> " + wikidataIcon + "</a>";
            } else if(feldtyp.equals("geschichtsquellenlink")){
                link += "<a class=\"ut-link ut-link--external ut-link--context-icon\" href=\"https://geschichtsquellen.de/werk/" + DBtoHTML(iconId) + "\" target=\"_blank\" style=\"display: inline-block; vertical-align: middle;\"> " + geschichtsquellenIcon + "</a>";
            }
            out.println(link);
        }
    }
%>
