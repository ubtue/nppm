package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import de.uni_tuebingen.ub.nppm.model.interfaces.*;

@MappedSuperclass
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public abstract class SelektionAbstractProvenance extends SelektionBezeichnung implements Provenance {
    @Column(name = "provenance_source")
    private String provenanceSource;

    @Column(name = "provenance_id")
    private String provenanceID;

    @Override
    public String getProvenanceSource() {
        return provenanceSource;
    }

    @Override
    public void setProvenanceSource(final String provenanceSource) {
        this.provenanceSource = provenanceSource;
    }

    @Override
    public String getProvenanceID() {
        return provenanceID;
    }

    @Override
    public void setProvenanceID(final String provenanceID) {
        this.provenanceID = provenanceID;
    }
}
