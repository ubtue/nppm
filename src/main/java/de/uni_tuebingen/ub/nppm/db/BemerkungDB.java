package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;

public class BemerkungDB extends AbstractBase {

    public static List<Bemerkung> getList() throws Exception {
        return getList(Bemerkung.class);
    }
}
