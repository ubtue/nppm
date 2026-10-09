package de.uni_tuebingen.ub.nppm.db;

import de.uni_tuebingen.ub.nppm.model.*;
import de.uni_tuebingen.ub.nppm.util.Constants;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Root;
import javax.persistence.Tuple;
import javax.servlet.http.HttpServletRequest;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;
import org.hibernate.Session;

public class SucheDB extends AbstractBase {

    public static List<SucheFavoriten> getFavoriten() throws Exception {
        return getList(SucheFavoriten.class);
    }

    public static List<String> getAutocompleteText(String field, String form, String query, boolean includeUnpublished) throws Exception {
        verifyDynamicTable(form);
        verifyDynamicColumn(field);

        String sql = "SELECT DISTINCT " + field + " FROM " + form;
        List<String> andConditions = new ArrayList<>();

        if (!includeUnpublished) {
            if (form.equals("quelle")) {
                andConditions.add("quelle.ID IN (" + QuelleDB.SUBSELECT_PUBLIC_QUELLE_IDS + ")");
            }
            if (form.equals("einzelbeleg")) {
                andConditions.add("einzelbeleg.ID IN (" + EinzelbelegDB.SUBSELECT_PUBLIC_EINZELBELEG_IDS + ")");
            }
            if (form.equals("person")) {
                andConditions.add("person.ID IN (" + PersonDB.SUBSELECT_PUBLIC_PERSON_IDS + ")");
            }
            if (form.equals("mghlemma")) {
                andConditions.add("mghlemma.ID IN (" + LemmaDB.SUBSELECT_PUBLIC_MGHLEMMA_IDS + ")");
            }
        }

        boolean addLikeStatement = !query.equals("?");
        if (!query.equals("?")) {
            andConditions.add(field + " LIKE CONCAT('%', ?1, '%')");
        }

        // in der auto completion->frontend->erweiterte suche keine einträge mit Constants.forbiddenLemmaSubstring zeigen
        if ("mgh_lemma".equals(form) && "MGHLemma".equals(field)) {
            andConditions.add(field + " NOT LIKE '%"+escape(Constants.forbiddenLemmaSubstring, sqlEscapesSingleQuotes)+"%'");
        }

        if (!andConditions.isEmpty()) {
            sql += " WHERE " + String.join(" AND ", andConditions);
        }

        sql += " ORDER BY " + field;

        try (Session session = getSession()) {
            NativeQuery sqlQuery = session.createNativeQuery(sql);
            if (addLikeStatement)
                sqlQuery.setParameter(1, query);
            List<String> rows = sqlQuery.getResultList();
            return rows;
        }
    }

    public static Map<Integer, String> getAttributes(HttpServletRequest request) throws Exception {
        String dbForm = request.getParameter("dbForm");
        String tabelle = request.getParameter("zwischentabelle");
        String zwAttribut = request.getParameter("zwAttribut");
        String attribut = request.getParameter("attribut");

        verifyDynamicTable(dbForm);
        verifyDynamicTable(tabelle);
        verifyDynamicColumn(attribut);
        verifyDynamicColumn(zwAttribut);

        Map<Integer, String> ret = new HashMap<>();
        try (Session session = getSession()) {
            String sql = "SELECT ID, " + attribut + " FROM " + dbForm + " e WHERE NOT EXISTS (SELECT * FROM " + tabelle + " eh WHERE e.ID=eh." + zwAttribut + ") ORDER BY " + attribut;
            NativeQuery query = session.createNativeQuery(sql);
            List<Object[]> rows = query.list();

            for (Object[] row : rows) {
                if (row[0] != null && row[1] != null) {
                    ret.put(Integer.valueOf(row[0].toString()), row[1].toString());
                }
            }

            return ret;
        }
    }

    public static List getFields(String fields, String tablesString, String conditionsString, String export, Integer pageoffset, Integer pageLimit) throws Exception {
        String sql = "SELECT " + fields + " FROM " + tablesString + " WHERE (" + conditionsString + ")";
        if (export != null && (export.equals("liste") || export.equals("browse")) && pageoffset != null && pageLimit != null) {
            sql += " LIMIT " + (pageoffset * pageLimit) + ", " + pageLimit;
        }

        return getMappedList(sql);
    }

