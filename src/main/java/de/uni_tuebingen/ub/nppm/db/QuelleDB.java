package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import java.util.stream.Stream;
import de.uni_tuebingen.ub.nppm.model.*;
import de.uni_tuebingen.ub.nppm.model.Content.Context;
import de.uni_tuebingen.ub.nppm.util.pagination.statistics.PaginationParams;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;

public class QuelleDB extends AbstractBase {

    public static final String SUBSELECT_PUBLIC_QUELLE_IDS = "SELECT ID FROM quelle WHERE ZuVeroeffentlichen=1";
    public static final String ORDER_BY_PUBLIC_QUELLE = " ORDER BY quelle.Bezeichnung, quelle.ID ASC";
    public static final String SELECT_PUBLIC_QUELLEN = "SELECT * FROM quelle WHERE ZuVeroeffentlichen=1 " + ORDER_BY_PUBLIC_QUELLE;

    public static List<Quelle> getList() throws Exception {
        return getList(Quelle.class);
    }

    private static Query getQueryPublic(final Session session) throws Exception {
        NativeQuery query = session.createNativeQuery(SELECT_PUBLIC_QUELLEN);
        query.addEntity(Quelle.class);
        return query;
    }

    public static List<Quelle> getListPublic() throws Exception {
        try (Session session = getSession()) {
            return getQueryPublic(session).getResultList();
        }
    }

    public static Stream<Quelle> getStreamPublic(final Session session) throws Exception {
        return getQueryPublic(session).getResultStream();
    }

    public static List<Quelle> getList(PaginationParams params) throws Exception {
        String jumpToID = params.getJumpToID();
        String sort = params.getSort();
        String filterTitle = params.getFilters().get("filterTitle");
        Integer currentPage = params.getCurrentPage();
        Integer recordsPerPage = params.getRecordsPerPage();
        if (filterTitle == null) filterTitle = "";
        try (Session session = getSession()) {
            String q = "";
            if (jumpToID != null && jumpToID.length() > 0) {
                Query query;
                q = "FROM quelle q WHERE q.zuVeroeffentlichen = :zuV AND q.id = :id";
                query = session.createQuery(q);
                query.setParameter("id", Integer.valueOf(jumpToID));
                query.setParameter("zuV", 1);
                return query.list();
            } else {
                Integer start = null;
                if (currentPage != null && recordsPerPage != null) {
                    start = currentPage * recordsPerPage - recordsPerPage;
                }

                if (sort.startsWith("title")) {
                    q = "SELECT * FROM quelle q WHERE q.zuVeroeffentlichen = :zuV AND q.bezeichnung LIKE :bez "
                            + "ORDER BY q.bezeichnung " + (sort.equals("titleDown") ? "DESC" : "ASC");
                } else if (sort.startsWith("belege")) {
                    //SQL Abfrage mit Unterabfrage
                    q = "SELECT * FROM quelle q WHERE q.zuVeroeffentlichen = :zuV AND q.bezeichnung LIKE :bez "
                            + "ORDER BY (SELECT COUNT(e.id) FROM einzelbeleg e WHERE e.QuelleID = q.id) " + (sort.equals("belegeDown") ? "DESC" : "ASC");
                } else {
                    q = "SELECT * FROM quelle q WHERE q.zuVeroeffentlichen = :zuV AND q.bezeichnung LIKE :bez";
                }

                Query<Quelle> queryNative = session.createNativeQuery(q, Quelle.class);
                queryNative.setFirstResult(start);
                queryNative.setMaxResults(recordsPerPage);
                queryNative.setParameter("bez", "%" + filterTitle + "%");
                queryNative.setParameter("zuV", 1);
                return queryNative.getResultList();
            }
        }
    }

    public static Long countStat(String filterTitle) throws Exception {
        try (Session session = getSession()) {
            Query query = session.createQuery("SELECT count(*) FROM Quelle q WHERE q.zuVeroeffentlichen = :zuV AND q.bezeichnung like :bez");
            query.setParameter("bez", "%" + filterTitle + "%");
            query.setParameter("zuV", 1);
            return (Long) query.uniqueResult();
        }
    }

    public static Long getEinzelbelegeCount(Integer quelleID) throws Exception {
        try (Session session = getSession()) {
            String query = "SELECT COUNT(e) FROM Einzelbeleg e WHERE e.quelle.id = :quelleId";
            Query queryObj = session.createQuery(query);
            queryObj.setParameter("quelleId", quelleID);
            return (Long) queryObj.uniqueResult();
        }
    }

    public static Quelle getFirstPublicQuelle() throws Exception {
        try (Session session = getSession()) {
            Query query = getQueryPublic(session);
            query.setMaxResults(1);
            return (Quelle) query.getSingleResult();
        }
    }

    public static Integer getNextPublicQuelleID(int id) throws Exception {
        try (Session session = getSession()) {
            String sql
                    = "WITH Bounds AS ( "
                    + "  SELECT MIN(ID) AS minID, MAX(ID) AS maxID "
                    + "  FROM quelle "
                    + "  WHERE zuVeroeffentlichen = 1 "
                    + "), "
                    + "Next AS ( "
                    + "  SELECT ID "
                    + "  FROM quelle "
                    + "  WHERE zuVeroeffentlichen = 1 AND ID >= :inputId "
                    + "  ORDER BY ID ASC "
                    + "  LIMIT 1 "
                    + ") "
                    + "SELECT "
                    + "  CASE "
                    + "    WHEN :inputId IS NULL OR :inputId < (SELECT minID FROM Bounds) THEN (SELECT minID FROM Bounds) "
                    + "    WHEN :inputId > (SELECT maxID FROM Bounds) THEN (SELECT maxID FROM Bounds) "
                    + "    ELSE (SELECT ID FROM Next) "
                    + "  END";

            NativeQuery<Integer> query = session.createNativeQuery(sql);
            query.setParameter("inputId", id);
            Integer result = query.uniqueResult();

            return result;
        }
    }

    public static Quelle getById(int id) throws Exception {
        return AbstractBase.getById(id, Quelle.class);
    }

    public static List<Quelle> searchByFileName(String filename, Context fileType) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Quelle> criteria = builder.createQuery(Quelle.class);
            Root quelle = criteria.from(Quelle.class);
            criteria.select(quelle);
            if (fileType == Context.QUELLENKOMMENTAR) {
                criteria.where(builder.equal(quelle.get(Quelle_.QUELLEN_KOMMENTAR_DATEI), filename));
            } else if (fileType == Context.UEBERLIEFERUNGSKOMMENTAR) {
                criteria.where(builder.equal(quelle.get(Quelle_.UEBERLIEFERUNGS_KOMMENTAR_DATEI), filename));
            }

            List<Quelle> res = session.createQuery(criteria).getResultList();
            return res;
        }
    }

    public static void saveOrUpdate(Quelle quelle) throws Exception {
        try (Session session = getSession()) {
            session.getTransaction().begin();
            session.saveOrUpdate(quelle);
            session.getTransaction().commit();
        }
    }

    public static List<Integer> getAllPublicQuellenIds() throws Exception {
        try (Session session = getSession()) {
            String sql = "SELECT ID FROM quelle WHERE ID IN (" + SUBSELECT_PUBLIC_QUELLE_IDS + ") " + ORDER_BY_PUBLIC_QUELLE;
            return session.createNativeQuery(sql).getResultList();
        }
    }

}//end Class
