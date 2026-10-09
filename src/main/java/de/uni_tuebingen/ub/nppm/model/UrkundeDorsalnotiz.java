package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "urkunde_dorsalnotiz")
public class UrkundeDorsalnotiz {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Urkunde.class)
    @JoinColumn(name = "UrkundeID", referencedColumnName="ID")
    private Urkunde urkunde;

    @Column(name = "Dorsalnotiz", length=255)
    private String dorsalNotiz;

    public Integer getId() {
        return id;
    }

    public Urkunde getUrkunde() {
        return urkunde;
    }

    public void setUrkunde(Urkunde urkunde) {
        this.urkunde = urkunde;
    }

    public String getDorsalNotiz() {
        return dorsalNotiz;
    }

    public void setDorsalNotiz(String dorsalNotiz) {
        this.dorsalNotiz = dorsalNotiz;
    }
}
