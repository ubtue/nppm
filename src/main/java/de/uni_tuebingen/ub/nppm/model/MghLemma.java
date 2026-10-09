package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import de.uni_tuebingen.ub.nppm.util.Utils;
import java.util.*;
import javax.persistence.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.json.JSONObject;

@Entity
@Table(name = "mgh_lemma")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MghLemma implements PersistentIdentifier, History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private int id;

    @Column(name = "MGHLemma", length = 255)
    private String mghLemma;

    @ManyToOne(targetEntity = SelektionSprachherkunft.class)
    @JoinColumn(name = "SprachherkunftID", referencedColumnName = "ID")
    private SelektionSprachherkunft sprachherkunft;

    @ManyToOne(targetEntity = SelektionBearbeitungsstatus.class)
    @JoinColumn(name = "BearbeitungsstatusID", referencedColumnName = "ID")
    private SelektionBearbeitungsstatus bearbeitungsstatus;

    @Column(name = "LetzteAenderung")
    private Date letzteAenderung;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "LetzteAenderungVon", referencedColumnName = "ID")
    private Benutzer letzteAenderungVon;

    @Column(name = "Erstellt")
    private Date erstellt;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "ErstelltVon", referencedColumnName = "ID")
    private Benutzer erstelltVon;

    @ManyToOne(targetEntity = BenutzerGruppe.class)
    @JoinColumn(name = "GehoertGruppe", referencedColumnName = "ID")
    private BenutzerGruppe gehoertGruppe;

    @ManyToMany(mappedBy = "mghLemma")
    private Set<Einzelbeleg> einzelbelege = new HashSet<>();

    public int getId() {
        return id;
    }

    public String getDebugString() {
        return getPersistentIdentifier() + " (" + getMghLemma() + ")";
    }

    @Override
    public String getPersistentIdentifier() {
        return "M" + getId();
    }

    public String getMghLemma() {
        return mghLemma;
    }

    public void setMghLemma(String mghLemma) {
        this.mghLemma = mghLemma;
    }

    protected String[] getGlieder() {
        return getMghLemma().split("~");
    }

    public String getErstglied() {
        String[] glieder = getGlieder();
        if (glieder.length >= 1)
            return glieder[0];
        return null;
    }

    public String getZweitglied() {
        String[] glieder = getGlieder();
        if (glieder.length >= 2)
            return glieder[1];
        return null;
    }

    public SelektionSprachherkunft getSprachherkunft() {
        return sprachherkunft;
    }

    public void setSprachherkunft(SelektionSprachherkunft sprachherkunft) {
        this.sprachherkunft = sprachherkunft;
    }

    public SelektionBearbeitungsstatus getBearbeitungsstatus() {
        return bearbeitungsstatus;
    }

    public void setBearbeitungsstatus(SelektionBearbeitungsstatus bearbeitungsstatus) {
        this.bearbeitungsstatus = bearbeitungsstatus;
    }

    @Override
    public Date getLetzteAenderung() {
        return letzteAenderung;
    }

    @Override
    public void setLetzteAenderung(Date letzteAenderung) {
        this.letzteAenderung = letzteAenderung;
    }

    @Override
    public Benutzer getLetzteAenderungVon() {
        return letzteAenderungVon;
    }

    @Override
    public void setLetzteAenderungVon(Benutzer letzteAenderungVon) {
        this.letzteAenderungVon = letzteAenderungVon;
    }

    public Date getErstellt() {
        return erstellt;
    }

    public void setErstellt(Date erstellt) {
        this.erstellt = erstellt;
    }

    public Benutzer getErstelltVon() {
        return erstelltVon;
    }

    public void setErstelltVon(Benutzer erstelltVon) {
        this.erstelltVon = erstelltVon;
    }

    public BenutzerGruppe getGehoertGruppe() {
        return gehoertGruppe;
    }

    public void setGehoertGruppe(BenutzerGruppe gehoertGruppe) {
        this.gehoertGruppe = gehoertGruppe;
    }

    public Set<Einzelbeleg> getEinzelbelege() {
        return einzelbelege;
    }

    public void addEinzelbeleg(Einzelbeleg person) {
        this.getEinzelbelege().add(person);
    }

    public void removeEinzelbeleg(int id) {
        this.getEinzelbelege().removeIf(e -> e.getId() == id);
    }

    public JSONObject getJSON() {
        JSONObject jsonObject = new JSONObject();

        // Felder hinzufügen und direkt bereinigen
        Utils.addIfValid(jsonObject, "mghLemma", Utils.sanitize(this.getMghLemma()));
        Utils.addIfValid(jsonObject, "bearbeitungsstatus", Utils.sanitize(this.getBearbeitungsstatus() != null ? this.getBearbeitungsstatus().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "gehoertGruppe", Utils.sanitize(this.getGehoertGruppe() != null ? this.getGehoertGruppe().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "erstellt", this.getErstellt() != null ? Utils.formatDate(this.getErstellt()) : null);
        Utils.addIfValid(jsonObject, "id", "M" + this.getId());

        return jsonObject;
    }
}
