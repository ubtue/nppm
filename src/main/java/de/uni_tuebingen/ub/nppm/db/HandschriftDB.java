package de.uni_tuebingen.ub.nppm.db;

import java.util.List;
import de.uni_tuebingen.ub.nppm.model.*;

public class HandschriftDB extends AbstractBase {

    public static Handschrift getById(int id) throws Exception {
        return AbstractBase.getById(id, Handschrift.class);
    }

    public static List<Handschrift> getList() throws Exception {
        return getList(Handschrift.class);
    }
}
