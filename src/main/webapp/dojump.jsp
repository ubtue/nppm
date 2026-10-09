<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ page import="java.text.SimpleDateFormat" isThreadSafe="false"%>
<%@ page import="java.util.Date" isThreadSafe="false"%>
<%@ include file="configuration.jsp"%>
<%@ include file="functions.jsp"%>

<%    int id = -1;
    String title = request.getParameter("form");
    String newID = request.getParameter("jumpValueID");
    if (newID != null) {
        newID = newID.trim();
    }

    if (newID != null && !newID.isEmpty()) {

        if (request.getParameter("jumpID") != null && (request.getParameter("jumpID").equals("los") || request.getParameter("jumpID").equals(">"))) {
            String guestTable = request.getParameter("jumpTableGuest");
            String jumpTable = request.getParameter("jumpTable");
            String newForm = "";

            /*
            // e.g. if the jump target is just 7404 (without P prefix) and we do not have a default form given
            if (title.equals("") && !newID.matches("^[A-Z]")) {
                throw new IdInvalidException();
            }
             */
            if (newID.startsWith("B") || newID.startsWith("b") || ("einzelbeleg".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Einzelbelege".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "einzelbeleg";
            } else if (newID.startsWith("P") || newID.startsWith("p") || ("person".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Personen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "person";
            } else if (!"guestTable".equals(guestTable) && (newID.startsWith("N") || newID.startsWith("n") || ("namenkommentar".equals(jumpTable) && newID.matches("^[0-9].*")))) {
                newForm = "namenkommentar";
            } else if (newID.startsWith("Q") || newID.startsWith("q") || ("quelle".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Quellen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "quelle";
            } else if (newID.startsWith("E") || newID.startsWith("e") || ("edition".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "edition";
            } else if (newID.startsWith("T") || newID.startsWith("t") || ("handschrift".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "handschrift";
            } else if (newID.startsWith("M") || newID.startsWith("m") || ("mgh_lemma".equals(jumpTable) && newID.matches("^[0-9].*")) || ("Namen".equals(jumpTable) && newID.matches("^[0-9].*"))) {
                newForm = "lemma";
            } else {
                throw new IdInvalidException();
            }

            out.println("<script type=\"text/javascript\">");
            String url = request.getRequestURL().toString();
            out.println(url);
            session.setAttribute(title + "filter", 0);
            session.setAttribute(title + "filterParameter", "");
            url = url.substring(0, url.lastIndexOf('/') + 1);

            if (url.endsWith("gast/") && (newForm.equals("edition") || newForm.equals("handschrift"))) {
                out.println("window.stop();");
                out.println("location.replace('" + url + "error.jsp');");
            } else {
                if (newID.matches("^[BPNQETMbpnqetm].*")) { // Alle gewünschten Buchstaben
                    out.println("location.replace('" + url + newForm + "?ID='+" + newID.substring(1) + ");");
                } else {
                    out.println("location.replace('" + url + newForm + "?ID='+" + newID + ");");
                }
            }
            out.println("</script>");
        }
    }

    if (request.getParameter("jump") != null && request.getParameter("jump").equals("los")) {
        //  out.println("JUMP: " + request.getParameter("jumpType") + "::" + request.getParameter("jumpValue") + "__" + request.getParameter("akt"));

        String form = request.getParameter("jumpTable");

        String guest = "";
        if (title.contains("gast_")) {
            title = title.substring(5);
            guest = "gast_";
        }

        int akt = -1;

        String debug = "debug";

        int filter = 0;

        if (session.getAttribute(title + "filter") != null) {
            filter = ((Integer) session.getAttribute(title + "filter")).intValue();
        }

        //get the filter sql string
        String sql = "";
        try {
            sql = Filter.getFilterSql(request, guest + title);
        } catch (Exception e) {
            sql = "SELECT * FROM " + title;
        }
        //modify sql string
        sql = sql.replace("*", "count(*) c");
        akt = AbstractBase.getIntNative(sql + (sql.contains("WHERE") ? " AND " : " WHERE ") + title + ".ID < " + request.getParameter("akt")) + 1;

        if (akt > 0) {
            if (request.getParameter("jumpType").equals("-1")) {
                try {
                    akt -= Integer.parseInt(request.getParameter("jumpValue"));
                } catch (Exception ex) {
                    ;
                }
            } else if (request.getParameter("jumpType").equals("1")) {
                try {
                    akt += Integer.parseInt(request.getParameter("jumpValue"));
                } catch (Exception ex) {
                    ;
                }
            } else if (request.getParameter("jumpType").equals("0")) {
                try {
                    akt = Integer.parseInt(request.getParameter("jumpValue"));
                } catch (Exception ex) {
                    ;
                }
            }
            akt--;

            try {
                sql = Filter.getFilterSql(request, guest + title);
            } catch (Exception e) {
                sql = "SELECT " + title + ".ID FROM " + title;
            }

            sql = sql.replace("*", title + ".ID");
            id = AbstractBase.getIntNative(sql + " ORDER BY " + title + ".ID LIMIT " + akt + ", 1");

            out.println("<script type=\"text/javascript\">");
            out.println(
                    "location.replace(window.location.protocol+'//'+window.location.hostname+':'+window.location.port+window.location.pathname+'?ID='+"
                    + id + ");");
            out.println("</script>");
        }
    } // ENDE if (springen)

%>

