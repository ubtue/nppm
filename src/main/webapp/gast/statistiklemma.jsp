<%@page import="de.uni_tuebingen.ub.nppm.util.pagination.statistics.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.db.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.*"%>
<%@page import="java.util.*"%>

<link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/stat.css")%>" type="text/css">

<%
    PaginationParams params = new PaginationParams();

    /*Set filterTitle for Quelle*/
    if (request.getParameter("filterTitle") != null) {
        params.addFilter("filterTitle", request.getParameter("filterTitle"));
    }
    /*Set Sort Type*/
    if (request.getParameter("sort") != null) {
        params.setSort(request.getParameter("sort"));
    }
    /*Set jumpToID for Quelle*/
    if (request.getParameter("jumpToID") != null) {
        params.setJumpToID(request.getParameter("jumpToID"));
    }
    /*
    Calculation for pagination
     */
    if (request.getParameter("currentPage") != null) {
        params.setCurrentPage(Integer.parseInt(request.getParameter("currentPage")));
    } else {
        params.setCurrentPage(1);
    }

    if (request.getParameter("recordsPerPage") != null) {
        params.setRecordsPerPage(Integer.parseInt(request.getParameter("recordsPerPage")));
    } else {
        params.setRecordsPerPage(Constants.RECORDS_PER_PAGE);
    }

    int rows = LemmaDB.countStat(params.getFilter("filterTitle")).intValue();

    //row count is 1 if users performs id search
    if (params.getJumpToID() != null && params.getJumpToID().length() > 0) {
        rows = 1;
    }

    int recordsPerPage = params.getRecordsPerPage();
    int nOfPages = rows / recordsPerPage;
    if (rows % recordsPerPage > 0) {
        nOfPages++;
    }

    List<MghLemma> lst = LemmaDB.getList(params);
%>

<div class="statistica">
    <p>
    <h3 class="ut-heading ut-heading--h3"><% Language.printTextfield(out, session, "statlemma", "ListeDerLemmataAnzahl");%></h3>
    <% PaginationRenderer.printPagination(out, nOfPages, params, "lemma", session, request); %>
    <table id="stat1" class="ut-table ut-table--striped ut-table--striped--color-primary-3 statTable">
        <thead class="ut-table__header ">
        <th class="ut-table__item ut-table__header__item" scope="col">
            <b><% Language.printTextfield(out, session, "mgh_lemma", "Titel");%></b>
            <form method="GET" style="display: flex; align-items: center;">
                <jsp:include page="../inc.erzeugeFormular.jsp">
                    <jsp:param name="Formular" value="statistik"/>
                    <jsp:param name="Datenfeld" value="filterTitle"/>
                    <jsp:param name="ValueAutomcomplete" value='<%=params.getFilter("filterTitle")%>'/>
                </jsp:include>
                <input name="page" type="hidden" value="stat"/>
                <input name="sort" type="hidden" value='<%=params.getSort()%>'/>
                <button class="ut-btn ut-btn--color-primary-2" type="submit" style="margin-left: 2px;">
                    <% Language.printTextfield(out, session, "jump", "Los");%>
                </button>
            </form>

            <%= PaginationRenderer.htmlSortTitleUp(params, "lemma", session, request)%>
            <%= PaginationRenderer.htmlSortTitleDown(params, "lemma", session, request)%>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <b><% Language.printTextfield(out, session, "stat", "AnzahlBelege");%></b>
            <br>
            <%= PaginationRenderer.htmlSortBelegeUp(params, "lemma", session, request)%>
            <%= PaginationRenderer.htmlSortBelegeDown(params, "lemma", session, request)%>
        </th>
        </thead>
        <tbody class="ut-table__body">
            <% for (MghLemma l : lst) {%>
            <tr class="ut-table__row">
                <td class="ut-table__item ut-table__body__item" width="80%">
                    <a class="ut-link" href="<%= Utils.getBaseUrl(request) + "/gast/lemma?ID=" + l.getId()%>">
                        <%= Utils.escapeHTML(l.getMghLemma())%>
                    </a>
                </td>
                <td width="20%">
                    <%= LemmaDB.getEinzelbelegeCount(l.getId())%>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <% PaginationRenderer.printPagination(out, nOfPages, params, "lemma", session, request);%>
</p>
</div>
