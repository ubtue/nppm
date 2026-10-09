package de.uni_tuebingen.ub.nppm.api.wikidata;

import de.uni_tuebingen.ub.nppm.api.REST;
import de.uni_tuebingen.ub.nppm.api.wikidata.entity.*;
import de.uni_tuebingen.ub.nppm.util.Utils;
import org.json.*;
import java.net.URI;
import java.net.URL;

public class WikidataREST extends REST {
    static public String API_URL = "https://www.wikidata.org/wiki/Special:EntityData/";

    static protected JSONObject getEntitiesById(final String wikidataId) throws Exception {
        URL url = new URI(API_URL + Utils.escapeURL(wikidataId) + ".json").toURL();
        JSONObject response = getUrlAsJsonObject(url);
        JSONObject entities = response.getJSONObject("entities");
        if (entities != null)
            return entities;

        throw new Exception("Error requesting entities from Wikidata: " + wikidataId);
    }

    static protected JSONObject getEntityById(final String wikidataId) throws Exception {
        JSONObject entities = getEntitiesById(wikidataId);
        if (entities.isEmpty()) {
            throw new Exception("Entity not found: " + wikidataId);
        }
        if (entities.length() > 1) {
            throw new Exception("Entity is ambiguous: " + wikidataId);
        }
        JSONObject entity = entities.getJSONObject(wikidataId);
        if (entity == null) {
            throw new Exception("Error getting entity from result: " + wikidataId);
        }
        return entity;
    }

    static public WikidataPerson getPersonById(final String wikidataId) throws Exception {
        return new WikidataPerson(getEntityById(wikidataId));
    }
}
