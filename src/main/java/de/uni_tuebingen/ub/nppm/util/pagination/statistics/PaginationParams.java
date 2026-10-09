package de.uni_tuebingen.ub.nppm.util.pagination.statistics;

import de.uni_tuebingen.ub.nppm.util.Utils;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

public class PaginationParams {

    private int currentPage = 1;
    private int recordsPerPage = 20;
    private String sort = "";
    private String jumpToID = "";
    private Map<String, String> filters = new HashMap<>();

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getRecordsPerPage() {
        return recordsPerPage;
    }

    public void setRecordsPerPage(int recordsPerPage) {
        this.recordsPerPage = recordsPerPage;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getJumpToID() {
        return jumpToID;
    }

    public void setJumpToID(String jumpToID) {
        this.jumpToID = jumpToID;
    }

    public String getFilter(String filter) {
        String res = this.getFilters().get(filter);
        if(res == null)
            return "";
        else
            return res;
    }

    public Map<String, String> getFilters() {
        return filters;
    }

    public void addFilter(String key, String value) {
        filters.put(key, value);
    }

    public String buildUrl(HttpServletRequest request, String basePath, Integer overridePage, String overrideSort) {
        StringBuilder url = new StringBuilder();
        if (request != null) {
            String base = Utils.getBaseUrl(request);
            if (!base.endsWith("/")) {
                base += "/";
            }
            url.append(base);
        }

         // Füge "gast/" standardmäßig hinzu
        url.append("gast/");

        if (basePath != null) {
            if (basePath.startsWith("/")) {
                basePath = basePath.substring(1);
            }
            url.append(basePath);
        }

        url.append("?");

        if (jumpToID != null && !jumpToID.isEmpty()) {
            url.append("jumpToID=").append(jumpToID).append("&");
        }

        String effectiveSort = overrideSort != null ? overrideSort : sort;
        if (effectiveSort != null && !effectiveSort.isEmpty()) {
            url.append("sort=").append(effectiveSort).append("&");
        }

        url.append("page=stat&"); 

        String filterTitle = getFilter("filterTitle");
        if (filterTitle != null && !filterTitle.isEmpty()) {
            url.append("filterTitle=").append(filterTitle).append("&");
        }

        url.append("recordsPerPage=").append(recordsPerPage).append("&");
        url.append("currentPage=").append(overridePage != null ? overridePage : currentPage);

        return url.toString();
    }
}
