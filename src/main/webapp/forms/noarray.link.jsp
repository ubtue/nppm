<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>
<%
    if (feldtyp.startsWith("link") && !array) {
        String[] fields = feldtyp.substring(feldtyp.lastIndexOf('(') + 1, feldtyp.lastIndexOf(')')).split(",");

        Map row = AbstractBase.getMappedRow("SELECT * FROM " + zielTabelle + " WHERE " + formularAttribut + "=\"" + id + "\"");
        if (row != null && row.get(fields[1]) != null) {
            Map row2 = AbstractBase.getMappedRow("SELECT " + fields[2] + " FROM " + fields[0] + " WHERE ID=" + String.valueOf(row.get(fields[1])));
            if (row2 != null) {
                String href = fields[0] + "?ID=" + String.valueOf(row.get(fields[1]));
                if (Utils.isGastEnvironment(request)) {
                    String prefix = IdentifierMapper.getPrefixByForm(fields[0]);
                    if (prefix != null) {
                        href = Utils.getPidUrl(request, prefix + String.valueOf(row.get(fields[1])));
                    }
                }
                out.println("<a class=\"ut-link\" href=\"" + href + "\">" + (row2.get(fields[2]) != null ? DBtoHTML(String.valueOf(row2.get(fields[2]))) : "Zum Datensatz") + "</a>");
            }
        }
    }
%>
