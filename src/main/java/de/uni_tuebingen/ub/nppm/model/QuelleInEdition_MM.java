package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "quelle_inedition")
public class QuelleInEdition_MM {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Quelle.class)
    @JoinColumn(name = "QuelleID", referencedColumnName="ID")
    private Quelle quelle;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName="ID")
    private Edition edition;

    @Column(name = "Standard")
    private Integer standard;

    @Column(name = "Seiten", length = 45)
    private String seiten;

    @Column(name = "Nummer", length = 10)
    private String nummer;

    public Integer getId() {
        return id;
    }

    public Quelle getQuelle() {
        return quelle;
    }

    public void setQuelle(Quelle quelle) {
        this.quelle = quelle;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public Integer getStandard() {
        return standard;
    }

    public void setStandard(Integer standard) {
        this.standard = standard;
    }

    public String getSeiten() {
        return seiten;
    }

    public void setSeiten(String seiten) {
        this.seiten = seiten;
    }

    public String getNummer() {
        return nummer;
    }

    public void setNummer(String nummer) {
        this.nummer = nummer;
    }


}
