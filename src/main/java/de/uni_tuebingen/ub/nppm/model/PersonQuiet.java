package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "person_quiet")
public class PersonQuiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Person.class)
    @JoinColumn(name = "PersonID", referencedColumnName = "ID")
    private Person person;

    @Column(name = "QuiEt", length = 255)
    private String quiet;

    @Column(name = "Zusatz", length = 255)
    private String zusatz;

    public Integer getId() {
        return id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public String getQuiet() {
        return quiet;
    }

    public void setQuiet(String quiet) {
        this.quiet = quiet;
    }

    public String getZusatz() {
        return zusatz;
    }

    public void setZusatz(String zusatz) {
        this.zusatz = zusatz;
    }
}
