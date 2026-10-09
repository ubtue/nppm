package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_arealtyp")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionArealTyp extends SelektionAbstractProvenance {
    @ManyToMany(mappedBy = "arealTyp")
    private Set<Einzelbeleg> einzelbelege = new HashSet<>();

    public void addEinzelbeleg(Einzelbeleg beleg) {
        this.getEinzelbelege().add(beleg);
    }

    public void removeEinzelbeleg(int id) {
        this.getEinzelbelege().removeIf(e -> e.getId() != null && e.getId().equals(id));
    }

    public Set<Einzelbeleg> getEinzelbelege() {
        return einzelbelege;
    }
}
