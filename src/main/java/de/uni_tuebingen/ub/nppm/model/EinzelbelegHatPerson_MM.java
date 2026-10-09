package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "einzelbeleg_hatperson")
public class EinzelbelegHatPerson_MM {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @ManyToOne(targetEntity = Einzelbeleg.class)
    @JoinColumn(name = "EinzelbelegID", referencedColumnName = "ID")
    private Einzelbeleg einzelbeleg;

    public Integer getId() {
        return id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Einzelbeleg getEinzelbeleg() {
        return einzelbeleg;
    }

    public void setEinzelbeleg(Einzelbeleg einzelbeleg) {
        this.einzelbeleg = einzelbeleg;
    }


}
