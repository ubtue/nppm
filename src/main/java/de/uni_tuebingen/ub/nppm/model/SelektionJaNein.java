package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "selektion_janein")
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class SelektionJaNein extends SelektionAbstractProvenance {

}
