package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_hatstand")
public class PersonHatStand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @ManyToOne(targetEntity = SelektionStand.class)
    @JoinColumn(name = "StandID", referencedColumnName = "ID")
    private SelektionStand selektionStand;

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

    public SelektionStand getSelektionStand() {
        return selektionStand;
    }

    public void setSelektionStand(SelektionStand selektionStand) {
        this.selektionStand = selektionStand;
    }
}
