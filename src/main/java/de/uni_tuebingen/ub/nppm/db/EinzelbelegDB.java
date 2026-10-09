package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;
import de.uni_tuebingen.ub.nppm.util.Constants;
import de.uni_tuebingen.ub.nppm.util.LemmaKorrBelegRow;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Stream;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.hibernate.query.NativeQuery;

public class EinzelbelegDB extends AbstractBase {
    /*
        Exclude Einzelbelege that are linked to a MGHLemma with Constants.forbiddenLemmaSubstring in Frontend
    */
    public static final String SUBSELECT_HIDDEN_EINZELBELEG_IDS = "SELECT DISTINCT EinzelbelegID FROM einzelbeleg_hatmghlemma WHERE MGHLemmaID IN (" + LemmaDB.SUBSELECT_HIDDEN_MGHLEMMA_IDS + ")";
    public static final String SUBSELECT_PUBLIC_EINZELBELEG_IDS = "SELECT ID FROM einzelbeleg WHERE QuelleID IN (" + QuelleDB.SUBSELECT_PUBLIC_QUELLE_IDS + ") AND ID NOT IN (" + SUBSELECT_HIDDEN_EINZELBELEG_IDS + ")";
    public static final String ORDER_BY_PUBLIC_EINZELBELEG = " ORDER BY einzelbeleg.Belegform ASC, einzelbeleg.ID ASC";
    public static final String SELECT_PUBLIC_EINZELBELEGE = "SELECT * FROM einzelbeleg WHERE QuelleID IN (" + QuelleDB.SUBSELECT_PUBLIC_QUELLE_IDS + ") AND ID NOT IN (" + SUBSELECT_HIDDEN_EINZELBELEG_IDS + ") " + ORDER_BY_PUBLIC_EINZELBELEG;

    public static Einzelbeleg getById(int id) throws Exception {
        return AbstractBase.getById(id, Einzelbeleg.class);
    }

    public static List<Einzelbeleg> getList() throws Exception {
        return getList(Einzelbeleg.class);
    }

    private static Query getQueryPublic(final Session session) throws Exception {
        NativeQuery query = session.createNativeQuery(SELECT_PUBLIC_EINZELBELEGE);
        query.addEntity(Einzelbeleg.class);
        return query;
    }

    public static List<Einzelbeleg> getListPublic() throws Exception {
        try (Session session = getSession()) {
            return getQueryPublic(session).getResultList();
        }
    }

    public static Stream<Einzelbeleg> getStreamPublic(final Session session) throws Exception {
        return getQueryPublic(session).getResultStream();
    }

    public static List<EinzelbelegHatFunktion_MM> getListFunktion() throws Exception {
        return getList(EinzelbelegHatFunktion_MM.class);
    }

    public static List<EinzelbelegTextkritik> getListTextKritik() throws Exception {
        return getList(EinzelbelegTextkritik.class);
    }

    public static Einzelbeleg getFirstPublicEinzelbeleg() throws Exception {
        try (Session session = getSession()) {
            Query query = getQueryPublic(session);
            query.setMaxResults(1);
            return (Einzelbeleg) query.getSingleResult();
        }
    }

    /**
     * Liefert ein Predicate, das alle Einzelbelege ausschließt, die mit
     * mindestens einem MghLemma verknüpft sind, dessen Text den Substring
     * Constants.forbiddenLemmaSubstring enthält.
     *
     * @param root die Root-Entität Einzelbeleg
     * @param cb der CriteriaBuilder
     * @param query die umgebende CriteriaQuery (oder Subquery)
     * @return ein Predicate, das NOT EXISTS (Subquery) umsetzt
     */
    private static Predicate excludeInvalidLemmas(Root<Einzelbeleg> root,
            CriteriaBuilder cb,
            CriteriaQuery<?> query) {
        Subquery<Integer> sq = query.subquery(Integer.class);
        Root<Einzelbeleg> subRoot = sq.correlate(root);
        Join<Einzelbeleg, MghLemma> jm = subRoot.join("mghLemma");
        sq.select(subRoot.get("id"))
                .where(cb.like(jm.get("mghLemma"), "%"+Constants.forbiddenLemmaSubstring+"%"));
        return cb.not(cb.exists(sq));
    }

    public static Integer getNextPublicEinzelbeleg(int id) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();

            // 1. Die kleinste und größte veröffentlichte ID holen
            CriteriaQuery<Object[]> boundsQuery = criteriaBuilder.createQuery(Object[].class);
            Root<Einzelbeleg> boundRoot = boundsQuery.from(Einzelbeleg.class);
            boundsQuery.multiselect(
                    criteriaBuilder.min(boundRoot.get("id")),
                    criteriaBuilder.max(boundRoot.get("id"))
            ).where(criteriaBuilder.equal(boundRoot.get("quelle").get("zuVeroeffentlichen"), 1),
                    excludeInvalidLemmas(boundRoot, criteriaBuilder, boundsQuery)
            );

