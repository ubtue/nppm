package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "urkunde_betreff")
public class UrkundeBetreff {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Urkunde.class)
    @JoinColumn(name = "UrkundeID", referencedColumnName="ID")
    private Urkunde urkunde;

    @Column(name = "Betreff", length = 255)
    private String betreff;

    public Integer getId() {
        return id;
    }

    public Urkunde getUrkunde() {
        return urkunde;
    }

    public void setUrkunde(Urkunde urkunde) {
        this.urkunde = urkunde;
    }

    public String getBetreff() {
        return betreff;
    }

    public void setBetreff(String betreff) {
        this.betreff = betreff;
    }


}
