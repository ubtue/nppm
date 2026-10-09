package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_urkundeausstellerempfaenger")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionUrkundeAusstellerEmpfaenger extends SelektionAbstractProvenance {
    @ManyToMany(mappedBy = "empfaenger")
    private Set<Urkunde> urkundeEmpfaenger = new HashSet<Urkunde>();

    @ManyToMany(mappedBy = "aussteller")
    private Set<Urkunde> urkundeAussteller = new HashSet<Urkunde>();

    public Set<Urkunde> getUrkundeEmpfaenger() {
        return this.urkundeEmpfaenger;
    }

    public void addUrkundeEmpfaenger(Urkunde uk){
        this.getUrkundeEmpfaenger().add(uk);
    }

    public void removeUrkundeEmpfaenger(int id){
        this.getUrkundeEmpfaenger().removeIf(e -> e.getId() == id);
    }

    public Set<Urkunde> getUrkundeAussteller() {
        return this.urkundeAussteller;
    }

    public void addUrkundeAussteller(Urkunde uk){
        this.getUrkundeAussteller().add(uk);
    }

    public void removeUrkundeAussteller(int id){
        this.getUrkundeAussteller().removeIf(e -> e.getId() == id);
    }
}
