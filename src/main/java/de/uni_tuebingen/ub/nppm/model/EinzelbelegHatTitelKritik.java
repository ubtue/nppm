package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "einzelbeleg_hattitelkritik")
public class EinzelbelegHatTitelKritik {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Einzelbeleg.class)
    @JoinColumn(name = "EinzelbelegID", referencedColumnName = "ID")
    private Einzelbeleg einzelbeleg;

    @ManyToOne(targetEntity = SelektionKritik.class)
    @JoinColumn(name = "TitelkritikID", referencedColumnName = "ID")
    private SelektionKritik selektionKritik;

    public Integer getId() {
        return id;
    }

    public Einzelbeleg getEinzelbeleg() {
        return einzelbeleg;
    }

    public void setEinzelbeleg(Einzelbeleg einzelbeleg) {
        this.einzelbeleg = einzelbeleg;
    }

    public SelektionKritik getSelektionTitelKritik() {
        return selektionKritik;
    }

    public void setSelektionTitelKritik(SelektionKritik selektionKritik) {
        this.selektionKritik = selektionKritik;
    }
}
