package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_angabe")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
class SelektionAngabe extends SelektionAbstractProvenance {

    @ManyToMany(mappedBy = "angaben")
    private Set<Einzelbeleg> einzelbelege = new HashSet<>();

    public Set<Einzelbeleg> getEinzelbelege() {
        return einzelbelege;
    }

     public void addEinzelbeleg(Einzelbeleg beleg) {
        this.getEinzelbelege().add(beleg);
    }

    public void removeEinzelbeleg(int id) {
        this.getEinzelbelege().removeIf(e -> e.getId() == id);
    }
}
