package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;

public class EditionDB extends AbstractBase {
    public static Edition getById(int id) throws Exception {
        return AbstractBase.getById(id, Edition.class);
    }

    public static List<Edition> getList() throws Exception {
        return getList(Edition.class);
    }
}
