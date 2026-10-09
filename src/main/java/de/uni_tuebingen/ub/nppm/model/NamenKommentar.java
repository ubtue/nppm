package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import de.uni_tuebingen.ub.nppm.util.Utils;
import java.util.*;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import org.json.JSONObject;

@Entity
@Table(name = "namenkommentar")
public class NamenKommentar implements PersistentIdentifier, History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private int id;

    @Column(name = "ELemma", length = 255)
    private String eLemma;

    @Column(name = "PLemma", length = 255)
    private String pLemma;

    @Column(name = "Suffix", length = 255)
    private String mghLemma;

    @Column(name = "Dateiname", length = 255)
    private String dateiname;

    @Column(name = "Hinweise", columnDefinition="LONGTEXT")
    private String hinweise;

    @Column(name = "Protokoll", columnDefinition="LONGTEXT")
    private String protokoll;

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

    @Column(name = "Rekonstruktion")
    private Integer rekonstruktion;

    @ManyToMany(mappedBy = "namenKommentar")
    private Set<Einzelbeleg> einzelbeleg = new HashSet<>();

    public int getId() {
        return id;
    }

    @Override
    public String getPersistentIdentifier() {
        return "N" + getId();
    }

    public String geteLemma() {
        return eLemma;
    }

    public void seteLemma(String eLemma) {
        this.eLemma = eLemma;
    }

    public String getpLemma() {
        return pLemma;
    }

    public void setpLemma(String pLemma) {
        this.pLemma = pLemma;
    }

    public String getMghLemma() {
        return mghLemma;
    }

    public void setMghLemma(String mghLemma) {
        this.mghLemma = mghLemma;
    }

    public String getDateiname() {
        return dateiname;
    }

    public void setDateiname(String dateiname) {
        this.dateiname = dateiname;
    }

    public String getHinweise() {
        return hinweise;
    }

    public void setHinweise(String hinweise) {
        this.hinweise = hinweise;
    }

    public String getProtokoll() {
        return protokoll;
    }

    public void setProtokoll(String protokoll) {
        this.protokoll = protokoll;
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

    @Override
    public Date getErstellt() {
        return erstellt;
    }

    @Override
    public void setErstellt(Date erstellt) {
        this.erstellt = erstellt;
    }

    @Override
    public Benutzer getErstelltVon() {
        return erstelltVon;
    }

    @Override
    public void setErstelltVon(Benutzer erstelltVon) {
        this.erstelltVon = erstelltVon;
    }

    public BenutzerGruppe getGehoertGruppe() {
        return gehoertGruppe;
    }

    public void setGehoertGruppe(BenutzerGruppe gehoertGruppe) {
        this.gehoertGruppe = gehoertGruppe;
    }

    public Integer getRekonstruktion() {
        return rekonstruktion;
    }

    public void setRekonstruktion(Integer rekonstruktion) {
        this.rekonstruktion = rekonstruktion;
    }

    public Set<Einzelbeleg> getEinzelbeleg() {
        return einzelbeleg;
    }

    public void addEinzelbeleg(Einzelbeleg beleg) {
        this.getEinzelbeleg().add(beleg);
    }

    public void removeEinzelbeleg(int id) {
        this.getEinzelbeleg().removeIf(e -> e.getId() == id);
    }

    public JSONObject getJSON() {
        JSONObject jsonObject = new JSONObject();

        // Felder hinzufügen und direkt bereinigen
        Utils.addIfValid(jsonObject, "ELemma", Utils.sanitize(this.geteLemma()));
        Utils.addIfValid(jsonObject, "PLemma", Utils.sanitize(this.getpLemma()));
        Utils.addIfValid(jsonObject, "MGHLemma", Utils.sanitize(this.getMghLemma()));
        Utils.addIfValid(jsonObject, "bearbeitungsstatus",
                Utils.sanitize(this.getBearbeitungsstatus() != null ? this.getBearbeitungsstatus().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "gehoertGruppe",
                Utils.sanitize(this.getGehoertGruppe() != null ? this.getGehoertGruppe().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "hinweise", Utils.sanitize(this.getHinweise()));
        Utils.addIfValid(jsonObject, "protokoll", Utils.sanitize(this.getProtokoll()));
        Utils.addIfValid(jsonObject, "dateiname", Utils.sanitize(this.getDateiname()));
        Utils.addIfValid(jsonObject, "id", "N" + this.getId());

        return jsonObject;
    }

}
