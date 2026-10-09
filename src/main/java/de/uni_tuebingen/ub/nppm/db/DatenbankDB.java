package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;
import org.hibernate.*;
import org.hibernate.query.Query;
import javax.persistence.criteria.*;
import org.hibernate.query.NativeQuery;

public class DatenbankDB extends AbstractBase {

    public static List<DatenbankFilter> getListFilter() throws Exception {
        return getList(DatenbankFilter.class);
    }

    public static List<DatenbankMapping> getListMapping() throws Exception {
        return getList(DatenbankMapping.class);
    }

    public static List<DatenbankSelektion> getListSelektion() throws Exception {
        return getList(DatenbankSelektion.class);
    }

    public static List<DatenbankSprache> getListSprache() throws Exception {
        return getList(DatenbankSprache.class);
    }

    public static List<DatenbankTexte> getListTexte() throws Exception {
        return getList(DatenbankTexte.class);
    }

    public static String getFilterSql(String formular, Integer filterNumber) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
            CriteriaQuery<DatenbankFilter> criteria = criteriaBuilder.createQuery(DatenbankFilter.class);
            Root<DatenbankFilter> root = criteria.from(DatenbankFilter.class);
            criteria.select(root).where(
                    criteriaBuilder.and(
                            criteriaBuilder.equal(root.get("nummer"), filterNumber),
                            criteriaBuilder.equal(root.get("formular"), formular)
                    )
            );
            Query query = session.createQuery(criteria);
            DatenbankFilter item = (DatenbankFilter) query.getSingleResult();
            if (item != null) {
                return item.getSqlString();
            }

            return null;
        }
    }

    public static String getLabel(String language, String formular, String textfeld, Object... args) throws Exception  {
        String template = getLabel(language, formular, textfeld);
        return String.format(template, args);
    }

    public static String getLabel(String language, String formular, String textfeld) throws Exception {
        DatenbankTexte item = getLabel(formular, textfeld);

        if (item != null) {
            return item.get(language);
        }

        return null;
    }

    public static DatenbankTexte getLabel(String formular, String textfeld) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
            CriteriaQuery<DatenbankTexte> criteria = criteriaBuilder.createQuery(DatenbankTexte.class);
            Root<DatenbankTexte> root = criteria.from(DatenbankTexte.class);
            criteria.select(root).where(
                    criteriaBuilder.and(
                            criteriaBuilder.equal(root.get("textfeld"), textfeld),
                            criteriaBuilder.equal(root.get("formular"), formular)
                    )
            );
            Query query = session.createQuery(criteria);
            List<Object> rows = query.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (DatenbankTexte) rows.get(0);
        }
    }

    public static DatenbankMapping getMapping(String formular, String datafield) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
            CriteriaQuery<DatenbankMapping> criteria = criteriaBuilder.createQuery(DatenbankMapping.class);
            Root<DatenbankMapping> root = criteria.from(DatenbankMapping.class);
            criteria.select(root).where(
                    criteriaBuilder.and(
                            criteriaBuilder.equal(root.get("datenfeld"), datafield),
                            criteriaBuilder.equal(root.get("formular"), formular)
                    )
            );
            Query query = session.createQuery(criteria);
            List<Object> rows = query.getResultList();
            if (rows.isEmpty()) {
                return null;
            }
            return (DatenbankMapping) rows.get(0);
        }
    }


    public static String getMapping(String lang, String formular, String datafield) throws Exception {
        DatenbankMapping mapping = getMapping(formular, datafield);
        if (mapping != null) {
            return mapping.getBeschriftung(lang);
        }

        return null;
    }

    public static List<Object[]> getResult(String sql) throws Exception {
        try (Session session = getSession()) {
            NativeQuery query = session.createNativeQuery(sql);
            List<Object[]> rows = query.getResultList();
            return rows;
        }
    }

    public static List<String> getSelektion() throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT DISTINCT selektion FROM datenbank_selektion ORDER BY selektion ASC";
            NativeQuery query = session.createNativeQuery(SQL);
            List<String> rows = query.getResultList();
            return rows;
        }
    }

    public static void updateAuswahlfelder(String tabelle, String feldAlt, String feldNeu) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT tabelle, spalte FROM datenbank_selektion WHERE selektion ='" + tabelle + "';";
            NativeQuery query = session.createNativeQuery(SQL);
            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                String tbl = row[0].toString();
                String col = row[1].toString();
                String updateSQL = "UPDATE " + tbl + " SET " + col + "=" + feldNeu
                        + " WHERE " + col + "=" + feldAlt;
                insertOrUpdate(updateSQL);
            }
        }

    }

    public static void deleteAuswahlfeld(String tabelle, String ID) throws Exception {
        verifyDynamicTable(tabelle, "selektion_");

        String SQL = "DELETE FROM " + tabelle
                      + " WHERE ID=" + ID;
        insertOrUpdate(SQL);
    }

    public static void setNull(String tabelle, String ID, String attribute) throws Exception {
        String sql = "UPDATE "+tabelle+" SET "+attribute+"=NULL WHERE ID="+ID;
        insertOrUpdate(sql);
    }
}
