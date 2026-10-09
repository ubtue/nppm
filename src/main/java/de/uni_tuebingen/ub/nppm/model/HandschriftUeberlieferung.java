package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import javax.persistence.*;
import java.util.*;

@Entity
@Table(name = "handschrift_ueberlieferung")
public class HandschriftUeberlieferung implements History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Quelle.class)
    @JoinColumn(name = "QuelleID", referencedColumnName = "ID")
    private Quelle quelle;

    @Column(name = "Sigle", length = 255)
    private String sigle;

    @Column(name = "Bibliothekssignatur", length = 255)
    private String bibliothekssignatur;

    @Column(name = "VonTag")
    private Integer vonTag;

    @Column(name = "VonMonat")
    private Integer vonMonat;

    @Column(name = "VonJahr")
    private Integer vonJahr;

    @Column(name = "VonJahrhundert", length = 5)
    private String vonJahrhundert;

    @Column(name = "BisTag")
    private Integer bisTag;

    @Column(name = "BisMonat")
    private Integer bisMonat;

    @Column(name = "BisJahr")
    private Integer bisJahr;

    @Column(name = "BisJahrhundert", length = 5)
    private String bisJahrhundert;

    @Column(name = "Schriftherkunft", length = 255)
    private String schriftherkunft;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonTag", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitVonTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonMonat", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitVonMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonJahr", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitVonJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonJahrhundert", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitVonJahrhundert;

    @ManyToOne(targetEntity = SelektionOrt.class)
    @JoinColumn(name = "Schriftheimat", referencedColumnName = "ID")
    private SelektionOrt schriftheimat;

    @Column(name = "UeberlieferungDatierung", length = 255)
    private String ueberlieferungDatierung;

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

    @ManyToOne(targetEntity = Handschrift.class)
    @JoinColumn(name = "HandschriftID", referencedColumnName = "ID")
    private Handschrift handschrift;

    @ManyToOne(targetEntity = SelektionOrt.class)
    @JoinColumn(name = "Bibliotheksheimat", referencedColumnName = "ID")
    private SelektionOrt bibliotheksheimat;

    @Column(name = "GenauigkeitBisTag")
    private Integer genauigkeitBisTag;

    @Column(name = "GenauigkeitBisMonat")
    private Integer genauigkeitBisMonat;

    @Column(name = "GenauigkeitBisJahr")
    private Integer genauigkeitBisJahr;

    @Column(name = "GenauigkeitBisJahrhundert")
    private Integer genauigkeitBisJahrhundert;

    @OneToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName = "ID")
    private Edition edition;

    public Integer getId() {
        return id;
    }

    public Quelle getQuelle() {
        return quelle;
    }

    public void setQuelle(Quelle quelle) {
        this.quelle = quelle;
    }

    public String getSigle() {
        return sigle;
    }

    public void setSigle(String sigle) {
        this.sigle = sigle;
    }

    public String getBibliothekssignatur() {
        return bibliothekssignatur;
    }

    public void setBibliothekssignatur(String bibliothekssignatur) {
        this.bibliothekssignatur = bibliothekssignatur;
    }

    public Integer getVonTag() {
        return vonTag;
    }

    public void setVonTag(Integer vonTag) {
        this.vonTag = vonTag;
    }

    public Integer getVonMonat() {
        return vonMonat;
    }

    public void setVonMonat(Integer vonMonat) {
        this.vonMonat = vonMonat;
    }

    public Integer getVonJahr() {
        return vonJahr;
    }

    public void setVonJahr(Integer vonJahr) {
        this.vonJahr = vonJahr;
    }

    public String getVonJahrhundert() {
        return vonJahrhundert;
    }

    public void setVonJahrhundert(String vonJahrhundert) {
        this.vonJahrhundert = vonJahrhundert;
    }

    public Integer getBisTag() {
        return bisTag;
    }

    public void setBisTag(Integer bisTag) {
        this.bisTag = bisTag;
    }

    public Integer getBisMonat() {
        return bisMonat;
    }

    public void setBisMonat(Integer bisMonat) {
        this.bisMonat = bisMonat;
    }

    public Integer getBisJahr() {
        return bisJahr;
    }

    public void setBisJahr(Integer bisJahr) {
        this.bisJahr = bisJahr;
    }

    public String getBisJahrhundert() {
        return bisJahrhundert;
    }

    public void setBisJahrhundert(String bisJahrhundert) {
        this.bisJahrhundert = bisJahrhundert;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonTag() {
        return genauigkeitVonTag;
    }

    public void setGenauigkeitVonTag(SelektionDatGenauigkeit genauigkeitVonTag) {
        this.genauigkeitVonTag = genauigkeitVonTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonMonat() {
        return genauigkeitVonMonat;
    }

    public void setGenauigkeitVonMonat(SelektionDatGenauigkeit genauigkeitVonMonat) {
        this.genauigkeitVonMonat = genauigkeitVonMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonJahr() {
        return genauigkeitVonJahr;
    }

    public void setGenauigkeitVonJahr(SelektionDatGenauigkeit genauigkeitVonJahr) {
        this.genauigkeitVonJahr = genauigkeitVonJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonJahrhundert() {
        return genauigkeitVonJahrhundert;
    }

    public void setGenauigkeitVonJahrhundert(SelektionDatGenauigkeit genauigkeitVonJahrhundert) {
        this.genauigkeitVonJahrhundert = genauigkeitVonJahrhundert;
    }

    public SelektionOrt getSchriftheimat() {
        return schriftheimat;
    }

    public void setSchriftheimat(SelektionOrt schriftheimat) {
        this.schriftheimat = schriftheimat;
    }

    public String getUeberlieferungDatierung() {
        return ueberlieferungDatierung;
    }

    public void setUeberlieferungDatierung(String ueberlieferungDatierung) {
        this.ueberlieferungDatierung = ueberlieferungDatierung;
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

    public Handschrift getHandschrift() {
        return handschrift;
    }

    public void setHandschrift(Handschrift handschrift) {
        this.handschrift = handschrift;
    }

    public SelektionOrt getBibliotheksheimat() {
        return bibliotheksheimat;
    }

    public void setBibliotheksheimat(SelektionOrt bibliotheksheimat) {
        this.bibliotheksheimat = bibliotheksheimat;
    }

    public Integer getGenauigkeitBisTag() {
        return genauigkeitBisTag;
    }

    public void setGenauigkeitBisTag(Integer genauigkeitBisTag) {
        this.genauigkeitBisTag = genauigkeitBisTag;
    }

    public Integer getGenauigkeitBisMonat() {
        return genauigkeitBisMonat;
    }

    public void setGenauigkeitBisMonat(Integer genauigkeitBisMonat) {
        this.genauigkeitBisMonat = genauigkeitBisMonat;
    }

    public Integer getGenauigkeitBisJahr() {
        return genauigkeitBisJahr;
    }

    public void setGenauigkeitBisJahr(Integer genauigkeitBisJahr) {
        this.genauigkeitBisJahr = genauigkeitBisJahr;
    }

    public Integer getGenauigkeitBisJahrhundert() {
        return genauigkeitBisJahrhundert;
    }

    public void setGenauigkeitBisJahrhundert(Integer genauigkeitBisJahrhundert) {
        this.genauigkeitBisJahrhundert = genauigkeitBisJahrhundert;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public String getSchriftherkunft() {
        return schriftherkunft;
    }

    public void setSchriftherkunft(String schriftherkunft) {
        this.schriftherkunft = schriftherkunft;
    }
}
