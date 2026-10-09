package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import javax.persistence.*;
import java.util.*;

@Entity
@Table(name = "edition")
public class Edition implements PersistentIdentifier, History {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "Titel", length=255)
    private String titel;

    @Column(name = "Jahr", length=255)
    private String jahr;

    @Column(name = "Seiten", length=255)
    private String seiten;

    @Column(name = "Zitierweise", length=255)
    private String zitierweise;

    @ManyToOne(targetEntity = SelektionOrt.class)
    @JoinColumn(name = "OrtID", referencedColumnName="ID")
    private SelektionOrt ort;

    @ManyToOne(targetEntity = SelektionReihe.class)
    @JoinColumn(name = "ReiheID", referencedColumnName="ID")
    private SelektionReihe reihe;

    @ManyToOne(targetEntity = SelektionSammelband.class)
    @JoinColumn(name = "SammelbandID", referencedColumnName="ID")
    private SelektionSammelband sammelband;

    @Column(name = "Verbindlich", columnDefinition="INTEGER DEFAULT NULL")
    private Boolean verbindlich;

    @ManyToOne(targetEntity = SelektionBearbeitungsstatus.class)
    @JoinColumn(name = "BearbeitungsstatusID", referencedColumnName="ID")
    private SelektionBearbeitungsstatus bearbeitungsstatus;

    @Column(name = "LetzteAenderung")
    private Date letzteAenderung;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "LetzteAenderungVon", referencedColumnName="ID")
    private Benutzer letzteAenderungVon;

    @Column(name = "Erstellt")
    private Date erstellt;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "ErstelltVon", referencedColumnName="ID")
    private Benutzer erstelltVon;

    @ManyToOne(targetEntity = BenutzerGruppe.class)
    @JoinColumn(name = "GehoertGruppe", referencedColumnName="ID")
    private BenutzerGruppe gehoertGruppe;

    @Column(name = "BandNummer", length=100)
    private String bandNummer;

    @ManyToOne(targetEntity = SelektionDmghBand.class)
    @JoinColumn(name = "dMGHBandID", referencedColumnName="ID")
    private SelektionDmghBand dMGHBand;

    @ManyToMany(cascade = {CascadeType.REFRESH,CascadeType.MERGE,CascadeType.REFRESH,CascadeType.DETACH})
    @JoinTable(
        name = "edition_hateditor",
        joinColumns = { @JoinColumn(name = "EditionID") },
        inverseJoinColumns = { @JoinColumn(name = "EditorID") }
    )
    Set<SelektionEditor> editors = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH,CascadeType.MERGE,CascadeType.REFRESH,CascadeType.DETACH})
    @JoinTable(
            name = "quelle_inedition",
            joinColumns = {
                @JoinColumn(name = "EditionID")},
            inverseJoinColumns = {
                @JoinColumn(name = "QuelleID")}
    )
    Set<Quelle> quellen = new HashSet<>();

    public Set<SelektionEditor> getEditors() {
        return editors;
    }

    public void addEditor(SelektionEditor editor){
        this.getEditors().add(editor);
    }

    public void removeEditor(int id){
        this.getEditors().removeIf(e -> e.getId() == id);
    }

    public Set<Quelle> getQuellen() {
        return quellen;
    }

    public void addQuelle(Quelle q) {
        this.getQuellen().add(q);
    }

    public void removeQuelle(int id) {
        this.getQuellen().removeIf(q -> q.getId() == id);
    }

    public Integer getId() {
        return id;
    }

    @Override
    public String getPersistentIdentifier() {
        return "E" + getId();
    }

    public String getTitel() {
        return titel;
    }

    public void setTitel(String titel) {
        this.titel = titel;
    }

    public String getJahr() {
        return jahr;
    }

    public void setJahr(String jahr) {
        this.jahr = jahr;
    }

    public String getSeiten() {
        return seiten;
    }

    public void setSeiten(String seiten) {
        this.seiten = seiten;
    }

    public String getZitierweise() {
        return zitierweise;
    }

    public void setZitierweise(String zitierweise) {
        this.zitierweise = zitierweise;
    }

    public SelektionOrt getOrt() {
        return ort;
    }

    public void setOrt(SelektionOrt ort) {
        this.ort = ort;
    }

    public SelektionReihe getReihe() {
        return reihe;
    }

    public void setReihe(SelektionReihe reihe) {
        this.reihe = reihe;
    }

    public SelektionSammelband getSammelband() {
        return sammelband;
    }

    public void setSammelband(SelektionSammelband sammelband) {
        this.sammelband = sammelband;
    }

    public Boolean getVerbindlich() {
        return verbindlich;
    }

    public void setVerbindlich(Boolean verbindlich) {
        this.verbindlich = verbindlich;
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

    public String getBandNummer() {
        return bandNummer;
    }

    public void setBandNummer(String bandNummer) {
        this.bandNummer = bandNummer;
    }

    public SelektionDmghBand getdMGHBand() {
        return dMGHBand;
    }

    public void setdMGHBand(SelektionDmghBand dMGHBand) {
        this.dMGHBand = dMGHBand;
    }

}
