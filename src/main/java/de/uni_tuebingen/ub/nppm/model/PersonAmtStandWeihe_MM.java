package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_hatamtstandweihe")
public class PersonAmtStandWeihe_MM {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @ManyToOne(targetEntity = SelektionAmtWeihe.class)
    @JoinColumn(name = "AmtWeiheID", referencedColumnName = "ID")
    private SelektionAmtWeihe amtWeihe;

    @Column(name = "Zeitraum", length = 255)
    private String zeitraum;

    @Column(name = "Identifizierung", columnDefinition = "INTEGER DEFAULT NULL")
    private Boolean identifizierung;

    public Integer getId() {
        return id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public SelektionAmtWeihe getAmtWeihe() {
        return amtWeihe;
    }

    public void setAmtWeihe(SelektionAmtWeihe amtWeihe) {
        this.amtWeihe = amtWeihe;
    }

    public String getZeitraum() {
        return zeitraum;
    }

    public void setZeitraum(String zeitraum) {
        this.zeitraum = zeitraum;
    }

    public Boolean getIdentifizierung() {
        return identifizierung;
    }

    public void setIdentifizierung(Boolean identifizierung) {
        this.identifizierung = identifizierung;
    }
}
