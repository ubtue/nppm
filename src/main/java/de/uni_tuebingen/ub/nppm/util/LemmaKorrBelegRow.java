package de.uni_tuebingen.ub.nppm.util;

public class LemmaKorrBelegRow {
    public int id;
    public String lemma;
    public String beleg;
    public boolean korr;
    public String db;

    public LemmaKorrBelegRow(int id, String lemma, String beleg, boolean korr, String db) {
        this.id = id;
        this.lemma = lemma;
        this.beleg = beleg;
        this.korr = korr;
        this.db = db;
    }
}
