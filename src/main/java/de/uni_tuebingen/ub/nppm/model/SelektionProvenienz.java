package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.Cacheable;
import javax.persistence.Entity;
import javax.persistence.Table;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_provenienz")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionProvenienz extends SelektionBezeichnung{

}
