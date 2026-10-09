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

    int rows = QuelleDB.countStat(params.getFilter("filterTitle")).intValue();

    //row count is 1 if users performs id search
    if (params.getJumpToID() != null && params.getJumpToID().length() > 0) {
        rows = 1;
    }

    int recordsPerPage = params.getRecordsPerPage();
    int nOfPages = rows / recordsPerPage;
    if (rows % recordsPerPage > 0) {
        nOfPages++;
    }

    List<Quelle> lst = QuelleDB.getList(params);
%>

<div class="statistica">
    <p>
    <h3 class="ut-heading ut-heading--h3"><% Language.printTextfield(out, session, "stat", "ListeDerQuellenAnzahl");%></h3>
    <% PaginationRenderer.printPagination(out, nOfPages, params, "quelle", session, request); %>
    <table id="stat1" class="ut-table ut-table--striped ut-table--striped--color-primary-3 statTable">
        <thead class="ut-table__header ">
        <th class="ut-table__item ut-table__header__item" scope="col">
            <b><% Language.printTextfield(out, session, "stat", "QuellenTitel");%></b>
            <form method="GET" style="display: flex; align-items: center;">
                <input class="ut-form__input ut-form__field" name="filterTitle" type="text" size="40" value='<%=params.getFilter("filterTitle")%>' placeholder='<% Language.printTextfield(out, session, "stat", "TitelFilter");%>' aria-required="true" style="width: 400px; margin-right: 2px;"/>
                <input name="page" type="hidden" value="stat"/>
                <input name="sort" type="hidden" value='<%=params.getSort()%>'/>
                <button class="ut-btn ut-btn--color-primary-2" type="submit" style="margin-left: 2px;">
                    <% Language.printTextfield(out, session, "jump", "Los");%>
                </button>
            </form>

            <%= PaginationRenderer.htmlSortTitleUp(params, "quelle", session, request)%>
            <%= PaginationRenderer.htmlSortTitleDown(params, "quelle", session, request)%>
        </th>
        <th class="ut-table__item ut-table__header__item" scope="col">
            <b><% Language.printTextfield(out, session, "stat", "AnzahlBelege");%></b>
            <br>
            <%= PaginationRenderer.htmlSortBelegeUp(params, "quelle", session, request)%>
            <%= PaginationRenderer.htmlSortBelegeDown(params, "quelle", session, request)%>
        </th>
        </thead>
        <tbody class="ut-table__body">
            <% for (Quelle q : lst) {%>
            <tr class="ut-table__row">
                <td class="ut-table__item ut-table__body__item" width="80%">
                    <a class="ut-link" href="<%= Utils.getPidUrl(request, q.getPersistentIdentifier())%>">
                        <%= Utils.escapeHTML(q.getBezeichnung())%>
                    </a>
                </td>
                <td width="20%">
                    <%= QuelleDB.getEinzelbelegeCount(q.getId())%>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <% PaginationRenderer.printPagination(out, nOfPages, params, "quelle", session, request);%>
</p>
</div>
