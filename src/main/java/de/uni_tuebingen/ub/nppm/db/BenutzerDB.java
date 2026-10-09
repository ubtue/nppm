package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import org.hibernate.Session;
import de.uni_tuebingen.ub.nppm.model.*;
import javax.persistence.criteria.*;

public class BenutzerDB extends AbstractBase {

    public static List<Benutzer> getList() throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.orderBy(builder.asc(benutzer.get(Benutzer_.Nachname)), builder.asc(benutzer.get(Benutzer_.Vorname)));

            return session.createQuery(criteria).getResultList();
        }
    }

    public static List<Benutzer> getListAktiv() throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.isTrue(benutzer.get(Benutzer_.IstAktiv)));
            criteria.orderBy(builder.asc(benutzer.get(Benutzer_.Nachname)), builder.asc(benutzer.get(Benutzer_.Vorname)));

            return session.createQuery(criteria).getResultList();
        }
    }

    public static List<Benutzer> getListInaktiv() throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.isFalse(benutzer.get(Benutzer_.IstAktiv)));
            criteria.orderBy(builder.asc(benutzer.get(Benutzer_.Nachname)), builder.asc(benutzer.get(Benutzer_.Vorname)));

            return session.createQuery(criteria).getResultList();
        }
    }

    public static Benutzer getById(int id) throws Exception {
        return AbstractBase.getById(id, Benutzer.class);
    }

    public static Benutzer getByLogin(String login) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.equal(benutzer.get(Benutzer_.Login), login));
            Benutzer res = session.createQuery(criteria).getSingleResult();
            return res;
        }
    }

    public static Benutzer getByLoginAktiv(String login) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.and(builder.equal(benutzer.get(Benutzer_.Login), login), builder.isTrue(benutzer.get(Benutzer_.IstAktiv))));
            Benutzer res = session.createQuery(criteria).getSingleResult();
            return res;
        }
    }

    public static Benutzer getByMail(String mail) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.equal(benutzer.get(Benutzer_.EMail), mail));

            try {
                Benutzer res = session.createQuery(criteria).getSingleResult();
                return res;
            } catch (javax.persistence.NoResultException e) {
                return null;
            }

        }
    }

    public static boolean hasEmail(String email) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.equal(benutzer.get(Benutzer_.EMail), email));
            boolean inDatabase = !session.createQuery(criteria).getResultList().isEmpty();
            return inDatabase;
        }
    }

    public static boolean hasLogin(String login) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<Benutzer> criteria = builder.createQuery(Benutzer.class);
            Root benutzer = criteria.from(Benutzer.class);
            criteria.select(benutzer);
            criteria.where(builder.equal(benutzer.get(Benutzer_.Login), login));
            boolean inDatabase = !session.createQuery(criteria).getResultList().isEmpty();

            return inDatabase;
        }
    }

    public static void saveOrUpdate(Benutzer b) throws Exception {
        try (Session session = getSession()) {
            session.getTransaction().begin();
            session.saveOrUpdate(b);
            session.getTransaction().commit();
        }
    }

    public static BenutzerGruppe getGruppeById(int id) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<BenutzerGruppe> criteria = builder.createQuery(BenutzerGruppe.class);
            Root benutzer = criteria.from(BenutzerGruppe.class);
            criteria.select(benutzer);
            criteria.where(builder.equal(benutzer.get(BenutzerGruppe_.ID), id));
            BenutzerGruppe res = session.createQuery(criteria).getSingleResult();
            return res;
        }
    }
}
