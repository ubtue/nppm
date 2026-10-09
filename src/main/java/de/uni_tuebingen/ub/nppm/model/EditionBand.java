package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "edition_band")
public class EditionBand {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName="ID")
    private Edition edition;

    @Column(name = "BandNummer", length=255)
    private String bandNummer;

    @Column(name = "Jahr", length=255)
    private String jahr;

    @Column(name = "Standard", columnDefinition="INTEGER DEFAULT NULL")
    private Boolean standard;

    public Integer getId() {
        return id;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public String getBandNummer() {
        return bandNummer;
    }

    public void setBandNummer(String bandNummer) {
        this.bandNummer = bandNummer;
    }

    public String getJahr() {
        return jahr;
    }

    public void setJahr(String jahr) {
        this.jahr = jahr;
    }

    public Boolean getStandard() {
        return standard;
    }

    public void setStandard(Boolean standard) {
        this.standard = standard;
    }

}
