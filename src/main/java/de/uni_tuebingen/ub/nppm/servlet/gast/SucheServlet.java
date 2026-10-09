package de.uni_tuebingen.ub.nppm.servlet.gast;

import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SucheServlet extends AbstractGastServlet {

    @Override
    protected String getNavigationTitle() {
        return "einfaches_ergebnis";
    }

    @Override
    protected String getTitle() {
        return "einfaches_ergebnis";
    }

    @Override
    protected List<String> getAdditionalCss() {
        List<String> css = super.getAdditionalCss();
        css.add("layout/mktree.css");
        return css;
    }

    @Override
    protected List<String> getAdditionalJavaScript() {
        List<String> js = super.getAdditionalJavaScript();
        js.add("../mktree.js");
        return js;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher("einfaches_ergebnis.jsp");
        rd.include(request, response);
    }
}
