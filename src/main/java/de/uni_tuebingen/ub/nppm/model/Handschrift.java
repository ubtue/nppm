package de.uni_tuebingen.ub.nppm.model;

import de.uni_tuebingen.ub.nppm.model.interfaces.*;
import javax.persistence.*;
import java.util.*;

@Entity
@Table(name = "handschrift")
public class Handschrift implements PersistentIdentifier, History {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "Bibliothekssignatur", length=255)
    private String bibliothekssignatur;

    @Column(name = "LetzteAenderung")
    private Date letzteAenderung;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "LetzteAenderungVon", referencedColumnName="ID")
    private Benutzer letzteAenderungVon;

    @Column(name = "Erstellt")
    private Date erstellt;

    @ManyToOne(targetEntity = Benutzer.class)
    @JoinColumn(name = "ErstelltVon", referencedColumnName="ID")
    private Benutzer erstelltVon;

    @ManyToOne(targetEntity = BenutzerGruppe.class)
    @JoinColumn(name = "GehoertGruppe", referencedColumnName="ID")
    private BenutzerGruppe gehoertGruppe;

    public Integer getId() {
        return id;
    }

    @Override
    public String getPersistentIdentifier() {
        return "T" + getId();
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBibliothekssignatur() {
        return bibliothekssignatur;
    }

    public void setBibliothekssignatur(String bibliothekssignatur) {
        this.bibliothekssignatur = bibliothekssignatur;
    }

    @Override
    public Date getLetzteAenderung() {
        return letzteAenderung;
    }

    @Override
    public void setLetzteAenderung(Date letzteAenderung) {
        this.letzteAenderung = letzteAenderung;
    }

    @Override
    public Benutzer getLetzteAenderungVon() {
        return letzteAenderungVon;
    }

    @Override
    public void setLetzteAenderungVon(Benutzer letzteAenderungVon) {
        this.letzteAenderungVon = letzteAenderungVon;
    }

    @Override
    public Date getErstellt() {
        return erstellt;
    }

    @Override
    public void setErstellt(Date erstellt) {
        this.erstellt = erstellt;
    }

    @Override
    public Benutzer getErstelltVon() {
        return erstelltVon;
    }

    @Override
    public void setErstelltVon(Benutzer erstelltVon) {
        this.erstelltVon = erstelltVon;
    }

    public BenutzerGruppe getGehoertGruppe() {
        return gehoertGruppe;
    }

    public void setGehoertGruppe(BenutzerGruppe gehoertGruppe) {
        this.gehoertGruppe = gehoertGruppe;
    }
}
