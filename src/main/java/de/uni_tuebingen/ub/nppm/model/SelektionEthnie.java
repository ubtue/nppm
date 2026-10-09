package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_ethnie")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionEthnie extends SelektionAbstractProvenance {
    @ManyToMany(mappedBy = "ethnie")
    private Set<Person> personen = new HashSet<>();

    public Set<Person> getPersonen() {
        return this.personen;
    }

    public void addPerson(Person person) {
        this.getPersonen().add(person);
    }

    public void removePerson(int id) {
        this.getPersonen().removeIf(e -> e.getId() == id);
    }
}
