package de.uni_tuebingen.ub.nppm.cli;

import de.uni_tuebingen.ub.nppm.api.wikidata.*;
import de.uni_tuebingen.ub.nppm.api.wikidata.entity.*;
import de.uni_tuebingen.ub.nppm.db.*;

public class SyncWikidata extends AbstractBase {
    public static void main (String[] args) throws Exception {
        // Load Properties (DB access credentials, etc.)
        LoadProperties();

        for (var person : PersonDB.getListPerson()) {
            String wikidataId = person.getWikidata();
            String gndId = person.getGnd();

            // normalize values if necessary
            if (wikidataId != null && wikidataId.equals("")) {
                System.out.println("Normalizing Wikidata ID for " + person.getDebugString());
                wikidataId = null;
                person.setWikidata(null);
                PersonDB.merge(person);
            }

            if (gndId != null && gndId.equals("")) {
                System.out.println("Normalizing GND Number for " + person.getDebugString());
                gndId = null;
                person.setGnd(null);
                PersonDB.merge(person);
            }

            // Start migration
            if (wikidataId != null && gndId == null) {
                System.out.println("Trying to Import Data for " + person.getDebugString() + " with wikidataId " + wikidataId);
                try {
                    WikidataPerson wikidataPerson = WikidataREST.getPersonById(wikidataId);
                    String wikidataGnd = wikidataPerson.getGnd();
                    if (wikidataGnd != null) {
                        System.out.println("Changing GND Number for Person " + person.getDebugString() + " to " + wikidataGnd);
                        person.setGnd(wikidataGnd);
                        PersonDB.merge(person);
                    }
                } catch (Exception e) {
                    System.out.println("Wikidata sync failed: " + e.getMessage());
                }
            }
        }
    }
}
