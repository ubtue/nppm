package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "edition_bestand")
public class EditionBestand {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName="ID")
    private Edition edition;

    @Column(name = "Signatur", length=255)
    private String signatur;

    @ManyToOne(targetEntity = SelektionBkz.class)
    @JoinColumn(name = "BKZ", referencedColumnName="ID")
    private SelektionBkz bkz;

    public Integer getId() {
        return id;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public String getSignatur() {
        return signatur;
    }

    public void setSignatur(String signatur) {
        this.signatur = signatur;
    }

    public SelektionBkz getBkz() {
        return bkz;
    }

    public void setBkz(SelektionBkz bkz) {
        this.bkz = bkz;
    }

}
