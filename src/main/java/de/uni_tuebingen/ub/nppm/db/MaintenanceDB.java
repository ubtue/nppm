package de.uni_tuebingen.ub.nppm.db;

/**
 * This class is used for queries that are typically used for
 * internal maintenance queries, data migrations, and so on.
 */
public class MaintenanceDB extends AbstractBase {
    public static String getBelegformByGeschlechtSql() throws Exception {

        String sql = "SELECT einzelbeleg.Belegform AS Belegform,"
                   + " GROUP_CONCAT(DISTINCT CASE WHEN selektion_geschlecht.Bezeichnung IN ('m','f') THEN selektion_geschlecht.Bezeichnung END ORDER BY selektion_geschlecht.Bezeichnung DESC SEPARATOR ',') AS Geschlechter,"
                   + " GROUP_CONCAT(DISTINCT CASE WHEN selektion_grammatikgeschlecht.Bezeichnung IN ('m','f') THEN selektion_grammatikgeschlecht.Bezeichnung END ORDER BY selektion_geschlecht.Bezeichnung DESC SEPARATOR ',') AS Grammatikgeschlechter,"
                   + " mgh_lemma.MGHLemma"
                   + " FROM einzelbeleg"
                   + " LEFT JOIN selektion_geschlecht ON einzelbeleg.GeschlechtID = selektion_geschlecht.ID"
                   + " LEFT JOIN selektion_grammatikgeschlecht ON einzelbeleg.GrammatikGeschlechtID = selektion_grammatikgeschlecht.ID"
                   + " LEFT JOIN einzelbeleg_hatmghlemma ON einzelbeleg.ID = einzelbeleg_hatmghlemma.EinzelbelegID"
                   + " LEFT JOIN mgh_lemma ON einzelbeleg_hatmghlemma.MGHLemmaID = mgh_lemma.ID"
                   + " GROUP BY Belegform"
                   + " ORDER BY Belegform ASC";

        // Note: This query is very slow / contains tens of thousands of rows,
        // so the caller should use getResultStream() and manage its own session.
        return sql;
    }
}
