package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_verwandtmit")
public class PersonVerwandtMit_MM {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonIDvon", referencedColumnName = "ID")
    private Person personVon;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonIDzu", referencedColumnName = "ID")
    private Person personZu;

    public Integer getId() {
        return id;
    }

    public Person getPersonVon() {
        return personVon;
    }

    public void setPersonVon(Person personVon) {
        this.personVon = personVon;
    }

    public Person getPersonZu() {
        return personZu;
    }

    public void setPersonZu(Person personZu) {
        this.personZu = personZu;
    }
}
