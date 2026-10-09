package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;

public class ModulIncDB extends AbstractBase {

    public static List<Object[]> getListEinzelbelegTextkritik(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT ed.Zitierweise, ue.Sigle, et.Variante, h.VonTag,h.VonMonat, "
                    + "h.VonJahr,h.VonJahrhundert, h.BisTag,h.BisMonat,h.BisJahr,h.BisJahrhundert,"
                    + " et.Bemerkung from einzelbeleg_textkritik et, edition ed,"
                    + " handschrift_ueberlieferung h, ueberlieferung_edition ue, "
                    + "einzelbeleg e where h.ID=ue.UeberlieferungID AND et.HandschriftID=h.ID"
                    + " AND ue.EditionID=ed.ID AND h.QuelleID=e.QuelleID AND"
                    + " ed.ID=et.EditionID AND et.EinzelbelegID= :id AND e.ID= :id";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static int countNamenkommentar(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT count(DISTINCT namenkommentar.ID) FROM einzelbeleg LEFT OUTER JOIN "
                    + "einzelbeleg_hatperson ON einzelbeleg.ID=einzelbeleg_hatperson.EinzelbelegID "
                    + "LEFT OUTER JOIN person ON einzelbeleg_hatperson.PersonID=person.ID "
                    + "LEFT OUTER JOIN einzelbeleg_hatnamenkommentar ON einzelbeleg_hatnamenkommentar.EinzelbelegID=einzelbeleg.ID "
                    + "LEFT OUTER JOIN namenkommentar ON namenkommentar.ID=einzelbeleg_hatnamenkommentar.NamenkommentarID WHERE person.ID= :id";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return ((Number) query.getSingleResult()).intValue();
        }
    }