    public static List<Map<String, String>> getSearchResult(String fieldsString, String tablesString, String conditionsString, String orderString, String order, String[] fields) throws Exception {
        String sql = "SELECT DISTINCT " + fieldsString + " FROM " + tablesString + " WHERE (" + conditionsString + ") " + order;
        if (order.equals("")) {
            sql += orderString;
        }

        try (Session session = getSession()) {
            NativeQuery sqlQuery = session.createNativeQuery(sql);
            List<?> rows = sqlQuery.getResultList();
            //return var
            List<Map<String, String>> ret = new ArrayList<>();

            //determine the first element which is not null
            //this is necessary to get the type of the return class
            Object firstElement = null;
            for(Object o : rows){
                if(o != null){
                    firstElement = o;
                    break;
                }
            }
            /*
                the return value is from type Object[]
                This means that the array fields has more than one element
                and we need to iterate over it
            */
            if(firstElement instanceof Object[]){
                //loop over the rows
                for (Object[] row : (List<Object[]>) rows) {
                    //convert the fields from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    for (int i = 0; i < fields.length; i++) {
                        String[] name = fields[i].split(" AS ");
                        if (name.length == 2) {
                            fields[i] = name[1];
                        }
                        if (row != null && row[i] != null) {
                            fieldVal.put(fields[i].trim(), row[i].toString());
                        }
                    }
                    ret.add(fieldVal);
                }
            /*
                the return value is from type Object
                This means that the array fields has only one element
                and we dont need to iterate over it
            */
            }else if(firstElement instanceof Object){
                for (Object row : (List<Object>) rows) {
                    //convert the fields from the row to a map
                    Map<String, String> fieldVal = new HashMap<>();
                    String[] name = fields[0].split(" AS ");
                    if (name.length == 2) {
                        fields[0] = name[1];
                    }
                    if (row != null) {
                        fieldVal.put(fields[0].trim(), row.toString());
                    }
                    ret.add(fieldVal);
                }
            }

            return ret;
        }
    }

    public static List<Object[]> getSearchCount(String conditionsString, String countString, String tablesString) throws Exception {
        List<Object[]> ret = new ArrayList<>();
        String sql = "SELECT " + countString + " FROM " + tablesString + " WHERE (" + conditionsString + ")";

        try (Session session = getSession()) {
            NativeQuery sqlQuery = session.createNativeQuery(sql);
            List rows = sqlQuery.list();

            for (Object object : rows) {
                //if object is not an array, cast it to a one dim array
                if (!object.getClass().isArray()) {
                    Object[] arr = new Object[1];
                    arr[0] = object;
                    ret.add(arr);
                    return ret;
                } else {
                    ret.add((Object[]) object);
                }
            }
            return ret;
        }
    }

    public static List<SucheErgebnis> getExtended(SucheOptionen suchoptionen) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Tuple> query = builder.createTupleQuery();

            Root rootEinzelbeleg = query.from(Einzelbeleg.class);
            Join<Einzelbeleg, Quelle> joinQuelle = rootEinzelbeleg.join(Einzelbeleg_.QUELLE, JoinType.LEFT);
            Join<Einzelbeleg, Person> joinPerson = rootEinzelbeleg.join(Einzelbeleg_.PERSON);

            // If you add / change the parameters here, make sure to also change the calls for tuple.get() below
            query.multiselect(rootEinzelbeleg, joinQuelle, joinPerson);

            if (suchoptionen.quelleZuVeroeffentlichen) {
                query.where(builder.equal(joinQuelle.get(Quelle_.zuVeroeffentlichen), 1));
            }
            if (suchoptionen.einzelbelegBelegform != null) {
                query.where(builder.equal(rootEinzelbeleg.get(Einzelbeleg_.BELEGFORM), suchoptionen.einzelbelegBelegform));
            }

            Query preparedQuery = session.createQuery(query);
            if (suchoptionen.limit > 0) {
                preparedQuery.setMaxResults(suchoptionen.limit);
            }

            // Convert result into structured data
            List<Tuple> resultList = preparedQuery.getResultList();
            List<SucheErgebnis> endResultList = new ArrayList<>();
            for (Tuple tuple : resultList) {
                SucheErgebnis endResult = new SucheErgebnis();

                // The order of objects for tuple.get() must be similar to query.multiselect()
                endResult.einzelbeleg = tuple.get(0, Einzelbeleg.class);
                endResult.quelle = tuple.get(1, Quelle.class);
                endResult.person = tuple.get(2, Person.class);

                endResultList.add(endResult);
            }
            return endResultList;
        }
    }

   public static List<Map> getEinfacheSucheResult(String search) throws Exception {
        String searchTerm = search;
        // if search in double quotes, use verbatim, otherwise replace spaces with % wildcards
        if (searchTerm.startsWith("\"") && searchTerm.endsWith("\"")) {
            // remove quotes beginning and end
            searchTerm = searchTerm.substring(1, searchTerm.length() - 1);
        }
        //searchTerm = searchTerm.replace("*", "%");  //Wenn du * als Wildcard zulassen willst

        String sql = "SELECT DISTINCT mgh_lemma.MGHLemma, mgh_lemma.ID AS mgh_lemmaID, person.Standardname AS Standardname, person.ID AS personID, quelle.Bezeichnung, quelle.ID AS quelleID, edition.Zitierweise AS editionZitierweise, edition.ID AS editionID, einzelbeleg.EditionKapitel, einzelbeleg.EditionSeite, einzelbeleg.seite, einzelbeleg.raster AS raster, quelle.VonTag AS quelleVonTag, quelle.VonMonat AS quelleVonMonat, quelle.VonJahr AS quelleVonJahr, quelle.VonJahrhundert AS quelleVonJahrhundert, quelle.BisTag AS quelleBisTag, quelle.BisMonat AS quelleBisMonat, quelle.BisJahr AS quelleBisJahr, quelle.BisJahrhundert AS quelleBisJahrhundert, einzelbeleg.Belegform, einzelbeleg.ID AS e2ID, einzelbeleg.VonTag, einzelbeleg.VonMonat, einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisTag, einzelbeleg.BisMonat, einzelbeleg.BisJahr, einzelbeleg.BisJahrhundert, VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) AS quelleBerJahr"
                   + " FROM einzelbeleg"
                   + " LEFT JOIN einzelbeleg_hatmghlemma ehk1 ON ehk1.EinzelbelegID=einzelbeleg.ID"
                   + " LEFT JOIN mgh_lemma ON mgh_lemma.ID=ehk1.MGHLemmaID"
                   + " LEFT JOIN einzelbeleg_hatperson ON einzelbeleg.ID=einzelbeleg_hatperson.EinzelbelegID"
                   + " LEFT JOIN person ON einzelbeleg_hatperson.PersonID=person.ID"
                   + " LEFT JOIN quelle ON einzelbeleg.QuelleID=quelle.ID"
                   + " LEFT JOIN edition ON einzelbeleg.EditionID=edition.ID"
                   + " WHERE quelle.zuVeroeffentlichen='1'"
                   + " AND (mgh_lemma.MGHLemma NOT LIKE '%"+escape(Constants.forbiddenLemmaSubstring, sqlEscapesSingleQuotes)+"%')"
                   + " AND mgh_lemma.ID IN"
                   + " ("
                   + " SELECT DISTINCT mgh_lemma.ID FROM einzelbeleg"
                   + " LEFT JOIN einzelbeleg_hatmghlemma ON einzelbeleg.ID = einzelbeleg_hatmghlemma.EinzelbelegID"
                   + " LEFT JOIN mgh_lemma ON mgh_lemma.ID = einzelbeleg_hatmghlemma.MGHLemmaID"
                   + " WHERE einzelbeleg.Belegform ";

        if (searchTerm.contains("%") || searchTerm.contains("_")) {
            sql += " LIKE ";
        } else {
            sql += " = ";
        }

        sql       += " ? )" // the question mark will be replaced by the escaped value via setParameter() below
                   + " ORDER BY mgh_lemma.MGHLemma ASC, person.Standardname ASC, einzelbeleg.Belegform ASC, (VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) DIV 25), VON_JAHR_JHDT(quelle.VonJahr, quelle.VonJahrhundert, quelle.BisJahrhundert) ASC;";

        try (Session session = getSession()) {
            NativeQuery sqlQuery = session.createNativeQuery(sql);
            sqlQuery.setParameter(1, searchTerm);
            return getMappedList(sqlQuery);
        }
    }

}
