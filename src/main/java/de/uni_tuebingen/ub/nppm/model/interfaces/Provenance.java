package de.uni_tuebingen.ub.nppm.model.interfaces;

public interface Provenance {
    String getProvenanceSource();
    void setProvenanceSource(final String provenance_source);

    String getProvenanceID();
    void setProvenanceID(final String provenance_ID);
}
