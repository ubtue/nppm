package de.uni_tuebingen.ub.nppm.api;

import de.uni_tuebingen.ub.nppm.util.Constants;
import org.json.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

abstract public class REST {
    static protected String getUrl(final URL url) throws Exception {
        HttpURLConnection con = (HttpURLConnection)url.openConnection();
        con.setRequestMethod("GET");

        // We always set a user agent, because some APIs like e.g. Wikidata will block us if we don't!
        con.setRequestProperty("User-Agent", Constants.USER_AGENT);

        if (con.getResponseCode() != HttpURLConnection.HTTP_OK) {
            throw new Exception("Invalid response");
        }

        try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            return response.toString();
        }
    }

    static protected JSONObject getUrlAsJsonObject(final URL url) throws Exception {
        return new JSONObject(getUrl(url));
    }

    static protected JSONArray getUrlAsJsonArray(final URL url) throws Exception {
        return new JSONArray(getUrl(url));
    }
}
