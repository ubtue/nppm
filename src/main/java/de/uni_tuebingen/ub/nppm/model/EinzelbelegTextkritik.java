package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "einzelbeleg_textkritik")
public class EinzelbelegTextkritik {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "Variante", length = 255)
    private String variante;

    @Column(name = "Bemerkung", columnDefinition = "LONGTEXT")
    private String bemerkung;

    @ManyToOne(targetEntity = Einzelbeleg.class)
    @JoinColumn(name = "EinzelbelegID", referencedColumnName = "ID")
    private Einzelbeleg einzelbeleg;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName = "ID")
    private Edition edition;

    @ManyToOne(targetEntity = HandschriftUeberlieferung.class)
    @JoinColumn(name = "HandschriftID", referencedColumnName = "ID")
    private HandschriftUeberlieferung handschriftUeberlieferung;

    public Integer getId() {
        return id;
    }

    public String getVariante() {
        return variante;
    }

    public void setVariante(String variante) {
        this.variante = variante;
    }

    public String getBemerkung() {
        return bemerkung;
    }

    public void setBemerkung(String bemerkung) {
        this.bemerkung = bemerkung;
    }

    public Einzelbeleg getEinzelbeleg() {
        return einzelbeleg;
    }

    public void setEinzelbeleg(Einzelbeleg einzelbeleg) {
        this.einzelbeleg = einzelbeleg;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

   public HandschriftUeberlieferung getHandschrift() {
        return handschriftUeberlieferung;
    }

    public void setHandschrift(HandschriftUeberlieferung handschriftUeberlieferung) {
        this.handschriftUeberlieferung = handschriftUeberlieferung;
    }
}
