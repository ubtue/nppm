package de.uni_tuebingen.ub.nppm.servlet;

import de.uni_tuebingen.ub.nppm.db.DatenbankDB;
import de.uni_tuebingen.ub.nppm.exception.IdInvalidException;
import de.uni_tuebingen.ub.nppm.util.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class AbstractServlet extends HttpServlet {

    protected long startTimeMillis;
    protected long endTimeMillis;
    protected long renderTimeMillis;

    protected HttpServletRequest currentRequest;
    protected HttpServletResponse currentResponse;

    protected void initRequest(HttpServletRequest request) throws Exception {
        Language.setLanguage(request);

    }
    protected void addResponseHeader(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher(getHeaderTemplate());
        request.setAttribute("title", DatenbankDB.getLabel(Language.getLanguage(request), getTitle(), "Titel"));
        // request.setAttribute("navigationTitle", getNavigationTitle());
        request.setAttribute("navigationTitle", getDynamicNavigationTitle(request, response));

        ServletContext context = request.getServletContext();

        // --- CSS ---
        List<String> cssList = getAdditionalCss();
        StringBuilder additionalCss = new StringBuilder();
        for (String cssPath : cssList) {
            String href = buildVersionedAssetUrl(request, context, cssPath);
            additionalCss
                    .append("<link rel=\"stylesheet\" href=\"")
                    .append(href)
                    .append("\" type=\"text/css\">\n");
        }
        request.setAttribute("additionalCss", additionalCss.toString());

        // --- JavaScript ---
        List<String> jsList = getAdditionalJavaScript();
        StringBuilder additionalJs = new StringBuilder();
        for (String jsPath : jsList) {
            String src = buildVersionedAssetUrl(request, context, jsPath);
            additionalJs
                    .append("<script src=\"")
                    .append(src)
                    .append("\" type=\"text/javascript\"></script>\n");
        }
        request.setAttribute("additionalJs", additionalJs.toString());

        rd.include(request, response);
    }


    /*
    Gibt für einen gegebenen asset-Pfad entweder unverändert die externe URL
    zurück (wenn er mit "http" beginnt) oder baut die Versionierung per
    Timestamp aus LastModified zusammen.
     */
    private String buildVersionedAssetUrl(HttpServletRequest request,
            ServletContext context,
            String assetPath) throws Exception {
        // Externe URLs unverändert übernehmen
        if (assetPath.startsWith("http://") || assetPath.startsWith("https://")) {
            return assetPath;
        }

        // Relativen Pfad in absoluten umwandeln
        String resolvedPath;
        if (assetPath.startsWith("/")) {
            resolvedPath = assetPath;
        } else {
            String current = request.getServletPath();      // z.B. "/seite/index.jsp"
            resolvedPath = current.replaceAll("/[^/]*$", "/") + assetPath;
        }

        // Versions-URL per Utils
        return Utils.getVersionedHref(request, context, resolvedPath);
    }

    protected void addResponseFooter(HttpServletRequest request, HttpServletResponse response) throws Exception {
        RequestDispatcher rd = request.getRequestDispatcher(getFooterTemplate());
        rd.include(request, response);
    }

    protected List<String> getAdditionalCss() {
        return new ArrayList<>();
    }

    protected List<String> getAdditionalJavaScript() {
        return new ArrayList<>();
    }

    abstract protected String getTitle();

    // Methode mit Parametern benoetigt für dynamische Titel angabe bei sharedHtmlServlet
    protected String getTitle(HttpServletRequest request, HttpServletResponse response) {
        return getTitle();
    }

    protected String getNavigationTitle() {
        return "";
    }

   protected String getNavigationTitle(HttpServletRequest request, HttpServletResponse response) {
        // Standardmäßig rufen wir die einfache Methode auf
        return getNavigationTitle();
    }

    // Wird im Header-Aufbau benutzt
    protected String getDynamicNavigationTitle(HttpServletRequest request, HttpServletResponse response) {
        return getNavigationTitle(request, response);
    }

    abstract protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception, IdInvalidException;

    abstract protected String getHeaderTemplate();

    abstract protected String getFooterTemplate();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws Exception, IdInvalidException {
        startTimeMillis = System.currentTimeMillis();
        this.currentRequest = request;
        this.currentResponse = response;
        // Since the header is very large using the UB navigation,
        // we need to increase the buffer size so no packages will be sent
        // during rendering the navigation. Else it would not be possible to
        // send a redirect when rendering the content, e.g. if "gast/einzelbeleg" page is called
        // without an ID.
        response.setBufferSize(1024*1024);
        request.setCharacterEncoding("UTF-8");
        initRequest(request);
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        addResponseHeader(request, response);
        generatePage(request, response);
        endTimeMillis = System.currentTimeMillis();
        renderTimeMillis = endTimeMillis - startTimeMillis;
        request.setAttribute("renderTimeMillis", renderTimeMillis);
        addResponseFooter(request, response);
    }

    protected void doHelper(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        try {
            processRequest(request, response);
        } catch (IdInvalidException e) {
            throw new ServletException(e);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHelper(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHelper(request, response);
    }
}
