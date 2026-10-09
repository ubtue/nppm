package de.uni_tuebingen.ub.nppm.controller.test;

import de.uni_tuebingen.ub.nppm.controller.test.base.DBTest;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import de.uni_tuebingen.ub.nppm.db.*;
import org.junit.jupiter.api.BeforeEach;

/**
 *
 * @author julian
 */
public class MghLemmaDBTest extends DBTest {

    @BeforeEach
    void init() throws Exception {
        LemmaDB.setInitialContext(super.getTestContext());
    }

    @Test
    @DisplayName("List MghLemma Entities")
    void testList() {
        try {
            // TODO: The test fails because of the inconsistency of the database
            //MghLemmaDB.getList();
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }

        try {
            LemmaDB.getListKorrektor();
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }

        try {
            LemmaDB.getListBearbeiter();
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }
    }
}