    public static List<Object[]> getListPersonNamenkommentarPlemma(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT DISTINCT namenkommentar.PLemma, namenkommentar.ID FROM einzelbeleg"
                    + " LEFT OUTER JOIN einzelbeleg_hatperson ON einzelbeleg.ID ="
                    + " einzelbeleg_hatperson.EinzelbelegID LEFT OUTER JOIN person ON"
                    + " einzelbeleg_hatperson.PersonID=person.ID LEFT OUTER JOIN"
                    + " einzelbeleg_hatnamenkommentar ON einzelbeleg_hatnamenkommentar.EinzelbelegID ="
                    + " einzelbeleg.ID LEFT OUTER JOIN namenkommentar ON namenkommentar.ID ="
                    + " einzelbeleg_hatnamenkommentar.NamenkommentarID WHERE person.ID= :id";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListPersonenEinzelbelege(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT e.ID, e.Belegnummer, e.Belegform, e.VonTag, e.VonMonat, e.VonJahr, e.VonJahrhundert,"
                    + " e.BisTag, e.BisMonat, e.BisJahr, e.BisJahrhundert, e.kontext FROM einzelbeleg e LEFT JOIN"
                    + " einzelbeleg_hatperson p ON e.ID = p.einzelbelegID WHERE e.id IN (SELECT einzelbeleg.ID"
                    + " FROM einzelbeleg, quelle WHERE einzelbeleg.QuelleID = quelle.ID AND quelle.ZuVeroeffentlichen = 1)"
                    + " AND p.personID = :id ORDER BY e.vonJahr ASC, e.vonMonat ASC, e.vonTag ASC;";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<String> getListPlemma(String id) throws Exception {
        try (Session session = getSession()) {
            CriteriaBuilder builder = session.getCriteriaBuilder();
            CriteriaQuery<String> criteria = builder.createQuery(String.class);
            Root<NamenKommentar> namenkommentare = criteria.from(NamenKommentar.class);
            criteria.select(namenkommentare.get("pLemma"));
            criteria.where(builder.equal(namenkommentare.get("id"), id));

            return session.createQuery(criteria).getResultList();
        }
    }

    public static List<Object[]> getListPersonenVerwandte(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "select p.ID, p.Standardname, sv.Bezeichnung from person p,"
                    + " person_verwandtmit pv, selektion_verwandtschaftsgrad sv "
                    + "where pv.personIDvon= :id and pv.personIDzu=p.ID and"
                    + " pv.verwandtschaftsgradID=sv.ID and p.ID in (SELECT PersonID FROM"
                    + " einzelbeleg_hatperson WHERE EinzelbelegID IN "
                    + "(SELECT einzelbeleg.ID FROM einzelbeleg, quelle "
                    + "WHERE einzelbeleg.QuelleID=quelle.ID AND quelle.ZuVeroeffentlichen=1));";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListQuellenbezeichnungen(String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT quelle.ID, quelle.Bezeichnung Bezeichnung FROM"
                    + " quelle_inedition, quelle WHERE quelle_inedition.EditionID= :id "
                    + "AND quelle_inedition.quelleID=quelle.ID ORDER BY Bezeichnung ASC;";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List getListQuellenInformationen(String qId, String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT handschrift.ID AS handschrift_ID, handschrift.Bibliothekssignatur,"
                    + " handschrift_ueberlieferung.ID AS handschrift_ueberlieferung_ID, ueberlieferung_edition.Sigle,"
                    + " handschrift_ueberlieferung.VonTag, handschrift_ueberlieferung.VonMonat, handschrift_ueberlieferung.VonJahr,"
                    + " handschrift_ueberlieferung.VonJahrhundert, handschrift_ueberlieferung.BisTag, handschrift_ueberlieferung.BisMonat,"
                    + " handschrift_ueberlieferung.BisJahr, handschrift_ueberlieferung.BisJahrhundert, selektion_ort.Bezeichnung"
                    + " FROM handschrift JOIN handschrift_ueberlieferung ON handschrift_ueberlieferung.HandschriftID ="
                    + " handschrift.ID JOIN selektion_ort ON selektion_ort.ID = handschrift_ueberlieferung.Schriftheimat"
                    + " JOIN ueberlieferung_edition ON ueberlieferung_edition.EditionID = :id AND ueberlieferung_edition.UeberlieferungID ="
                    + " handschrift_ueberlieferung.ID WHERE handschrift_ueberlieferung.QuelleID = :qId ORDER BY ueberlieferung_edition.Sigle ASC;";

            NativeQuery query = session.createNativeQuery(SQL);
            query.setParameter("qId", qId);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListNamenBearbeiterKorrektor(String modul, String id) throws Exception {
        try (Session session = getSession()) {
            String SQL = "SELECT benutzer.Nachname, benutzer.Vorname, namenkommentar_" + modul + ".Zeitstempel"
                    + " FROM namenkommentar, namenkommentar_" + modul + ", benutzer"
                    + " WHERE namenkommentar.ID = :id"
                    + " AND namenkommentar.ID = namenkommentar_" + modul + ".NamenkommentarID"
                    + " AND namenkommentar_" + modul + ".BenutzerID = benutzer.ID"
                    + " ORDER BY namenkommentar_" + modul + ".Zeitstempel ASC";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListLemmaBearbeiterKorrektor(String modul, String id) throws Exception {
        try (Session session = getSession()) {
            // Dynamisch den Modulnamen einfügen
            String SQL = "SELECT benutzer.Nachname, benutzer.Vorname, mgh_lemma_" + modul + ".Zeitstempel"
                    + " FROM mgh_lemma, mgh_lemma_" + modul + ", benutzer WHERE mgh_lemma.ID = :id"
                    + " AND mgh_lemma.ID = mgh_lemma_" + modul + ".MGHLemmaID AND mgh_lemma_" + modul + ".BenutzerID ="
                    + " benutzer.ID ORDER BY mgh_lemma_" + modul + ".Zeitstempel ASC;";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    //namenOrLemma mögliche eingaben sind: namenkommentar oder mghlemma
    public static List<Object[]> getListNamenLemmaBelege(String namenOrLemma, String id) throws Exception {
        try (Session session = getSession()) {

            String namenlemmaId = "MGHLemmaID";

            if(namenOrLemma.equals("namenkommentar")){
                namenlemmaId = "NamenkommentarID";
            }

             String SQL = "SELECT einzelbeleg.ID AS einzelbeleg_id, einzelbeleg.Belegnummer, einzelbeleg.Belegform,"
                    + " person.ID AS person_id, person.PKZ, person.Standardname, einzelbeleg.VonTag,"
                    + " einzelbeleg.VonMonat, einzelbeleg.VonJahr, einzelbeleg.VonJahrhundert, einzelbeleg.BisTag,"
                    + " einzelbeleg.BisMonat, einzelbeleg.BisJahr, einzelbeleg.BisJahrhundert FROM einzelbeleg_hat" + namenOrLemma
                    + " ,(einzelbeleg LEFT JOIN einzelbeleg_hatperson ON einzelbeleg.ID = einzelbeleg_hatperson.EinzelbelegID)"
                    + " LEFT JOIN person ON einzelbeleg_hatperson.PersonID = person.ID WHERE"

                    + " einzelbeleg_hat"+ namenOrLemma + "." + namenlemmaId + " = :id AND einzelbeleg_hat" + namenOrLemma + ".EinzelbelegID ="
                    + " einzelbeleg.ID ORDER BY einzelbeleg.VonJahr, einzelbeleg.VonMonat, einzelbeleg.VonTag ASC";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListQuelleEditionen(String id) throws Exception {
        try (Session session = getSession()) {

            String SQL = "SELECT edition.ID, edition.Zitierweise Bezeichnung FROM"
                    + " quelle_inedition, edition WHERE quelle_inedition.QuelleID = :id"
                    + " AND quelle_inedition.editionID=edition.ID ORDER BY Bezeichnung ASC";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListQuelleSignaturen(String edId, String id) throws Exception {
        try (Session session = getSession()) {

            String SQL = "SELECT handschrift.ID AS handschrift_id, handschrift.Bibliothekssignatur,"
                    + " handschrift_ueberlieferung.ID AS ueberlieferung_id, ueberlieferung_edition.Sigle, handschrift_ueberlieferung.VonTag, VonMonat, VonJahr,"
                    + " VonJahrhundert, BisTag, BisMonat, BisJahr, BisJahrhundert, selektion_ort.Bezeichnung FROM"
                    + " handschrift, (handschrift_ueberlieferung JOIN selektion_ort ON selektion_ort.ID ="
                    + " handschrift_ueberlieferung.Schriftheimat), ueberlieferung_edition WHERE"
                    + " handschrift_ueberlieferung.HandschriftID = handschrift.ID AND"
                    + " ueberlieferung_edition.EditionID = :edId AND ueberlieferung_edition.UeberlieferungID ="
                    + " handschrift_ueberlieferung.ID AND handschrift_ueberlieferung.QuelleID = :id ORDER BY"
                    + " ueberlieferung_edition.Sigle ASC";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("edId", edId);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListGastQuelleSignaturen(String edId, String id) throws Exception {
        try (Session session = getSession()) {

            String SQL = "SELECT handschrift.ID AS handschrift_id, handschrift.Bibliothekssignatur,"
                    + " handschrift_ueberlieferung.ID AS ueberlieferung_id, ueberlieferung_edition.Sigle,"
                    + " handschrift_ueberlieferung.VonJahrhundert, handschrift_ueberlieferung.BisJahrhundert,"
                    + " handschrift_ueberlieferung.VonJahr, handschrift_ueberlieferung.BisJahr,"
                    + " handschrift_ueberlieferung.VonMonat, handschrift_ueberlieferung.BisMonat,"
                    + " handschrift_ueberlieferung.VonTag, handschrift_ueberlieferung.BisTag,"
                    + " selektion_ort.Bezeichnung FROM handschrift, (handschrift_ueberlieferung JOIN"
                    + " selektion_ort ON selektion_ort.ID = handschrift_ueberlieferung.Schriftheimat),"
                    + " ueberlieferung_edition WHERE handschrift_ueberlieferung.HandschriftID = handschrift.ID AND"
                    + " ueberlieferung_edition.EditionID = :edId AND ueberlieferung_edition.UeberlieferungID ="
                    + " handschrift_ueberlieferung.ID AND"
                    + " handschrift_ueberlieferung.QuelleID = :id ORDER BY ueberlieferung_edition.Sigle ASC";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("edId", edId);
            query.setParameter("id", id);

            return query.getResultList();
        }
    }

    public static List<Object[]> getListGastQuelleEditionen(String standard, String id) throws Exception {
        try (Session session = getSession()) {

            String SQL = "Select e.ID, e.Titel, r.Bezeichnung as Reihe, e.BandNummer as Band,"
                    + " o. Bezeichnung as Ort, e.Jahr, qi.Seiten AS qiSeiten, e.Seiten AS eSeiten, qi.Nummer"
                    + " from ((edition e join quelle_inedition qi on e.ID=qi.EditionID) left join"
                    + " selektion_reihe r on e.ReiheID=r.ID) left join selektion_ort o on"
                    + " e.OrtID=o.ID where qi.QuelleID = :id and qi.Standard = :standard ";

            NativeQuery<Object[]> query = session.createNativeQuery(SQL);
            query.setParameter("id", id);
            query.setParameter("standard", standard);

            return query.getResultList();
        }
    }

    public static List<String> getListGastQuelleEditionHerausgeber(String eId) throws Exception {
        try (Session session = getSession()) {

            String SQL = "select s.Bezeichnung from selektion_editor s, edition_hateditor ehe where ehe.EditionID= :eId AND ehe.EditorID=s.ID";

            NativeQuery<String> query = session.createNativeQuery(SQL);
            query.setParameter("eId", eId);

            return query.getResultList();
        }
    }
}
