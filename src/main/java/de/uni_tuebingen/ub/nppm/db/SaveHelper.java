package de.uni_tuebingen.ub.nppm.db;

import de.uni_tuebingen.ub.nppm.model.DatenbankMapping;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;

public class SaveHelper extends AbstractBase {

    public static boolean existForm(String form, int id) throws Exception {
        return getSingleResult("SELECT * FROM " + form + " WHERE ID=" + id) != null;
    }

    public static void insertMetaData(String form, int id, int benutzerID, int gruppenID) throws Exception {
        String sql = "INSERT INTO " + form + " (ID, Erstellt, ErstelltVon, GehoertGruppe)"
                + " VALUES(" + id + ", NOW(), " + benutzerID + ", " + gruppenID + ");";
        insertOrUpdate(sql);
    }

    public static List<Map> getAttribute(String table, String attribute, Map andConditions) throws Exception {
        List<Map> results = new ArrayList<>();

        try ( Session session = getSession()) {
            String sql = "SELECT " + attribute + " FROM " + table; // SQL-Abfrage erstellen
            sql += buildAndConditions(andConditions); // Bedingungen hinzufügen

            NativeQuery query = session.createNativeQuery(sql);
            registerParameters(andConditions, query);

            if (attribute.equals("*")) {
                List<Object[]> queryResults = query.getResultList(); // Ergebnisse aus der Datenbank

                for (Object[] row : queryResults) {
                    Map<String, String> resultRow = new HashMap<>();
                    resultRow.put(attribute, row[0].toString()); // Wert zur HashMap hinzufügen
                    results.add(resultRow);
                }
            } else {
                List<String> queryResults = query.getResultList(); // Ergebnisse aus der Datenbank
                for (String value : queryResults) {
                    Map<String, String> resultRow = new HashMap<>();
                    resultRow.put(attribute, value); // Wert zur HashMap hinzufügen
                    results.add(resultRow);
                }
            }
        }
        return results;
    }

    public static List<Map> getAttributeMap(String table, String attributeString, int id) throws Exception {
        List<Map> results = new ArrayList<>();
        String sql = "SELECT " + attributeString + " FROM " + table + " WHERE ID = " + id; // SQL-Abfrage erstellen
        List<Object[]> queryResults = getListNative(sql); // Ergebnisse aus der Datenbank als Liste von Object-Arrays
        for (Object[] row : queryResults) {
            Map<String, Object> rowMap = new HashMap<>();

            // Die Spaltenwerte in die Map einfügen, wobei die Spaltennamen als Schlüssel verwendet werden
            for (int i = 0; i < row.length; i++) {
                String columnName = attributeString.split(",")[i].trim(); // Die Spaltennamen sind mit Kommas getrennt
                rowMap.put(columnName, row[i]);
            }

            results.add(rowMap);
        }
        return results;
    }

    public static List<Map> getMapField(String zieltabelle, int id) throws Exception {
        String sql = "SELECT * FROM " + zieltabelle + " WHERE ID = " + id; // SQL-Abfrage erstellen

        return getMappedListString(sql);
    }

    public static void updateMetaData(String form, int id, int benutzerID) throws Exception {
        String sql = "UPDATE " + form + " SET LetzteAenderung = NOW(), LetzteAenderungVon=\"" + benutzerID + "\" WHERE ID=" + id + ";";
        insertOrUpdate(sql);
    }

    public static void insert(String table, Map<String, String> columnsAndValues) throws Exception {
        try ( Session session = getSession()) {
            session.getTransaction().begin();

            String sql = "INSERT INTO " + table + " (";
            List<String> columnNames = new ArrayList<>();
            List<String> valuePlaceholders = new ArrayList();

            for (Map.Entry<String, String> entry : columnsAndValues.entrySet()) {
                String value = entry.getValue();
                if (value != null && !value.isEmpty()) {
                    columnNames.add(entry.getKey());
                    valuePlaceholders.add(":" + entry.getKey());
                }
            }

            if (!columnNames.isEmpty()) {
                sql += String.join(", ", columnNames) + ") VALUES (" + String.join(", ", valuePlaceholders) + ")";

                NativeQuery query = session.createNativeQuery(sql);

                for (Map.Entry<String, String> entry : columnsAndValues.entrySet()) {
                    String value = entry.getValue();
                    if (value != null && !value.isEmpty()) {
                        query.setParameter(entry.getKey(), value);
                    }
                }
                query.executeUpdate();
            }
            session.getTransaction().commit();
        }
    }

    public static void deleteAttribute(String table, Map<String, String> andConditions) throws Exception {
        try ( Session session = getSession()) {
            session.getTransaction().begin();
            String sql = "DELETE FROM " + table;
            sql += buildAndConditions(andConditions);

            NativeQuery query = session.createNativeQuery(sql);
            registerParameters(andConditions, query);

            query.executeUpdate();
            session.getTransaction().commit();
        }
    }

    public static List<DatenbankMapping> getMapping(String formular) throws Exception {
        try ( Session session = getSession()) {
            CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
            CriteriaQuery<DatenbankMapping> criteria = criteriaBuilder.createQuery(DatenbankMapping.class);
            Root<DatenbankMapping> root = criteria.from(DatenbankMapping.class);
            criteria.select(root).where(
                criteriaBuilder.and(
                    criteriaBuilder.equal(root.get("formular"), formular)
                )
            );
            org.hibernate.query.Query query = session.createQuery(criteria);
            List<DatenbankMapping> rows = query.getResultList();
            return rows;
        }
    }

    public static void insertOrUpdateSql(String sql) throws Exception {
        try {
            insertOrUpdate(sql);
        } catch (Exception exception) {
            throw new Exception(exception.getLocalizedMessage() + "\nSQL: " + sql);
        }
    }
}
