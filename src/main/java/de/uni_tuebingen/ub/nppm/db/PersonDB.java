package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import java.util.stream.Stream;
import de.uni_tuebingen.ub.nppm.model.*;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;

public class PersonDB extends AbstractBase {

    public static final String SUBSELECT_PUBLIC_PERSON_IDS = "SELECT DISTINCT PersonID FROM einzelbeleg_hatperson WHERE EinzelbelegID IN (" + EinzelbelegDB.SUBSELECT_PUBLIC_EINZELBELEG_IDS + ")";
    public static final String ORDER_BY_PUBLIC_PERSON = " ORDER BY person.Standardname ASC, person.ID ASC";

    public static Person getById(int id) throws Exception {
        return AbstractBase.getById(id, Person.class);
    }

    public static Person getByGndPublic(String gnd) throws Exception {
        String query = "SELECT * FROM person WHERE GND = \"" + escape(gnd, '"') + "\" AND ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ")";
        return getSingleResult(query, Person.class);
    }

    public static List<Person> getList() throws Exception {
        return getList(Person.class);
    }

    private static Query getQueryPublic(final Session session) throws Exception {
        String SQL = "SELECT * FROM person WHERE ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ") " + ORDER_BY_PUBLIC_PERSON;
        NativeQuery query = session.createNativeQuery(SQL);
        query.addEntity(Person.class);
        return query;
    }

    public static List<Person> getListPublic() throws Exception {
        try (Session session = getSession()) {
            return getQueryPublic(session).getResultList();
        }
    }

    public static Stream<Person> getStreamPublic(final Session session) throws Exception {
        return getQueryPublic(session).getResultStream();
    }

    // Alias for backwards compatibility
    public static List<Person> getListPerson() throws Exception {
        return getList();
    }

    // Alias for backwards compatibility
    public static List<Person> getListPersonPublic() throws Exception {
        return getListPublic();
    }

    public static List<PersonAmtStandWeihe_MM> getListPersonAmtStandWeihe() throws Exception {
        return getList(PersonAmtStandWeihe_MM.class);
    }

    public static List<PersonQuiet> getListPersonQuiet() throws Exception {
        return getList(PersonQuiet.class);
    }

    public static List<PersonVariante> getListPersonVariante() throws Exception {
        return getList(PersonVariante.class);
    }

    public static Person getFirstPublicPerson() throws Exception {
        try (Session session = getSession()) {
            Query query = getQueryPublic(session);
            query.setMaxResults(1);
            return (Person) query.getSingleResult();
        }
    }

    public static Integer getNextPublicPersonId(int id) throws Exception {
        try (Session session = getSession()) {
            // 1. Kleinste und größte veröffentlichte Person ID holen
            String minMaxSQL = "SELECT MIN(person.ID), MAX(person.ID) "
                    + "FROM person "
                    + "WHERE person.ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ")";
            Object[] minMaxResult = (Object[]) session.createNativeQuery(minMaxSQL).getSingleResult();
            Integer minId = minMaxResult[0] != null ? ((Number) minMaxResult[0]).intValue() : null;
            Integer maxId = minMaxResult[1] != null ? ((Number) minMaxResult[1]).intValue() : null;

            if (minId == null || maxId == null) {
                return null; // Keine öffentliche Person vorhanden
            }

            // Behandle ungültige IDs (z.B. negative Werte)
            if (id < 0) {
                return minId;
            }

            // Fall 1: ID kleiner als kleinste public ID
            if (id < minId) {
                return minId;
            }
            // Fall 2: ID größer als größte public ID
            if (id > maxId) {
                return maxId;
            }

            // 2. Prüfen, ob die übergebene ID existiert und öffentlich ist
            String checkPublicSQL = "SELECT person.ID "
                    + "FROM person "
                    + "WHERE person.ID = :id "
                    + "AND person.ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ")";
            NativeQuery checkQuery = session.createNativeQuery(checkPublicSQL);
            checkQuery.setParameter("id", id);

            Object isPublic = checkQuery.uniqueResult();

            if (isPublic != null) {
                // Fall 3: ID existiert und ist public
                return id;
            }

            // Fall 4: ID existiert, aber nicht public → Suche die nächste höhere öffentliche ID
            String nextPublicSQL = "SELECT person.ID "
                    + "FROM person "
                    + "WHERE person.ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ") "
                    + "AND person.ID > :id "
                    + "ORDER BY person.ID ASC";

            NativeQuery nextQuery = session.createNativeQuery(nextPublicSQL);
            nextQuery.setParameter("id", id);
            nextQuery.setMaxResults(1);

            Object nextPublic = nextQuery.uniqueResult();
            return nextPublic != null ? ((Number) nextPublic).intValue() : maxId; // Falls keiner gefunden → größte ID
        }
    }

    public static List<Integer> getAllPublicPersonIds() throws Exception {
        try (Session session = getSession()) {
            String sql = "SELECT person.ID FROM person "
                    + "WHERE person.ID IN (" + SUBSELECT_PUBLIC_PERSON_IDS + ") "
                    + ORDER_BY_PUBLIC_PERSON;
            return session.createNativeQuery(sql).getResultList();
        }
    }
}
