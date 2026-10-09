package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Table(name = "datenbank_filter")
public class DatenbankFilter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "de", length = 191)
    private String de;

    @Column(name = "Formular", length = 191)
    private String formular;

    @Column(name = "SQLString", length = 255)
    private String sqlString;

    @Column(name = "Nummer", length = 255)
    private Integer nummer;

    @Column(name = "gb", length = 255)
    private String gb;

    @Column(name = "fr", length = 45)
    private String fr;

    @Column(name = "la", length = 45)
    private String la;

    public Integer getId() {
        return id;
    }

    public String getBezeichnung() {
        return de;
    }

    public void setBezeichnung(String bezeichnung) {
        this.de = bezeichnung;
    }

    public String getFormular() {
        return formular;
    }

    public void setFormular(String formular) {
        this.formular = formular;
    }

    public String getSqlString() {
        return sqlString;
    }

    public void setSqlString(String sqlString) {
        this.sqlString = sqlString;
    }

    public Integer getNummer() {
        return nummer;
    }

    public void setNummer(Integer nummer) {
        this.nummer = nummer;
    }

    public String getGb() {
        return gb;
    }

    public void setGb(String gb) {
        this.gb = gb;
    }

    public String getFr() {
        return fr;
    }

    public void setFr(String fr) {
        this.fr = fr;
    }

    public String getLa() {
        return la;
    }

    public void setLa(String la) {
        this.la = la;
    }
}
