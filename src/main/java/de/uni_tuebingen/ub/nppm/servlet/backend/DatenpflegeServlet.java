package de.uni_tuebingen.ub.nppm.servlet.backend;

import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DatenpflegeServlet extends AbstractBackendServlet {

    @Override
    protected String getTitle() {
        return "datenpflege";
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher("datenpflege.jsp");
        rd.include(request, response);
    }

    @Override
    protected List<String> getAdditionalCss() {
        List<String> css = super.getAdditionalCss();
        css.add("webjars/datatables/2.3.7/css/dataTables.dataTables.min.css");
        css.add("webjars/datatables-buttons/3.2.6/css/buttons.dataTables.min.css");
        return css;
    }

    @Override
    protected List<String> getAdditionalJavaScript() {
        List<String> js = super.getAdditionalJavaScript();
        js.add("webjars/datatables/2.3.7/js/dataTables.min.js");
        js.add("webjars/datatables-buttons/3.2.6/js/dataTables.buttons.min.js");
        js.add("webjars/datatables-buttons/3.2.6/js/buttons.dataTables.min.js");
        js.add("webjars/datatables-buttons/3.2.6/js/buttons.html5.min.js");
        js.add("webjars/jszip/3.10.1/jszip.js");
        return js;
    }
}
