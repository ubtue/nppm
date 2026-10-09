package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_konvent")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionKonvent extends SelektionAbstractProvenance {

}
