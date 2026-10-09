package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import de.uni_tuebingen.ub.nppm.util.Utils;
import javax.persistence.*;
import java.util.*;
import org.json.JSONObject;

@Entity
@Table(name = "einzelbeleg")
public class Einzelbeleg implements PersistentIdentifier, History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "Belegnummer", length = 10)
    private String belegnummer;

    @Column(name = "Kontext", columnDefinition = "MEDIUMTEXT")
    private String kontext;

    @ManyToOne(targetEntity = SelektionGeschlecht.class)
    @JoinColumn(name = "GeschlechtID", referencedColumnName = "ID")
    private SelektionGeschlecht geschlecht;

    @ManyToOne(targetEntity = SelektionLebendVerstorben.class)
    @JoinColumn(name = "LebendVerstorbenID", referencedColumnName = "ID")
    private SelektionLebendVerstorben lebendVerstorben;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName = "ID")
    private Edition edition;

    @ManyToOne(targetEntity = Quelle.class)
    @JoinColumn(name = "QuelleID", referencedColumnName = "ID")
    private Quelle quelle;

    @ManyToOne(targetEntity = Handschrift.class)
    @JoinColumn(name = "HandschriftID", referencedColumnName = "ID")
    private Handschrift handschrift;

    @Column(name = "EditionKapitel", length = 255)
    private String editionKapitel;

    @Column(name = "EditionSeite", length = 255)
    private String editionSeite;

    @ManyToOne(targetEntity = SelektionEchtheit.class)
    @JoinColumn(name = "QuelleEchtheitID", referencedColumnName = "ID")
    private SelektionEchtheit quelleEchtheit;

    @Column(name = "QuelleDatierung", length = 255)
    private String quelleDatierung;

    @Column(name = "UeberlieferungDatierung", length = 255)
    private String ueberlieferungDatierung;

    @Column(name = "Belegform", length = 191)
    private String belegform;

    @Column(name = "Griechisch", length = 255)
    private String griechisch;

    @Column(name = "Diakritisch", length = 255)
    private String diakritisch;

    @ManyToOne(targetEntity = SelektionKasus.class)
    @JoinColumn(name = "KasusID", referencedColumnName = "ID")
    private SelektionKasus kasus;

    @ManyToOne(targetEntity = SelektionGrammatikgeschlecht.class)
    @JoinColumn(name = "GrammatikGeschlechtID", referencedColumnName = "ID")
    private SelektionGrammatikgeschlecht grammatikGeschlecht;

    @Column(name = "ASWQuellenzitat", columnDefinition = "MEDIUMTEXT")
    private String aswQuellenzitat;

    @Column(name = "Bemerkung", columnDefinition = "MEDIUMTEXT")
    private String bemerkung;

    @ManyToOne(targetEntity = SelektionBearbeitungsstatus.class)
    @JoinColumn(name = "BearbeitungsstatusID", referencedColumnName = "ID")
    private SelektionBearbeitungsstatus bearbeitungsstatus;

    @Column(name = "KommentarEthnie", columnDefinition = "MEDIUMTEXT")
    private String kommentarEthnie;

    @Column(name = "KommentarAreal", columnDefinition = "MEDIUMTEXT")
    private String kommentarAreal;

    @Column(name = "KommentarVerwandtschaft", columnDefinition = "MEDIUMTEXT")
    private String kommentarVerwandtschaft;

    @Column(name = "Eindeutig", columnDefinition = "BIT DEFAULT NULL")
    private Boolean eindeutig;

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

    @Column(name = "DatierungUngewiss", columnDefinition = "TINYINT(1)")
    private Boolean datierungUngewiss;

    @Column(name = "KommentarDatierung", length = 255)
    private String kommentarDatierung;

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

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisTag", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitBisTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisMonat", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitBisMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisJahr", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitBisJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisJahrhundert", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitBisJahrhundert;

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

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleBisTag", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleBisTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleBisMonat", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleBisMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleBisJahr", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleBisJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleBisJahrhundert", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleBisJahrhundert;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleVonTag", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleVonTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleVonMonat", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleVonMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleVonJahr", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleVonJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitQuelleVonJahrhundert", referencedColumnName = "ID")
    private SelektionDatGenauigkeit genauigkeitQuelleVonJahrhundert;

    @Column(name = "QuelleBisTag")
    private Integer quelleBisTag;

    @Column(name = "QuelleBisMonat")
    private Integer quelleBisMonat;

    @Column(name = "QuelleBisJahr")
    private Integer quelleBisJahr;

    @Column(name = "QuelleBisJahrhundert", length = 5)
    private String quelleBisJahrhundert;

    @Column(name = "QuelleVonTag")
    private Integer quelleVonTag;

    @Column(name = "QuelleVonMonat")
    private Integer quelleVonMonat;

    @Column(name = "QuelleVonJahr")
    private Integer quelleVonJahr;

    @Column(name = "QuelleVonJahrhundert", length = 5)
    private String quelleVonJahrhundert;

    @Column(name = "KommentarPerson", columnDefinition = "MEDIUMTEXT")
    private String kommentarPerson;

    @Column(name = "MGHLemmaKorrigiert", columnDefinition = "BIT DEFAULT NULL")
    private Boolean mghLemmaKorrigiert;

    @Column(name = "KritikID")
    private Integer kritikId;

    @Column(name = "TitelText", length = 255)
    private String titelText;

    @Column(name = "nr_in_strukt", length = 255)
    private String nummerInStruktur;

    @Column(name = "seite", length = 255)
    private String seite;

    @Column(name = "raster", length = 255)
    private String raster;

    @Column(name = "schreiber", length = 255)
    private String schreiber;

    @ManyToOne(targetEntity = SelektionBeziehungGemeinschaft.class)
    @JoinColumn(name = "BeziehungGemeinschaftID", referencedColumnName = "ID")
    private SelektionBeziehungGemeinschaft beziehungGemeinschaft;

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatamtweihe",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "AmtWeiheID")}
    )
    Set<SelektionAmtWeihe> amtWeihe = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatareal",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "ArealID")}
    )
    Set<SelektionAreal> areal = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatareal",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "ArealTypID")}
    )
    Set<SelektionArealTyp> arealTyp = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatfunktion",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "FunktionID")}
    )
    Set<SelektionFunktion> funktion = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatmghlemma",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "MGHLemmaID")}
    )
    Set<MghLemma> mghLemma = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatnamenkommentar",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "NamenkommentarID")}
    )
    Set<NamenKommentar> namenKommentar = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatperson",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "PersonID")}
    )
    Set<Person> person = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatstand",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "StandID")}
    )
    Set<SelektionStand> stand = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hatangabe",
            joinColumns = @JoinColumn(name = "EinzelbelegID"),
            inverseJoinColumns = @JoinColumn(name = "AngabeID")
    )
    private Set<SelektionAngabe> angaben = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
            name = "einzelbeleg_hattitelkritik",
            joinColumns = {
                @JoinColumn(name = "EinzelbelegID")},
            inverseJoinColumns = {
                @JoinColumn(name = "TitelkritikID")}
    )
    private Set<SelektionKritik> titelKritiken = new HashSet<>();

    public Integer getId() {
        return id;
    }

    @Override
    public String getPersistentIdentifier() {
        return "B" + getId();
    }

    public String getDebugString() {
        return getPersistentIdentifier() + " (" + getBelegform() + ")";
    }

    public String getBelegnummer() {
        return belegnummer;
    }

    public String getKontext() {
        return kontext;
    }

    public SelektionGeschlecht getGeschlecht() {
        return geschlecht;
    }

    public SelektionLebendVerstorben getLebendVerstorben() {
        return lebendVerstorben;
    }

    public Edition getEdition() {
        return edition;
    }

    public Quelle getQuelle() {
        return quelle;
    }

    public Handschrift getHandschrift() {
        return handschrift;
    }

    public String getEditionKapitel() {
        return editionKapitel;
    }

    public String getEditionSeite() {
        return editionSeite;
    }

    public SelektionEchtheit getQuelleEchtheit() {
        return quelleEchtheit;
    }

    public String getQuelleDatierung() {
        return quelleDatierung;
    }

    public String getUeberlieferungDatierung() {
        return ueberlieferungDatierung;
    }

    public String getBelegform() {
        return belegform;
    }

    public String getGriechisch() {
        return griechisch;
    }

    public String getDiakritisch() {
        return diakritisch;
    }

    public SelektionKasus getKasus() {
        return kasus;
    }

    public SelektionGrammatikgeschlecht getGrammatikGeschlecht() {
        return grammatikGeschlecht;
    }

    public String getAswQuellenzitat() {
        return aswQuellenzitat;
    }

    public String getBemerkung() {
        return bemerkung;
    }

    public SelektionBearbeitungsstatus getBearbeitungsstatus() {
        return bearbeitungsstatus;
    }

    public String getKommentarEthnie() {
        return kommentarEthnie;
    }

    public String getKommentarAreal() {
        return kommentarAreal;
    }

    public String getKommentarVerwandtschaft() {
        return kommentarVerwandtschaft;
    }

    public Boolean getEindeutig() {
        return eindeutig;
    }

    public Integer getVonTag() {
        return vonTag;
    }

    public Integer getVonMonat() {
        return vonMonat;
    }

    public Integer getVonJahr() {
        return vonJahr;
    }

    public String getVonJahrhundert() {
        return vonJahrhundert;
    }

    public Integer getBisTag() {
        return bisTag;
    }

    public Integer getBisMonat() {
        return bisMonat;
    }

    public Integer getBisJahr() {
        return bisJahr;
    }

    public String getBisJahrhundert() {
        return bisJahrhundert;
    }

    public Boolean getDatierungUngewiss() {
        return datierungUngewiss;
    }

    public String getKommentarDatierung() {
        return kommentarDatierung;
    }

    @Override
    public Date getLetzteAenderung() {
        return letzteAenderung;
    }

    @Override
    public Benutzer getLetzteAenderungVon() {
        return letzteAenderungVon;
    }

    public Date getErstellt() {
        return erstellt;
    }

    public Benutzer getErstelltVon() {
        return erstelltVon;
    }

    public BenutzerGruppe getGehoertGruppe() {
        return gehoertGruppe;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisTag() {
        return genauigkeitBisTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisMonat() {
        return genauigkeitBisMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisJahr() {
        return genauigkeitBisJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisJahrhundert() {
        return genauigkeitBisJahrhundert;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonTag() {
        return genauigkeitVonTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonMonat() {
        return genauigkeitVonMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonJahr() {
        return genauigkeitVonJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitVonJahrhundert() {
        return genauigkeitVonJahrhundert;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleBisTag() {
        return genauigkeitQuelleBisTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleBisMonat() {
        return genauigkeitQuelleBisMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleBisJahr() {
        return genauigkeitQuelleBisJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleBisJahrhundert() {
        return genauigkeitQuelleBisJahrhundert;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleVonTag() {
        return genauigkeitQuelleVonTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleVonMonat() {
        return genauigkeitQuelleVonMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleVonJahr() {
        return genauigkeitQuelleVonJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitQuelleVonJahrhundert() {
        return genauigkeitQuelleVonJahrhundert;
    }

    public Integer getQuelleBisTag() {
        return quelleBisTag;
    }

    public Integer getQuelleBisMonat() {
        return quelleBisMonat;
    }

    public Integer getQuelleBisJahr() {
        return quelleBisJahr;
    }

    public String getQuelleBisJahrhundert() {
        return quelleBisJahrhundert;
    }

    public Integer getQuelleVonTag() {
        return quelleVonTag;
    }

    public Integer getQuelleVonMonat() {
        return quelleVonMonat;
    }

    public Integer getQuelleVonJahr() {
        return quelleVonJahr;
    }

    public String getQuelleVonJahrhundert() {
        return quelleVonJahrhundert;
    }

    public String getKommentarPerson() {
        return kommentarPerson;
    }

    public Boolean getMghLemmaKorrigiert() {
        return mghLemmaKorrigiert;
    }

    public Set<SelektionAmtWeihe> getAmtWeihe() {
        return amtWeihe;
    }

    public Set<SelektionAreal> getAreal() {
        return areal;
    }

    public Set<SelektionFunktion> getFunktion() {
        return funktion;
    }

    public Set<MghLemma> getMghLemma() {
        return mghLemma;
    }

    public Set<NamenKommentar> getNamenKommentar() {
        return namenKommentar;
    }

    public Set<Person> getPerson() {
        return person;
    }

    public Set<SelektionStand> getStand() {
        return stand;
    }

    public void setBelegnummer(String belegnummer) {
        this.belegnummer = belegnummer;
    }

    public void setKontext(String kontext) {
        this.kontext = kontext;
    }

    public void setGeschlecht(SelektionGeschlecht geschlecht) {
        this.geschlecht = geschlecht;
    }

    public void setLebendVerstorben(SelektionLebendVerstorben lebendVerstorben) {
        this.lebendVerstorben = lebendVerstorben;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public void setQuelle(Quelle quelle) {
        this.quelle = quelle;
    }

    public void setHandschrift(Handschrift handschrift) {
        this.handschrift = handschrift;
    }

    public void setEditionKapitel(String editionKapitel) {
        this.editionKapitel = editionKapitel;
    }

    public void setEditionSeite(String editionSeite) {
        this.editionSeite = editionSeite;
    }

    public void setQuelleEchtheit(SelektionEchtheit quelleEchtheit) {
        this.quelleEchtheit = quelleEchtheit;
    }

    public void setQuelleDatierung(String quelleDatierung) {
        this.quelleDatierung = quelleDatierung;
    }

    public void setUeberlieferungDatierung(String ueberlieferungDatierung) {
        this.ueberlieferungDatierung = ueberlieferungDatierung;
    }

    public void setBelegform(String belegform) {
        this.belegform = belegform;
    }

    public void setGriechisch(String griechisch) {
        this.griechisch = griechisch;
    }

    public void setDiakritisch(String diakritisch) {
        this.diakritisch = diakritisch;
    }

    public void setKasus(SelektionKasus kasus) {
        this.kasus = kasus;
    }

    public void setGrammatikGeschlecht(SelektionGrammatikgeschlecht grammatikGeschlecht) {
        this.grammatikGeschlecht = grammatikGeschlecht;
    }

    public void setAswQuellenzitat(String aswQuellenzitat) {
        this.aswQuellenzitat = aswQuellenzitat;
    }

    public void setBemerkung(String bemerkung) {
        this.bemerkung = bemerkung;
    }

    public void setBearbeitungsstatus(SelektionBearbeitungsstatus bearbeitungsstatus) {
        this.bearbeitungsstatus = bearbeitungsstatus;
    }

    public void setKommentarEthnie(String kommentarEthnie) {
        this.kommentarEthnie = kommentarEthnie;
    }

    public void setKommentarAreal(String kommentarAreal) {
        this.kommentarAreal = kommentarAreal;
    }

    public void setKommentarVerwandtschaft(String kommentarVerwandtschaft) {
        this.kommentarVerwandtschaft = kommentarVerwandtschaft;
    }

    public void setEindeutig(Boolean eindeutig) {
        this.eindeutig = eindeutig;
    }

    public void setVonTag(Integer vonTag) {
        this.vonTag = vonTag;
    }

    public void setVonMonat(Integer vonMonat) {
        this.vonMonat = vonMonat;
    }

    public void setVonJahr(Integer vonJahr) {
        this.vonJahr = vonJahr;
    }

    public void setVonJahrhundert(String vonJahrhundert) {
        this.vonJahrhundert = vonJahrhundert;
    }

    public void setBisTag(Integer bisTag) {
        this.bisTag = bisTag;
    }

    public void setBisMonat(Integer bisMonat) {
        this.bisMonat = bisMonat;
    }

    public void setBisJahr(Integer bisJahr) {
        this.bisJahr = bisJahr;
    }

    public void setBisJahrhundert(String bisJahrhundert) {
        this.bisJahrhundert = bisJahrhundert;
    }

    public void setDatierungUngewiss(Boolean datierungUngewiss) {
        this.datierungUngewiss = datierungUngewiss;
    }

    public void setKommentarDatierung(String kommentarDatierung) {
        this.kommentarDatierung = kommentarDatierung;
    }

    @Override
    public void setLetzteAenderung(Date letzteAenderung) {
        this.letzteAenderung = letzteAenderung;
    }

    @Override
    public void setLetzteAenderungVon(Benutzer letzteAenderungVon) {
        this.letzteAenderungVon = letzteAenderungVon;
    }

    public void setErstellt(Date erstellt) {
        this.erstellt = erstellt;
    }

    public void setErstelltVon(Benutzer erstelltVon) {
        this.erstelltVon = erstelltVon;
    }

    public void setGehoertGruppe(BenutzerGruppe gehoertGruppe) {
        this.gehoertGruppe = gehoertGruppe;
    }

    public void setGenauigkeitBisTag(SelektionDatGenauigkeit genauigkeitBisTag) {
        this.genauigkeitBisTag = genauigkeitBisTag;
    }

    public void setGenauigkeitBisMonat(SelektionDatGenauigkeit genauigkeitBisMonat) {
        this.genauigkeitBisMonat = genauigkeitBisMonat;
    }

    public void setGenauigkeitBisJahr(SelektionDatGenauigkeit genauigkeitBisJahr) {
        this.genauigkeitBisJahr = genauigkeitBisJahr;
    }

    public void setGenauigkeitBisJahrhundert(SelektionDatGenauigkeit genauigkeitBisJahrhundert) {
        this.genauigkeitBisJahrhundert = genauigkeitBisJahrhundert;
    }

    public void setGenauigkeitVonTag(SelektionDatGenauigkeit genauigkeitVonTag) {
        this.genauigkeitVonTag = genauigkeitVonTag;
    }

    public void setGenauigkeitVonMonat(SelektionDatGenauigkeit genauigkeitVonMonat) {
        this.genauigkeitVonMonat = genauigkeitVonMonat;
    }

    public void setGenauigkeitVonJahr(SelektionDatGenauigkeit genauigkeitVonJahr) {
        this.genauigkeitVonJahr = genauigkeitVonJahr;
    }

    public void setGenauigkeitVonJahrhundert(SelektionDatGenauigkeit genauigkeitVonJahrhundert) {
        this.genauigkeitVonJahrhundert = genauigkeitVonJahrhundert;
    }

    public void setGenauigkeitQuelleBisTag(SelektionDatGenauigkeit genauigkeitQuelleBisTag) {
        this.genauigkeitQuelleBisTag = genauigkeitQuelleBisTag;
    }

    public void setGenauigkeitQuelleBisMonat(SelektionDatGenauigkeit genauigkeitQuelleBisMonat) {
        this.genauigkeitQuelleBisMonat = genauigkeitQuelleBisMonat;
    }

    public void setGenauigkeitQuelleBisJahr(SelektionDatGenauigkeit genauigkeitQuelleBisJahr) {
        this.genauigkeitQuelleBisJahr = genauigkeitQuelleBisJahr;
    }

    public void setGenauigkeitQuelleBisJahrhundert(SelektionDatGenauigkeit genauigkeitQuelleBisJahrhundert) {
        this.genauigkeitQuelleBisJahrhundert = genauigkeitQuelleBisJahrhundert;
    }

    public void setGenauigkeitQuelleVonTag(SelektionDatGenauigkeit genauigkeitQuelleVonTag) {
        this.genauigkeitQuelleVonTag = genauigkeitQuelleVonTag;
    }

    public void setGenauigkeitQuelleVonMonat(SelektionDatGenauigkeit genauigkeitQuelleVonMonat) {
        this.genauigkeitQuelleVonMonat = genauigkeitQuelleVonMonat;
    }

    public void setGenauigkeitQuelleVonJahr(SelektionDatGenauigkeit genauigkeitQuelleVonJahr) {
        this.genauigkeitQuelleVonJahr = genauigkeitQuelleVonJahr;
    }

    public void setGenauigkeitQuelleVonJahrhundert(SelektionDatGenauigkeit genauigkeitQuelleVonJahrhundert) {
        this.genauigkeitQuelleVonJahrhundert = genauigkeitQuelleVonJahrhundert;
    }

    public void setQuelleBisTag(Integer quelleBisTag) {
        this.quelleBisTag = quelleBisTag;
    }

    public void setQuelleBisMonat(Integer quelleBisMonat) {
        this.quelleBisMonat = quelleBisMonat;
    }

    public void setQuelleBisJahr(Integer quelleBisJahr) {
        this.quelleBisJahr = quelleBisJahr;
    }

    public void setQuelleBisJahrhundert(String quelleBisJahrhundert) {
        this.quelleBisJahrhundert = quelleBisJahrhundert;
    }

    public void setQuelleVonTag(Integer quelleVonTag) {
        this.quelleVonTag = quelleVonTag;
    }

    public void setQuelleVonMonat(Integer quelleVonMonat) {
        this.quelleVonMonat = quelleVonMonat;
    }

    public void setQuelleVonJahr(Integer quelleVonJahr) {
        this.quelleVonJahr = quelleVonJahr;
    }

    public void setQuelleVonJahrhundert(String quelleVonJahrhundert) {
        this.quelleVonJahrhundert = quelleVonJahrhundert;
    }

    public void setKommentarPerson(String kommentarPerson) {
        this.kommentarPerson = kommentarPerson;
    }

    public void setMghLemmaKorrigiert(Boolean mghLemmaKorrigiert) {
        this.mghLemmaKorrigiert = mghLemmaKorrigiert;
    }

    public void setMghLemma(Set<MghLemma> mghLemma) {
        this.mghLemma = mghLemma;
    }

    public Set<SelektionAngabe> getAngaben() {
        return angaben;
    }

    public void addAngabe(SelektionAngabe selektionAngabe) {
        if (selektionAngabe != null) {
            this.getAngaben().add(selektionAngabe);
        }
    }

    public void removeAngabe(int id) {
        this.getAngaben().removeIf(e -> e.getId() == id);
    }

    public SelektionBeziehungGemeinschaft getBeziehungGemeinschaft() {
        return beziehungGemeinschaft;
    }

    public void setBeziehungGemeinschaft(SelektionBeziehungGemeinschaft beziehungGemeinschaft) {
        this.beziehungGemeinschaft = beziehungGemeinschaft;
    }

    public String getTitelText() {
        return titelText;
    }

    public void setTitelText(String titelText) {
        this.titelText = titelText;
    }

    public Set<SelektionKritik> getTitelKritiken() {
        return titelKritiken;
    }

    public void addTitelKritik(SelektionKritik selektionKritik) {
        if (selektionKritik != null) {
            this.getTitelKritiken().add(selektionKritik);
        }
    }

    public void removeTitelKritik(int id) {
        this.getTitelKritiken().removeIf(e -> e.getId() == id);
    }

    public Set<SelektionArealTyp> getArealTyp() {
        return arealTyp;
    }

    public void setArealTyp(Set<SelektionArealTyp> arealTyp) {
        this.arealTyp = arealTyp;
    }

    public void addArealTyp(SelektionArealTyp selektionArealTyp) {
        if (selektionArealTyp != null) {
            this.getArealTyp().add(selektionArealTyp);
        }
    }

    public void removeArealTyp(int id) {
        this.getArealTyp().removeIf(e -> e.getId() == id);
    }

    public Integer getKritikId() {
        return kritikId;
    }

    public void setKritikId(Integer kritikId) {
        this.kritikId = kritikId;
    }

    public String getNummerInStruktur() {
        return nummerInStruktur;
    }

    public void setNummerInStruktur(String nummerInStruktur) {
        this.nummerInStruktur = nummerInStruktur;
    }

    public String getSeite() {
        return seite;
    }

    public void setSeite(String seite) {
        this.seite = seite;
    }

    public String getRaster() {
        return raster;
    }

    public void setRaster(String raster) {
        this.raster = raster;
    }

    public String getSchreiber() {
        return schreiber;
    }

    public void setSchreiber(String schreiber) {
        this.schreiber = schreiber;
    }

    public JSONObject getJSON() {
        JSONObject jsonObject = new JSONObject();

        // Allgemein
        Utils.addIfValid(jsonObject, "id", "B" + this.getId());
        Utils.addIfValid(jsonObject, "editionId", this.getEdition() != null ? "E" + this.getEdition().getId() : null);
        Utils.addIfValid(jsonObject, "quelleId", this.getQuelle() != null ? "Q" + this.getQuelle().getId() : null);
        Utils.addIfValid(jsonObject, "handschriftId", this.getHandschrift() != null ? "T" + this.getHandschrift().getId() : null);
        Utils.addIfValid(jsonObject, "belegnummer", this.getBelegnummer());
        Utils.addIfValid(jsonObject, "kontext", Utils.sanitize(this.getKontext()));
        Utils.addIfValid(jsonObject, "geschlecht", this.getGeschlecht() != null ? Utils.sanitize(this.getGeschlecht().getBezeichnung()) : null);
        Utils.addIfValid(jsonObject, "lebendVerstorben", this.getLebendVerstorben() != null ? Utils.sanitize(this.getLebendVerstorben().getBezeichnung()) : null);
        Utils.addIfValid(jsonObject, "ueberlieferungDatierung", Utils.sanitize(this.getUeberlieferungDatierung()));
        Utils.addIfValid(jsonObject, "belegform", Utils.sanitize(this.getBelegform()));
        Utils.addIfValid(jsonObject, "griechisch", Utils.sanitize(this.getGriechisch()));
        Utils.addIfValid(jsonObject, "diakritisch", Utils.sanitize(this.getDiakritisch()));
        Utils.addIfValid(jsonObject, "kasus", this.getKasus() != null ? Utils.sanitize(this.getKasus().getBezeichnung()) : null);
        Utils.addIfValid(jsonObject, "grammatikGeschlecht", this.getGrammatikGeschlecht() != null ? Utils.sanitize(this.getGrammatikGeschlecht().getBezeichnung()) : null);

        // Kommentare
        Utils.addIfValid(jsonObject, "aswQuellenzitat", Utils.sanitize(this.getAswQuellenzitat()));
        Utils.addIfValid(jsonObject, "bemerkung", Utils.sanitize(this.getBemerkung()));
        Utils.addIfValid(jsonObject, "kommentarEthnie", Utils.sanitize(this.getKommentarEthnie()));
        Utils.addIfValid(jsonObject, "kommentarAreal", Utils.sanitize(this.getKommentarAreal()));
        Utils.addIfValid(jsonObject, "kommentarVerwandtschaft", Utils.sanitize(this.getKommentarVerwandtschaft()));
        Utils.addIfValid(jsonObject, "kommentarDatierung", Utils.sanitize(this.getKommentarDatierung()));
        Utils.addIfValid(jsonObject, "kommentarPerson", Utils.sanitize(this.getKommentarPerson()));

        // Datumsfelder
        Utils.addIfValid(jsonObject, "erstellt", this.getErstellt() != null ? Utils.formatDate(this.getErstellt()) : null);

        // Bearbeiter
        Utils.addIfValid(jsonObject, "gehoertGruppe", this.getGehoertGruppe() != null ? Utils.sanitize(this.getGehoertGruppe().getBezeichnung()) : null);

        // Genauigkeitsfelder
        Utils.addIfValid(jsonObject, "genauigkeitBisTag", Utils.sanitize(this.getGenauigkeitBisTag() != null ? this.getGenauigkeitBisTag().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitBisMonat", Utils.sanitize(this.getGenauigkeitBisMonat() != null ? this.getGenauigkeitBisMonat().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitBisJahr", Utils.sanitize(this.getGenauigkeitBisJahr() != null ? this.getGenauigkeitBisJahr().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitBisJahrhundert", Utils.sanitize(this.getGenauigkeitBisJahrhundert() != null ? this.getGenauigkeitBisJahrhundert().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitVonTag", Utils.sanitize(this.getGenauigkeitVonTag() != null ? this.getGenauigkeitVonTag().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitVonMonat", Utils.sanitize(this.getGenauigkeitVonMonat() != null ? this.getGenauigkeitVonMonat().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitVonJahr", Utils.sanitize(this.getGenauigkeitVonJahr() != null ? this.getGenauigkeitVonJahr().getBezeichnung() : null));
        Utils.addIfValid(jsonObject, "genauigkeitVonJahrhundert", Utils.sanitize(this.getGenauigkeitVonJahrhundert() != null ? this.getGenauigkeitVonJahrhundert().getBezeichnung() : null));

        // Quelle Informationen
        Utils.addIfValid(jsonObject, "quelleEchtheit", this.getQuelleEchtheit() != null ? Utils.sanitize(this.getQuelleEchtheit().getBezeichnung()) : null);
        Utils.addIfValid(jsonObject, "quelleDatierung", Utils.sanitize(this.getQuelleDatierung()));
        Utils.addIfValid(jsonObject, "quelleBisTag", this.getQuelleBisTag());
        Utils.addIfValid(jsonObject, "quelleBisMonat", this.getQuelleBisMonat());
        Utils.addIfValid(jsonObject, "quelleBisJahr", this.getQuelleBisJahr());
        Utils.addIfValid(jsonObject, "quelleBisJahrhundert", this.getQuelleBisJahrhundert());
        Utils.addIfValid(jsonObject, "quelleVonTag", this.getQuelleVonTag());
        Utils.addIfValid(jsonObject, "quelleVonMonat", this.getQuelleVonMonat());
        Utils.addIfValid(jsonObject, "quelleVonJahr", this.getQuelleVonJahr());
        Utils.addIfValid(jsonObject, "quelleVonJahrhundert", this.getQuelleVonJahrhundert());

        // Editionsinformationen
        Utils.addIfValid(jsonObject, "editionKapitel", Utils.sanitize(this.getEditionKapitel()));
        Utils.addIfValid(jsonObject, "editionSeite", Utils.sanitize(this.getEditionSeite()));

        return jsonObject;
    }
}
