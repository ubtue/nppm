<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>REST API Documentation</title>
    <link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/layout/resthelp.css")%>" type="text/css">
</head>
<body>
    <h1>REST API Documentation</h1>
    <p>Welcome to the REST API for the NPPM project. Below is an overview of the available endpoints and their usage.</p>

    <div class="warning-box">
        <span class="warning-icon">&#9888;</span>
        <p>
            <strong>Warning:</strong> Please note that this API is still experimental, which means that the listed endpoints and the returned data structures can potentially change at any time.
            If there are specific use cases that you would like to cover in a stable way, please contact us at
            <a href="mailto:nppm-team@ub.uni-tuebingen.de" class="warning-link">nppm-team@ub.uni-tuebingen.de</a>.
        </p>
    </div>
    <h2>Endpoints</h2>
    <table>
        <thead>
        <tr>
            <th>Endpoint</th>
            <th>Method</th>
            <th>Description</th>
            <th>Example</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><code>/rest/item/{id}</code></td>
            <td>GET</td>
            <td>Fetches a single item by its identifier. The ID can start with <code>Q</code>,<code>M</code>, <code>P</code>, or <code>B</code>.</td>
            <td><code>/rest/item/B1319</code></td>
        </tr>
        <tr>
            <td><code>/rest/items/{id1},{id2},{id3}</code></td>
            <td>GET</td>
            <td>Fetches multiple items by their identifiers.</td>
            <td><code>/rest/items/B1319,B1320,B1321</code></td>
        </tr>
        <tr>
            <td><code>/rest/lemma/{Reference Form}</code></td>
            <td>GET</td>
            <td>Fetches the lemma corresponding to the given Reference Form.</td>
            <td><code>/rest/lemma/Latinum</code></td>
        </tr>
        <tr>
            <td><code>/rest/lemmas/{Reference Form 1},{Reference Form 2}</code></td>
            <td>GET</td>
            <td>Fetches multiple lemmas for the given Reference Forms.</td>
            <td><code>/rest/lemmas/Latinum,Scudilonem</code></td>
        </tr>
        <tr>
            <td><code>/rest</code></td>
            <td>GET</td>
            <td>Displays this help page with information about the API.</td>
            <td><code>/rest</code></td>
        </tr>
        </tbody>
    </table>

    <h2>Examples</h2>
    <h3>Fetch a Single Item</h3>
    <p>URL: <code>/rest/item/M6361</code></p>
    <pre>
Response:
{
  "mghLemma": "leub-n",
  "id": "M6361"
}
    </pre>

    <h3>Fetch Multiple Items</h3>
    <p>URL: <code>/rest/items/M6361,M6362,M6363</code></p>
    <pre>
Response:
{
    "items": [
        {
          "mghLemma": "leub-n",
          "id": "M6361"
        },
        {
          "mghLemma": "latīnus",
          "id": "M6362"
        },
        {
          "mghLemma": "agil",
          "id": "M6363"
        }
    ]
}
    </pre>
        <h3>Fetch a Lemma by Reference Form</h3>
    <p>URL: <code>/rest/lemma/Latinum</code></p>
    <pre>
Response:
{
  "Lemma": "latīnus",
  "ID": "M6362"
}
    </pre>

    <h3>Fetch Multiple Lemmas by Reference Form</h3>
    <p>URL: <code>/rest/lemmas/Latinum,Scudilonem</code></p>
    <pre>
Response:
{
    "items": [
        {
          "Lemma": "latīnus",
          "ID": "M6362"
        },
        {
          "Lemma": "skud-l",
          "ID": "M6364"
        }
    ]
}
    </pre>

<h2>Error Handling</h2>
<h3>Single Item Queries</h3>
<p>The REST API returns errors in the following scenarios:</p>

