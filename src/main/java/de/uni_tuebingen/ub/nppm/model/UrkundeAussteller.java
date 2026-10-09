package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "urkunde_hataussteller")
public class UrkundeAussteller {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Urkunde.class)
    @JoinColumn(name = "UrkundeID", referencedColumnName = "ID")
    private Urkunde urkunde;

    @ManyToOne(targetEntity = SelektionUrkundeAusstellerEmpfaenger.class)
    @JoinColumn(name = "AusstellerID", referencedColumnName = "ID")
    private SelektionUrkundeAusstellerEmpfaenger aussteller;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Urkunde getUrkunde() {
        return urkunde;
    }

    public void setUrkunde(Urkunde urkunde) {
        this.urkunde = urkunde;
    }

    public SelektionUrkundeAusstellerEmpfaenger getAussteller() {
        return aussteller;
    }

    public void setAussteller(SelektionUrkundeAusstellerEmpfaenger aussteller) {
        this.aussteller = aussteller;
    }
}
