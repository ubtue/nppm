package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_funktion")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionFunktion extends SelektionAbstractProvenance {
    @ManyToMany(mappedBy = "funktion")
    private Set<Einzelbeleg> einzelbeleg = new HashSet<>();

    public void addEinzelbeleg(Einzelbeleg beleg) {
        this.getEinzelbeleg().add(beleg);
    }

    public void removeEinzelbeleg(int id) {
        this.getEinzelbeleg().removeIf(e -> e.getId() == id);
    }

    public Set<Einzelbeleg> getEinzelbeleg() {
        return einzelbeleg;
    }

    public void setEinzelbeleg(Set<Einzelbeleg> einzelbeleg) {
        this.einzelbeleg = einzelbeleg;
    }
}