            Query<Object[]> boundsQueryResult = session.createQuery(boundsQuery);
            Object[] boundsResult = boundsQueryResult.uniqueResult();
            Integer minId = (Integer) boundsResult[0];
            Integer maxId = (Integer) boundsResult[1];

            // Wenn keine öffentlichen Einzelbelege existieren, gib null zurück
            if (minId == null || maxId == null) {
                return null;
            }

            // 2. Prüfen, ob die ID ungültig oder negativ ist
            if (id < 0) {
                return minId;  // Wenn ID ungültig oder negativ ist, gebe die kleinste public ID zurück
            }

            // 3. Prüfen, ob die ID kleiner als die kleinste public ID ist
            if (id < minId) {
                return minId;  // ID ist kleiner als die kleinste public ID, daher gebe die kleinste zurück
            }

            // 4. Prüfen, ob die ID größer als die größte public ID ist
            if (id > maxId) {
                return maxId;  // ID ist größer als die größte public ID, daher gebe die größte zurück
            }

            // 5. Prüfen, ob die übergebene ID veröffentlicht ist
            CriteriaQuery<Integer> criteriaQuery = criteriaBuilder.createQuery(Integer.class);
            Root<Einzelbeleg> root = criteriaQuery.from(Einzelbeleg.class);
            criteriaQuery.select(root.get("id"))
                    .where(
                            criteriaBuilder.equal(root.get("id"), id),
                            criteriaBuilder.equal(root.get("quelle").get("zuVeroeffentlichen"), 1),
                            excludeInvalidLemmas(root, criteriaBuilder, criteriaQuery)
                    );

            Query<Integer> query = session.createQuery(criteriaQuery);
            Integer resultId = query.uniqueResult();

            // 6. Wenn die ID veröffentlicht ist, gebe sie zurück
            if (resultId != null) {
                return resultId;
            }

            // 7. Wenn die ID nicht veröffentlicht ist, suche die nächste veröffentlichte ID
            CriteriaQuery<Integer> nextCriteriaQuery = criteriaBuilder.createQuery(Integer.class);
            Root<Einzelbeleg> nextRoot = nextCriteriaQuery.from(Einzelbeleg.class);
            nextCriteriaQuery.select(nextRoot.get("id"))
                    .where(
                            criteriaBuilder.greaterThan(nextRoot.get("id"), id),
                            criteriaBuilder.equal(nextRoot.get("quelle").get("zuVeroeffentlichen"), 1),
                            excludeInvalidLemmas(nextRoot, criteriaBuilder, nextCriteriaQuery)
                    )
                    .orderBy(criteriaBuilder.asc(nextRoot.get("id")));

            Query<Integer> nextQuery = session.createQuery(nextCriteriaQuery);
            nextQuery.setMaxResults(1);  // Nur das nächste Ergebnis zurückgeben

