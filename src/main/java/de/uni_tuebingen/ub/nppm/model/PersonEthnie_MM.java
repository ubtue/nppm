package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_hatethnie")
public class PersonEthnie_MM {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @ManyToOne(targetEntity = SelektionEthnie.class)
    @JoinColumn(name = "EthnieID", referencedColumnName = "ID")
    private SelektionEthnie ethnie;

    public Integer getId() {
        return id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public SelektionEthnie getEthnie() {
        return ethnie;
    }

    public void setEthnie(SelektionEthnie ethnie) {
        this.ethnie = ethnie;
    }
}
