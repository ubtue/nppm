package de.uni_tuebingen.ub.nppm.servlet.gast;

import org.apache.solr.common.params.MultiMapSolrParams;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.impl.Http2SolrClient;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class SolrServlet extends AbstractGastServlet {
    @Override
    protected String getTitle() {
        return "freie_suche";
    }

    @Override
    protected List<String> getAdditionalCss() {
        List<String> css = super.getAdditionalCss();
        css.add("layout/solr.css");
        return css;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher("solr.jsp");

        String solrBaseUrl = "http://localhost:8984/solr";
        String solrIndex = "einzelbeleg";
        List<String> facets = Arrays.asList("quelle", "belegform", "person", "lemma");
        List<String> types = Arrays.asList("belegform", "kontext", "person", "quelle");
        List<String> sorts = Arrays.asList("score desc", "belegform asc", "quelle asc, seite asc, raster asc");

        String lookfor = request.getParameter("lookfor") != null ? request.getParameter("lookfor") : "";
        String type = request.getParameter("lookfor") != null ? request.getParameter("type") : "belegform";
        String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "score desc";

        Http2SolrClient solr = new Http2SolrClient.Builder(solrBaseUrl).build();

        // For Query parameter definitions, see also:
        // https://solr.apache.org/guide/solr/latest/query-guide/common-query-parameters.html
        Map<String, String[]> queryParamMap = new HashMap<>();
        MultiMapSolrParams.addParam("q", lookfor, queryParamMap);
        MultiMapSolrParams.addParam("df", type, queryParamMap);
        MultiMapSolrParams.addParam("sort", sort, queryParamMap);
        MultiMapSolrParams.addParam("rows", "100", queryParamMap);
        if (!facets.isEmpty()) {
            MultiMapSolrParams.addParam("facet", "true", queryParamMap);
            MultiMapSolrParams.addParam("facet.limit", "10", queryParamMap);
            MultiMapSolrParams.addParam("facet.mincount", "1", queryParamMap);
            MultiMapSolrParams.addParam("facet.field", facets.toArray(String[]::new), queryParamMap);
            for (String facet : facets) {
                if (request.getParameter(facet) != null) {
                    MultiMapSolrParams.addParam("fq", facet + ":\"" + request.getParameter(facet) + "\"", queryParamMap);
                }
            }
        }

        MultiMapSolrParams queryParams = new MultiMapSolrParams(queryParamMap);

        QueryResponse solrResponse = solr.query(solrIndex, queryParams);

        request.setAttribute("solrParams", queryParams);
        request.setAttribute("solrResponse", solrResponse);
        request.setAttribute("facets", facets);
        request.setAttribute("types", types);
        request.setAttribute("sorts", sorts);

        rd.include(request, response);
    }
}
