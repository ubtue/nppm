package de.uni_tuebingen.ub.nppm.api.wikidata.entity;

import org.json.*;
import com.jayway.jsonpath.*;

public class WikidataPerson {
    JSONObject json;

    public WikidataPerson(final JSONObject json) {
        this.json = json;
    }

    public String getGnd() {
        // Since the Wikidata JSON structure is very deep, we use JsonPath to simplify the code
        // If we have multiple functions later, it might make sense to store json.toString as class variable for performance reasons

        // Set option so JsonPath returns null instead of throwing an exception if not found
        Configuration conf = Configuration.defaultConfiguration().addOptions(Option.SUPPRESS_EXCEPTIONS);
        return JsonPath.using(conf).parse(json.toString()).read("$.claims.P227[0].mainsnak.datavalue.value", String.class);
    }
}
