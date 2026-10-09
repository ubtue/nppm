package de.uni_tuebingen.ub.nppm.db;

import de.uni_tuebingen.ub.nppm.model.*;
import java.math.BigInteger;
import java.util.*;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.persistence.NoResultException;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.json.*;

/**
 * Class for functions which can be applied to all Selektion...- tables in a
 * similar way
 */
public class SelektionDB extends AbstractBase {

    static protected Map<String, String> gastToNonGast = Map.ofEntries(
            Map.entry("gastselektion_amtweihe_einzelbeleg", "selektion_amtweihe"),
            Map.entry("gastselektion_amtweihe_person", "selektion_amtweihe"),
            Map.entry("gastselektion_quellengattung", "selektion_quellengattung"),
            Map.entry("gastselektion_stand", "selektion_stand")
    );

    static public List<Selektion> getList(String selektion) throws Exception {
        return getList(getEntityClassByTableName(selektion));
    }

    static public List<SelektionHierarchy> getListHierarchy(String selektion) throws Exception {
        Class c = getEntityClassByTableName(selektion);

        try ( Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery query = builder.createQuery(c);
            Root root = query.from(c);
            query.select(root);
            // Order is important for sorting before display rendering the hierarchy
            query.orderBy(builder.asc(root.get(SelektionBezeichnung_.BEZEICHNUNG)));
            return session.createQuery(query).setCacheable(true).getResultList();
        }
    }

    static public String getListHierarchyJson(String selektion) throws Exception {
        JSONArray array = new JSONArray();
        List<SelektionHierarchy> list = getListHierarchy(selektion);
        for (SelektionHierarchy entry : list) {
            array.put(entry.toJSONObject());
        }
        return array.toString();
    }

    static public String getNonGastTable(String selektion) {
        return gastToNonGast.get(selektion);
    }

    static public SelektionBezeichnung getByBezeichnung(String selektion, String Bezeichnung) throws Exception {
        Class c = getEntityClassByTableName(selektion);

        try ( Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery query = builder.createQuery(c);
            Root root = query.from(c);
            query.select(root).where(builder.equal(root.get(SelektionBezeichnung_.BEZEICHNUNG), Bezeichnung));
            try {
                return (SelektionBezeichnung) session.createQuery(query).getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        }
    }

    public static String getBezeichnungByID(String id, String tabelle) throws Exception {
        String result = "";

        try ( Session session = getSession()) {
            session.getTransaction().begin();

            String sql = "SELECT Bezeichnung FROM " + tabelle + " WHERE ID= :ID";
            NativeQuery query = session.createNativeQuery(sql);
            query.setParameter("ID", id);
            result = (String) query.getSingleResult();
            session.getTransaction().commit();
        }
        return result;
    }

    public static List<Object> getBezeichnung(String tabelle, String bezeichnung) throws Exception {
        List<Object> results = new ArrayList<>();

        try ( Session session = getSession()) {
            session.getTransaction().begin();

            String sql = "SELECT Bezeichnung FROM " + tabelle + " WHERE Bezeichnung= :bezeichnung";
            NativeQuery query = session.createNativeQuery(sql);
            query.setParameter("bezeichnung", bezeichnung);
            List<Object> rows = query.getResultList();
            results.addAll(rows);
            session.getTransaction().commit();
        }
        return results;
    }

    public static boolean hasBezeichnung(String selektion, String Bezeichnung) throws Exception {
        return !getBezeichnung(selektion, Bezeichnung).isEmpty();
    }

    public static void insertBezeichnung(String tabelle, String bezeichnung) throws Exception {
        try ( Session session = getSession()) {
            session.getTransaction().begin();

            // Zuerst die maximale ID abrufen und um eins erhöhen
            BigInteger maxId = (BigInteger) session.createNativeQuery("SELECT MAX(ID) + 1 FROM " + tabelle).uniqueResult();
            if (maxId == null) {
                maxId = BigInteger.ONE; // Wenn keine Daten vorhanden sind, beginnen Sie mit ID 1.
            }

            // Den INSERT-Befehl mit der generierten ID ausführen
            NativeQuery query = session.createNativeQuery("INSERT INTO " + tabelle + " (ID, Bezeichnung) VALUES (:id, :bezeichnung)");
            query.setParameter("id", maxId);
            query.setParameter("bezeichnung", bezeichnung);
            query.executeUpdate();

            session.getTransaction().commit();
        }
    }

    public static void updateBezeichnung(String tabelle, String bezeichnung, String id) throws Exception {
        try ( Session session = getSession()) {
            session.getTransaction().begin();
            NativeQuery query = session.createNativeQuery("UPDATE " + tabelle + " SET Bezeichnung= :bezeichnung WHERE ID= :id");
            query.setParameter("bezeichnung", bezeichnung);
            query.setParameter("id", id);
            query.executeUpdate();
            session.getTransaction().commit();
        }
    }

    static public boolean isHierarchy(String selektion) {
        try {
            Class c = getEntityClassByTableName(selektion);
            return SelektionHierarchy.class.isAssignableFrom(c);
        } catch (Exception e) {
            // right now we don't have all gast... views registered as entities yet,
            // so we simply return false in this case.
            return false;
        }
    }

    static public void updateParentId(String selektion, int id, Integer parentId) throws Exception {
        String intVal = "NULL";
        if (parentId != null) {
            intVal = parentId.toString();
        }
        String sql = "UPDATE " + selektion + " SET parentId=" + intVal + " WHERE ID=" + id;
        insertOrUpdate(sql);
    }

    static public List<Gastquelle> getAllGastquelle() throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Gastquelle> query = builder.createQuery(Gastquelle.class);
            Root<Gastquelle> root = query.from(Gastquelle.class);
            query.select(root);
            //id -1 an erste stelle
            query.orderBy(
                    builder.asc(
                            builder.selectCase()
                                    .when(builder.equal(root.get("id"), -1), 0)
                                    .otherwise(1)
                    ),
                    builder.asc(root.get("id"))
            );

            return session.createQuery(query).getResultList();
        }
    }
}
