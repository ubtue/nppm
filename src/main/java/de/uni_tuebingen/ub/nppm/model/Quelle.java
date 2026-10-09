package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import de.uni_tuebingen.ub.nppm.util.Utils;
import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.json.JSONArray;
import org.json.JSONObject;

@Entity
@Table(name = "quelle")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Quelle implements PersistentIdentifier, History {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = SelektionQuellengattung.class)
    @JoinColumn(name = "QuelleGattungID", referencedColumnName = "ID")
    private SelektionQuellengattung quelleGattung;

    @Column(name = "Bezeichnung", length=255)
    private String bezeichnung;

    @Column(name = "Quellennummer", length=255)
    private String quellennummer;

    @Column(name = "QuellenKommentarDatei", length=255)
    private String quellenKommentarDatei;

    @Column(name = "UeberlieferungsKommentarDatei", length=255)
    private String ueberlieferungsKommentarDatei;

    @ManyToOne(targetEntity = SelektionBearbeitungsstatus.class)
    @JoinColumn(name = "BearbeitungsstatusID", referencedColumnName="ID")
    private SelektionBearbeitungsstatus bearbeitungsstatus;

    @Column(name = "VonTag")
    private Integer vonTag;

    @Column(name = "VonMonat")
    private Integer vonMonat;

    @Column(name = "VonJahr")
    private Integer vonJahr;

    @Column(name = "VonJahrhundert", length=5)
    private String vonJahrhundert;

    @Column(name = "BisTag")
    private Integer bisTag;

    @Column(name = "BisMonat")
    private Integer bisMonat;

    @Column(name = "BisJahr")
    private Integer bisJahr;

    @Column(name = "BisJahrhundert", length=5)
    private String bisJahrhundert;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonTag", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitVonTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonMonat", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitVonMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonJahr", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitVonJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitVonJahrhundert", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitVonJahrhundert;

    @Column(name = "DatierungUngewiss" , columnDefinition="BIT DEFAULT NULL")
    private Boolean datierungUngewiss;

    @Column(name = "KommentarDatierung", length=255)
    private String kommentarDatierung;

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

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisTag", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitBisTag;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisMonat", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitBisMonat;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisJahr", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitBisJahr;

    @ManyToOne(targetEntity = SelektionDatGenauigkeit.class)
    @JoinColumn(name = "GenauigkeitBisJahrhundert", referencedColumnName="ID")
    private SelektionDatGenauigkeit genauigkeitBisJahrhundert;

    @Column(name = "ZuVeroeffentlichen" , columnDefinition="TINYINT(1) DEFAULT NULL")
    private Integer zuVeroeffentlichen;

    @ManyToMany(mappedBy = "quellen")
    private Set<Edition> editions = new HashSet<>();

    @OneToMany(mappedBy = "quelle")
    private Set<Einzelbeleg> einzelbelege = new HashSet<>();

    @OneToOne(mappedBy = "quelle")
    private Urkunde urkunde;

    public Integer getId() {
        return id;
    }

    @Override
    public String getPersistentIdentifier() {
        return "Q" + getId();
    }

    public String getBezeichnung() {
        return bezeichnung;
    }

    public void setBezeichnung(String bezeichnung) {
        this.bezeichnung = bezeichnung;
    }

    public String getQuellennummer() {
        return quellennummer;
    }

    public SelektionQuellengattung getQuelleGattung() {
        return quelleGattung;
    }

    public void setQuelleGattung(SelektionQuellengattung quelleGattung) {
        this.quelleGattung = quelleGattung;
    }

    public void setQuellennummer(String quellennummer) {
        this.quellennummer = quellennummer;
    }

    public String getQuellenKommentarDatei() {
        return quellenKommentarDatei;
    }

    public void setQuellenKommentarDatei(String quellenKommentarDatei) {
        this.quellenKommentarDatei = quellenKommentarDatei;
    }

    public String getUeberlieferungsKommentarDatei() {
        return ueberlieferungsKommentarDatei;
    }

    public void setUeberlieferungsKommentarDatei(String ueberlieferungsKommentarDatei) {
        this.ueberlieferungsKommentarDatei = ueberlieferungsKommentarDatei;
    }

    public SelektionBearbeitungsstatus getBearbeitungsstatus() {
        return bearbeitungsstatus;
    }

    public void setBearbeitungsstatus(SelektionBearbeitungsstatus bearbeitungsstatus) {
        this.bearbeitungsstatus = bearbeitungsstatus;
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

    public Boolean getDatierungUngewiss() {
        return datierungUngewiss;
    }

    public void setDatierungUngewiss(Boolean datierungUngewiss) {
        this.datierungUngewiss = datierungUngewiss;
    }

    public String getKommentarDatierung() {
        return kommentarDatierung;
    }

    public void setKommentarDatierung(String kommentarDatierung) {
        this.kommentarDatierung = kommentarDatierung;
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

    public SelektionDatGenauigkeit getGenauigkeitBisTag() {
        return genauigkeitBisTag;
    }

    public void setGenauigkeitBisTag(SelektionDatGenauigkeit genauigkeitBisTag) {
        this.genauigkeitBisTag = genauigkeitBisTag;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisMonat() {
        return genauigkeitBisMonat;
    }

    public void setGenauigkeitBisMonat(SelektionDatGenauigkeit genauigkeitBisMonat) {
        this.genauigkeitBisMonat = genauigkeitBisMonat;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisJahr() {
        return genauigkeitBisJahr;
    }

    public void setGenauigkeitBisJahr(SelektionDatGenauigkeit genauigkeitBisJahr) {
        this.genauigkeitBisJahr = genauigkeitBisJahr;
    }

    public SelektionDatGenauigkeit getGenauigkeitBisJahrhundert() {
        return genauigkeitBisJahrhundert;
    }

    public void setGenauigkeitBisJahrhundert(SelektionDatGenauigkeit genauigkeitBisJahrhundert) {
        this.genauigkeitBisJahrhundert = genauigkeitBisJahrhundert;
    }

    public Integer getZuVeroeffentlichen() {
        return zuVeroeffentlichen;
    }

    public void setZuVeroeffentlichen(Integer zuVeroeffentlichen) {
        this.zuVeroeffentlichen = zuVeroeffentlichen;
    }

    public Set<Edition> getEditions() {
        return editions;
    }

    public void addEdition(Edition edition){
        this.getEditions().add(edition);
    }

    public void removeEdition(int id){
        this.getEditions().removeIf(e -> e.getId() == id);
    }

    public Urkunde getUrkunde() {
        return urkunde;
    }

    public Set<Einzelbeleg> getEinzelbelege() {
        return einzelbelege;
    }

    public void setEinzelbelege(Set<Einzelbeleg> einzelbelege) {
        this.einzelbelege = einzelbelege;
    }

    public void addEinzelbeleg(Einzelbeleg e){
        this.getEinzelbelege().add(e);
    }

    public void removeEinzelbeleg(int id){
        this.getEinzelbelege().removeIf(e -> e.getId() == id);
    }

    public JSONObject getJSON() {
        JSONObject jsonObject = new JSONObject();

        // Allgemeine Informationen
        Utils.addIfValid(jsonObject, "id", this.getId() != null ? "Q" + this.getId() : null);
        Utils.addIfValid(jsonObject, "bezeichnung", Utils.sanitize(this.getBezeichnung()));
        Utils.addIfValid(jsonObject, "quellennummer", Utils.sanitize(this.getQuellennummer()));
        Utils.addIfValid(jsonObject, "quellenKommentarDatei", Utils.sanitize(this.getQuellenKommentarDatei()));
        Utils.addIfValid(jsonObject, "ueberlieferungsKommentarDatei", Utils.sanitize(this.getUeberlieferungsKommentarDatei()));
        Utils.addIfValid(jsonObject, "quelleGattung", this.getQuelleGattung() != null ? Utils.sanitize(this.getQuelleGattung().getBezeichnung()) : null);
        // Bearbeitungsstatus
        Utils.addIfValid(jsonObject, "bearbeitungsstatus", this.getBearbeitungsstatus() != null ? this.getBearbeitungsstatus().getId() : null);

        // Datierungsinformationen
        Utils.addIfValid(jsonObject, "vonTag", this.getVonTag());
        Utils.addIfValid(jsonObject, "vonMonat", this.getVonMonat());
        Utils.addIfValid(jsonObject, "vonJahr", this.getVonJahr());
        Utils.addIfValid(jsonObject, "vonJahrhundert", this.getVonJahrhundert());
        Utils.addIfValid(jsonObject, "bisTag", this.getBisTag());
        Utils.addIfValid(jsonObject, "bisMonat", this.getBisMonat());
        Utils.addIfValid(jsonObject, "bisJahr", this.getBisJahr());
        Utils.addIfValid(jsonObject, "bisJahrhundert", this.getBisJahrhundert());
        Utils.addIfValid(jsonObject, "genauigkeitVonTag", this.getGenauigkeitVonTag() != null ? this.getGenauigkeitVonTag().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitVonMonat", this.getGenauigkeitVonMonat() != null ? this.getGenauigkeitVonMonat().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitVonJahr", this.getGenauigkeitVonJahr() != null ? this.getGenauigkeitVonJahr().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitVonJahrhundert", this.getGenauigkeitVonJahrhundert() != null ? this.getGenauigkeitVonJahrhundert().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitBisTag", this.getGenauigkeitBisTag() != null ? this.getGenauigkeitBisTag().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitBisMonat", this.getGenauigkeitBisMonat() != null ? this.getGenauigkeitBisMonat().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitBisJahr", this.getGenauigkeitBisJahr() != null ? this.getGenauigkeitBisJahr().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "genauigkeitBisJahrhundert", this.getGenauigkeitBisJahrhundert() != null ? this.getGenauigkeitBisJahrhundert().getBezeichnung() : null);
        Utils.addIfValid(jsonObject, "datierungUngewiss", this.getDatierungUngewiss());

        // Kommentare
        Utils.addIfValid(jsonObject, "kommentarDatierung", Utils.sanitize(this.getKommentarDatierung()));

        // Gruppenzugehörigkeit
        Utils.addIfValid(jsonObject, "gehoertGruppe", this.getGehoertGruppe() != null ? this.getGehoertGruppe().getBezeichnung() : null);

        // Veröffentlichungsstatus
        Utils.addIfValid(jsonObject, "zuVeroeffentlichen", this.getZuVeroeffentlichen());

        // Editions-IDs
        JSONArray editionsArray = new JSONArray();
        for (Edition e : this.getEditions()) {
            editionsArray.put("E" + e.getId());
        }
        jsonObject.put("editions", editionsArray);

        // Einzelbeleg-IDs
        JSONArray einzelbelegeArray = new JSONArray();
        for (Einzelbeleg e : this.getEinzelbelege()) {
            einzelbelegeArray.put("B" + e.getId());
        }
        jsonObject.put("einzelbelege", einzelbelegeArray);

        // Urkunde-ID
        Utils.addIfValid(jsonObject, "urkunde", this.getUrkunde() != null ? "U" + this.getUrkunde().getId() : null);

        return jsonObject;
    }

}
