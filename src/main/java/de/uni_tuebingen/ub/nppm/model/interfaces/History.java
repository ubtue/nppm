package de.uni_tuebingen.ub.nppm.model.interfaces;

import de.uni_tuebingen.ub.nppm.model.Benutzer;
import java.util.Date;

public interface History {
    Date getErstellt();
    void setErstellt(final Date erstellt);

    Benutzer getErstelltVon();
    void setErstelltVon(final Benutzer erstelltVon);

    Date getLetzteAenderung();
    void setLetzteAenderung(final Date letzteAenderung);

    Benutzer getLetzteAenderungVon();
    void setLetzteAenderungVon(final Benutzer letzteAenderungVon);
}