<table border="1">
    <tr>
        <th>Error Code</th>
        <th>Message</th>
        <th>Description</th>
        <th>Example URL</th>
    </tr>
    <tr>
        <td>400 (Bad Request)</td>
        <td>Invalid request format: {path}</td>
        <td>The request format is incorrect (missing or malformed identifiers).</td>
        <td><code>/rest/item/</code></td>
    </tr>
    <tr>
        <td>400 (Bad Request)</td>
        <td>Invalid request path format: {path}</td>
        <td>The URL path does not match the expected format.</td>
        <td><code>/rest/invalidpath/N1</code></td>
    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>Lemma not found for Reference Form: {Reference Form}</td>
        <td>No matching lemma was found for the provided Reference Form.</td>
        <td><code>/rest/lemma/UnknownForm</code></td>
    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>More than one Lemma found for Reference Form: {Reference Form}</td>
        <td>Multiple lemma entries exist for the given Reference Form.</td>
        <td><code>/rest/lemma/Benedicti</code></td>

    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>Lemma not found with ID {id}</td>
        <td>The requested lemma ID does not exist in the database.</td>
        <td><code>/rest/item/M9999999</code></td>
    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>Single Reference not found with ID {id}</td>
        <td>The requested Single Reference ID does not exist in the database.</td>
        <td><code>/rest/item/B9999999</code></td>
    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>Person not found with ID {id}</td>
        <td>The requested Person ID does not exist in the database.</td>
        <td><code>/rest/item/P9999999</code></td>
    </tr>
    <tr>
        <td>404 (Not Found)</td>
        <td>Source not found with ID {id}</td>
        <td>The requested Source ID does not exist in the database.</td>
        <td><code>/rest/item/Q9999999</code></td>
    </tr>
    <tr>
        <td>500 (Internal Server Error)</td>
        <td>Internal Server Error: {message}</td>
        <td>An unexpected error occurred while processing the request.</td>
        <td><code>/rest/item/M6362</code> (if database is down)</td>
    </tr>
</table>

<h3>Multiple Item Queries</h3>
<p>The following error scenarios may occur when querying multiple items:</p>
<table border="1">
    <tr>
        <th>Error Code</th>
        <th>Message</th>
        <th>Description</th>
        <th>Example URL</th>
        <th>JSON Response</th>
    </tr>
    <tr>
        <td>400 (Bad Request)</td>
        <td>Invalid request format: {path}</td>
        <td>The request format is incorrect (missing or malformed identifiers).</td>
        <td><code>/rest/items/</code></td>
        <td>-</td>
    </tr>
    <tr>
        <td>500 (Internal Server Error)</td>
        <td>Internal Server Error: {message}</td>
        <td>The URL path does not match the expected format for multiple items (e.g., missing commas or invalid characters).</td>
        <td><code>/rest/items/M6361M6362</code></td>
        <td>-</td>
    </tr>
    <tr>
        <td>500 (Internal Server Error)</td>
        <td>Internal Server Error: {message}</td>
        <td>An unexpected error occurred while processing the request.</td>
        <td><code>/rest/items/M6361,M6362</code> (if database is down)</td>
        <td>-</td>
    </tr>

    <tr>
        <td>200 (Ok)</td>
        <td>Item not found with ID {id}</td>
        <td>If at least one of the requested item IDs does not exist, the response will still return the available items, along with an indication of the missing ones.</td>
        <td><code>/rest/items/M6361,M9999999</code></td>
        <td>
            <pre>
                {
                    "items": [
                        {
                            "mghLemma": "leub-n",
                            "id": "M6361"
                        },
                        {                            
                            "error": "Lemma not found with ID M9999999",
                            "id": "M9999999"
                        }
                    ]
                }
            </pre>
        </td>
    </tr>
</table>


    <h2>Notes</h2>
    <ul>
        <li>Identifiers must follow the format <code>Q{number}</code>,<code>M{number}</code>, <code>P{number}</code>, or <code>B{number}</code>.</li>
        <li>All responses are in JSON format with proper UTF-8 encoding.</li>
    </ul>
</body>
</html>
