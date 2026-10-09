package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_hatgruppeherkunftareal")
public class PersonGruppeHerkunftAreal_MM {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @ManyToOne(targetEntity = SelektionAreal.class)
    @JoinColumn(name = "ArealID", referencedColumnName = "ID")
    private SelektionAreal areal;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public SelektionAreal getAreal() {
        return areal;
    }

    public void setAreal(SelektionAreal areal) {
        this.areal = areal;
    }
}
