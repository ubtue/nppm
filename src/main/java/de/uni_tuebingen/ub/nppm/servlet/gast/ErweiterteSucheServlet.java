package de.uni_tuebingen.ub.nppm.servlet.gast;

import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ErweiterteSucheServlet extends AbstractGastServlet  {
    @Override
    protected String getTitle() {
        return "freie_suche"; // "Impressum" does not yet exist in DB
    }

    @Override
    protected String getNavigationTitle() {
        return "freie_suche";
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher("freie_suche.jsp");
        rd.include(request, response);
    }

    @Override
    protected List<String> getAdditionalCss() {
        List<String> css = super.getAdditionalCss();
        return css;
    }

    @Override
    protected List<String> getAdditionalJavaScript() {
        List<String> js = super.getAdditionalJavaScript();
        js.add("../layout/BubbleTooltips.js");
        return js;
    }


}
