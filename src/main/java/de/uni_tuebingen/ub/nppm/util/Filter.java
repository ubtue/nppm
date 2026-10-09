package de.uni_tuebingen.ub.nppm.util;

import de.uni_tuebingen.ub.nppm.db.DatenbankDB;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import java.math.*;

public class Filter {

    /*
        This function return a Sql String corresponding to the formular and request.
        The Sql String is used to filter entities from the database
    */
    public static String getFilterSql(HttpServletRequest request, String formular) throws Exception {
        Integer filter = 0;
        HttpSession session = request.getSession();
        String filterSql = null;
        //Try to get id from request

        //Try to get filter number from request
        try {
            filter = ((Integer) session.getAttribute(formular + "filter"))
                    .intValue();
        } catch (Exception e) {
            e.printStackTrace();
        }

        filterSql = DatenbankDB.getFilterSql(formular, filter);
        if (filterSql == null) {
            //get result without filter (filter=0)
            filterSql = DatenbankDB.getFilterSql(formular, 0);
        }

        //modify sql string
        String filterParameter = (String) session.getAttribute(formular + "filterParameter");
        if (filterParameter != null) {
            filterSql = filterSql.replace("###", filterParameter);
        }
        filterSql = filterSql.replace("#userid#", "" + ((Integer) session.getAttribute("BenutzerID")).intValue());
        filterSql = filterSql.replace("#groupid#", "" + ((Integer) session.getAttribute("GruppeID")).intValue());

        return filterSql;
    }

    /*
        This function is used to store the filter settings from the request in the session
    */
    public static void setFilter(HttpServletRequest request, String form, JspWriter out) throws Exception {
        HttpSession session = request.getSession(true);
        int filter = 0;
        String filterParameter = "";

        //clear session if no filter is set
        if (session.getAttribute(form + "filterParameter") == null) {
            session.setAttribute(form + "filterParameter", "");
        }

        //get filter setting from the session
        if (session.getAttribute(form + "filter") != null)
            filter = ((Integer)session.getAttribute(form + "filter")).intValue();

        if (session.getAttribute(form + "filterParameter") != null)
            filterParameter = (String) session.getAttribute(form + "filterParameter");

        boolean newFilter = false;
        //store filter settings from the request in the session
        if (request.getParameter("filter") != null && filter != Integer.parseInt(request.getParameter("filter"))) {
            filter = Integer.parseInt(request.getParameter("filter"));
            session.setAttribute(form + "filter", Integer.valueOf(filter));
            newFilter = true;
        }
        if (filterParameter == null && request.getParameter("filterParameter") != null
                || filterParameter != null && !filterParameter.equals(request.getParameter("filterParameter"))) {
            filterParameter = request.getParameter("filterParameter");
            session.setAttribute(form + "filterParameter", filterParameter);
            newFilter = true;
        }
        if (filter == 0) {
            filterParameter = null;
        }
        session.setAttribute(form + "filterParameter", filterParameter);

        //reload if a new filter was set
        if (newFilter && filter != 0) {
            out.println("<script type=\"text/javascript\">location.replace('" + request.getRequestURL() + "')</script>");
        }
    }

    public static int getFirstFilterResult(String filterSql, String formular) throws Exception {
        filterSql = filterSql.replace("*", "min(" + formular + ".ID) m");
        return (Integer) DatenbankDB.getSingleResult(filterSql);
    }

    public static BigInteger countFilterItems(String filterSql) throws Exception {
        String sql = filterSql.replace("*", "count(*) c");
        return (BigInteger) DatenbankDB.getSingleResult(sql);
    }

    public static Integer existIdInFilter(String filterSql, String formular, int id) throws Exception {
        filterSql = filterSql.replace("*", "min(" + formular + ".ID) m");
        filterSql = filterSql + (filterSql.contains("WHERE") ? " AND " : " WHERE ") + formular + ".ID = " + id;
        Integer res = (Integer) DatenbankDB.getSingleResult(filterSql);
        return res;
    }
}