            // 8. Die ID des nächsten veröffentlichten Einzelbelegs zurückgeben
            Integer nextId = nextQuery.uniqueResult();
            return nextId != null ? nextId : maxId;  // Falls keine ID gefunden wurde, gebe die größte public ID zurück
        }
    }

    public static void insertBySql(String sql) throws Exception {
        insertOrUpdate(sql);
    }

    //gibt eine Liste von Einzelbelege die die gleiche Belegform haben
    public static List<Einzelbeleg> getListByBelegform(String belegform) {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Einzelbeleg> criteria = builder.createQuery(Einzelbeleg.class);
            Root<Einzelbeleg> root = criteria.from(Einzelbeleg.class);

            criteria.select(root)
                    .where(builder.equal(root.get("belegform"), belegform));

            Query<Einzelbeleg> query = session.createQuery(criteria);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving Einzelbeleg list by belegform: " + belegform, e);
        }
    }

    public static void insertLemma(String einzelbelegId, String mghLemmaId) throws Exception {
        String sql = "INSERT INTO einzelbeleg_hatmghlemma (EinzelbelegID, MGHLemmaID) VALUES (" + einzelbelegId + ", " + mghLemmaId + ")";
        insertOrUpdate(sql);
    }

    public static void deleteLemma(String einzelbelegId, String mghLemmaId) throws Exception {
        String sql = "DELETE FROM einzelbeleg_hatmghlemma WHERE EinzelbelegID = \"" + einzelbelegId + "\" AND mghLemmaId = \"" + mghLemmaId + "\"";
        insertOrUpdate(sql);
    }

    public static void insertNamenkommentar(String einzelbelegId, String namenkommentarId) throws Exception {
        String sql = "INSERT INTO einzelbeleg_hatnamenkommentar (EinzelbelegID, NamenkommentarID) VALUES (" + einzelbelegId + ", " + namenkommentarId + ")";
        insertOrUpdate(sql);
    }

    public static void insertFunktion(String einzelbelegId, String funktionID) throws Exception {
        String sql = "INSERT INTO einzelbeleg_hatfunktion (EinzelbelegID, FunktionID) VALUES (" + einzelbelegId + ", " + funktionID + ")";
        insertOrUpdate(sql);
    }

    public static List<EinzelbelegHatFunktion_MM> getListEinzelbelegHatFunktion(int funktionId) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<EinzelbelegHatFunktion_MM> query = builder.createQuery(EinzelbelegHatFunktion_MM.class);
            Root<EinzelbelegHatFunktion_MM> root = query.from(EinzelbelegHatFunktion_MM.class);

            query.select(root);
            // Erstelle ein Predicate für das FunktionID-Feld
            Predicate functionIdPredicate = builder.equal(root.get("funktion").get("id"), funktionId);
            query.where(functionIdPredicate);

            return session.createQuery(query).getResultList();
        }
    }

    public static List<EinzelbelegHatAmtWeihe_MM> getListEinzelbelegHatAmtWeihe(int einzelbelegId) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<EinzelbelegHatAmtWeihe_MM> query = builder.createQuery(EinzelbelegHatAmtWeihe_MM.class);
            Root<EinzelbelegHatAmtWeihe_MM> root = query.from(EinzelbelegHatAmtWeihe_MM.class);

            query.select(root);
            // Erstelle ein Predicate für das FunktionID-Feld
            Predicate functionIdPredicate = builder.equal(root.get("einzelbeleg").get("id"), einzelbelegId);
            query.where(functionIdPredicate);

            return session.createQuery(query).getResultList();
        }
    }

    public static List<EinzelbelegHatStand> getListEinzelbelegHatStand(int einzelbelegId) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<EinzelbelegHatStand> query = builder.createQuery(EinzelbelegHatStand.class);
            Root<EinzelbelegHatStand> root = query.from(EinzelbelegHatStand.class);

            query.select(root);
            // Erstelle ein Predicate für das FunktionID-Feld
            Predicate functionIdPredicate = builder.equal(root.get("einzelbeleg").get("id"), einzelbelegId);
            query.where(functionIdPredicate);

            return session.createQuery(query).getResultList();
        }
    }

    public static List<Integer> getAllPublicEinzelbelegIds() throws Exception {
        try (Session session = getSession()) {
            String sql = SUBSELECT_PUBLIC_EINZELBELEG_IDS + ORDER_BY_PUBLIC_EINZELBELEG;
            return session.createNativeQuery(sql).getResultList();
        }
    }

    public static Map<String, Integer> getAllBelegInitials() throws Exception {
        try (Session session = getSession()) {
            String sql = "SELECT UPPER(LEFT(m.MGHLemma, 1)) AS initial, " +
                "SUM(CASE WHEN e.MGHLemmaKorrigiert = 0 OR e.MGHLemmaKorrigiert IS NULL THEN 1 ELSE 0 END) AS todo " +
                "FROM einzelbeleg e " +
                "LEFT OUTER JOIN einzelbeleg_hatmghlemma em ON e.ID = em.EinzelbelegID " +
                "LEFT OUTER JOIN mgh_lemma m ON m.ID = em.MGHLemmaID " +
                "GROUP BY initial " +
                "ORDER BY initial";

            @SuppressWarnings("unchecked")
            List<Object[]> rows = session.createNativeQuery(sql).getResultList();

            Map<String, Integer> result = new LinkedHashMap<>();
            for (Object[] row : rows) {
                String initial = row[0] != null ? row[0].toString() : "";
                int todo = row[1] != null ? ((Number) row[1]).intValue() : 0;
                // Wenn das Initial schon existiert, summiere auf
                result.merge(initial, todo, Integer::sum);
            }
            return result;
        }
    }

    public static List<LemmaKorrBelegRow> getLemmaBelegRowsFromBelegInitial(String initial, String db) throws Exception {
        List<LemmaKorrBelegRow> result = new ArrayList<>();
        try (Session session = getSession()) {
            String sql;
            Query query;
            if (initial == null || initial.isEmpty()) {
                sql = "SELECT e.ID, '' AS lemma, LOWER(TRIM(e.belegform)) AS beleg, e.MGHLemmaKorrigiert AS korr, ? AS db "
                        + "FROM einzelbeleg e "
                        + "LEFT OUTER JOIN einzelbeleg_hatmghlemma em ON e.ID = em.EinzelbelegID "
                        + "LEFT OUTER JOIN mgh_lemma m ON m.ID = em.MGHLemmaID "
                        + "WHERE m.MGHLemma IS NULL OR m.MGHLemma = ''";
                query = session.createNativeQuery(sql);
                query.setParameter(1, db);
            } else {
                sql = "SELECT e.ID, m.MGHLemma AS lemma, LOWER(TRIM(e.belegform)) AS beleg, e.MGHLemmaKorrigiert AS korr, ? AS db "
                        + "FROM einzelbeleg e "
                        + "LEFT OUTER JOIN einzelbeleg_hatmghlemma em ON e.ID = em.EinzelbelegID "
                        + "LEFT OUTER JOIN mgh_lemma m ON m.ID = em.MGHLemmaID "
                        + "WHERE CAST(UPPER(LEFT(m.MGHLemma, 1)) AS BINARY) = CAST(? AS BINARY)";
                query = session.createNativeQuery(sql);
                query.setParameter(1, db);
                query.setParameter(2, initial);
            }
            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                int id = ((Number) row[0]).intValue();
                String lemma = row[1] != null ? row[1].toString() : "";
                String beleg = row[2] != null ? row[2].toString() : "";
                boolean korr = false;
                if (row[3] instanceof Boolean) {
                    korr = (Boolean) row[3];
                } else if (row[3] instanceof Number) {
                    korr = ((Number) row[3]).intValue() != 0;
                }
                String dbName = row[4] != null ? row[4].toString() : "";
                result.add(new LemmaKorrBelegRow(id, lemma, beleg, korr, dbName));
            }
        }
        return result;
    }

    public static List<Map> getBelegformenWithMultipleLemmas() throws Exception {
        // Statements fürs manuelle Debuggen:
        // Alle Einzelbelege mit DISTINCT Lemma-Verknüpfungen
        // - SELECT DISTINCT Belegform, MGHLemmaID FROM einzelbeleg_hatmghlemma LEFT JOIN einzelbeleg ON einzelbeleg_hatmghlemma.EinzelbelegID = einzelbeleg.ID ORDER BY Belegform
        // Nur Einzelbelege mit mehr als 1 Lemma-Verknüpfungen:
        // - SELECT Belegform, COUNT(*) FROM (SELECT DISTINCT Belegform, MGHLemmaID FROM einzelbeleg_hatmghlemma LEFT JOIN einzelbeleg ON einzelbeleg_hatmghlemma.EinzelbelegID = einzelbeleg.ID ORDER BY Belegform) AS t1 GROUP BY Belegform HAVING COUNT(*) > 1 ORDER BY COUNT(*), Belegform;

        String DistinctBelegformAndLemmaIdSubselect = "SELECT DISTINCT Belegform, MGHLemmaID FROM einzelbeleg_hatmghlemma LEFT JOIN einzelbeleg ON einzelbeleg_hatmghlemma.EinzelbelegID = einzelbeleg.ID ORDER BY Belegform";
        String BelegformSubselect = "SELECT Belegform FROM (" + DistinctBelegformAndLemmaIdSubselect + ") AS t1 GROUP BY Belegform HAVING COUNT(*) > 1";
        String EinzelbelegIDSubselect = "SELECT ID FROM einzelbeleg WHERE Belegform IN (" + BelegformSubselect + ")";
        //String LemmaIDSubselect = "SELECT MGHLemmaID FROM einzelbeleg_hatmghlemma WHERE EinzelbelegID IN (" + EinzelbelegIDSubselect + ")";

        // Zusammengesetztes SELECT mit JOINS etc. für die Ergebnisanzeige
        String sql = "SELECT einzelbeleg_hatmghlemma.EinzelbelegID, einzelbeleg.Belegform, einzelbeleg_hatmghlemma.MGHLemmaId, mgh_lemma.MGHLemma, einzelbeleg_hatmghlemma.provenance_source, einzelbeleg.provenance_id";
        sql += " FROM einzelbeleg_hatmghlemma LEFT JOIN einzelbeleg ON einzelbeleg_hatmghlemma.EinzelbelegID = einzelbeleg.ID LEFT JOIN mgh_lemma ON mgh_lemma.ID = einzelbeleg_hatmghlemma.MGHLemmaID";
        sql += " WHERE einzelbeleg_hatmghlemma.EinzelbelegID IN (" + EinzelbelegIDSubselect + ")";
        sql += " ORDER BY einzelbeleg.Belegform ASC, mgh_lemma.MGHLemma ASC";

        return getMappedList(sql);
    }

}
