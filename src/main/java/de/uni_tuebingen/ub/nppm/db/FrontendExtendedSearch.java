package de.uni_tuebingen.ub.nppm.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;

public class FrontendExtendedSearch extends AbstractBase {

    public static List<Map<String, String>> getSearchResult(String fieldsString, String tablesString, String conditionsString, String order, String[] fields) throws Exception {
        String sql = "SELECT DISTINCT " + fieldsString + " FROM " + tablesString + " WHERE (" + conditionsString + ") " + order;
        try ( Session session = getSession()) {
            if (fields.length > 1) {
                NativeQuery sqlQuery = session.createNativeQuery(sql);
                List<Object[]> rows = sqlQuery.getResultList();
                //return var
                List<Map<String, String>> ret = new ArrayList<>();
                //loop over the rows
                for (Object[] row : rows) {
                    //convert the fields from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    for (int i = 0; i < fields.length; i++) {
                        String[] name = fields[i].split(" AS ");
                        if (name.length == 2) {
                            fields[i] = name[1];
                        }
                        if (row[i] != null) {
                            fieldVal.put(fields[i].trim(), row[i].toString());
                        }
                    }
                    ret.add(fieldVal);
                }//end for (Object[] row : rows)

                return ret;
            }//end fields.length
            else {
                NativeQuery sqlQuery = session.createNativeQuery(sql);
                List<Object> rows = sqlQuery.getResultList();
                //return var
                List<Map<String, String>> ret = new ArrayList<>();
                //loop over the rows
                for (Object row : rows) {
                    //convert the field from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    if (row != null) {
                        fieldVal.put(fields[0].trim(), row.toString());
                    }
                    ret.add(fieldVal);
                }//end for (Object row : rows)

                return ret;
            }
        }//end session
    }//end function

    public static List<Map<String, String>> getSearchResult(String fieldsString, String tablesString, String conditionsString, String order, String[] fields, int limit, int offset) throws Exception {
        String sql = "SELECT DISTINCT " + fieldsString + " FROM " + tablesString + " WHERE (" + conditionsString + ") " + order + " LIMIT " + limit + " OFFSET " + offset;
        try (Session session = getSession()) {
            if (fields.length > 1) {
                NativeQuery sqlQuery = session.createNativeQuery(sql);
                List<Object[]> rows = sqlQuery.getResultList();
                //return var
                List<Map<String, String>> ret = new ArrayList<>();
                //loop over the rows
                for (Object[] row : rows) {
                    //convert the fields from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    for (int i = 0; i < fields.length; i++) {
                        String[] name = fields[i].split(" AS ");
                        if (name.length == 2) {
                            fields[i] = name[1];
                        }
                        if (row[i] != null) {
                            fieldVal.put(fields[i].trim(), row[i].toString());
                        }
                    }
                    ret.add(fieldVal);
                }//end for (Object[] row : rows)

                return ret;
            }//end fields.length
            else {
                NativeQuery sqlQuery = session.createNativeQuery(sql);
                List<Object> rows = sqlQuery.getResultList();
                //return var
                List<Map<String, String>> ret = new ArrayList<>();
                //loop over the rows
                for (Object row : rows) {
                    //convert the field from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    if (row != null) {
                        fieldVal.put(fields[0].trim(), row.toString());
                    }
                    ret.add(fieldVal);
                }//end for (Object row : rows)

                return ret;
            }
        }//end session
    }//end function
}
