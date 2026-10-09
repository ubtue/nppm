package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import java.util.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_editor")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionEditor extends SelektionAbstractProvenance {

    @Column(name = "Nachname", length = 50)
    private String nachname;

    @Column(name = "Vorname", length = 50)
    private String vorname;

    @ManyToMany(mappedBy = "editors")
    private Set<Edition> editions = new HashSet<>();

    public Set<Edition> getEditions() {
        return editions;
    }

    public void addEdition(Edition edition){
        this.getEditions().add(edition);
    }

    public void removeEdition(int id){
        this.getEditions().removeIf(e -> e.getId() == id);
    }

    public String getNachname() {
        return nachname;
    }

    public void setNachname(String nachname) {
        this.nachname = nachname;
    }

    public String getVorname() {
        return vorname;
    }

    public void setVorname(String vorname) {
        this.vorname = vorname;
    }
}
