package de.uni_tuebingen.ub.nppm.cli;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Stream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.interfaces.*;

public class Sitemap extends AbstractBase {

    private static DocumentBuilderFactory docFactory;
    private static DocumentBuilder docBuilder;
    private static String outputDirectory;
    private static boolean outputPretty = false;
    private static final String BASE_URL = "https://nppm.ub.uni-tuebingen.de/";
    private static final String BASE_URL_RESOLVER = BASE_URL + "id/";
    private static final String BASE_URL_SITEMAPS = BASE_URL + "sitemaps/";
    private static List<String> sitemaps = new ArrayList<>();
    private static SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX");

    /**
     * Generate XML Sitemap
     *
     * For Example + Format Description, see:
     * https://www.sitemaps.org/de/protocol.html
     */
    public static void main (String[] args) throws Exception {
        // Process args
        switch (args.length) {
            case 1:
                outputDirectory = args[0];
                break;
            case 2:
                if (!args[0].equals("--pretty"))
                    Usage("When 2 parameters are given, the first one must be \"--pretty\"!");
                outputPretty = true;
                outputDirectory = args[1];
                break;
            default:
                Usage("Usage: Sitemap [--pretty] output_directory");
        }

        // create output directory if it does not exist
        File dir = new File(outputDirectory);
        if (!dir.exists()) {
            dir.mkdir();
        }

        // Load Properties (DB access credentials, etc.)
        LoadProperties();

        // Generate + write XML documents
        // Since bots will struggle with single files > 10MB, we need to generate an Index file and split into subfiles.
        GenerateBase();

        try (var session = de.uni_tuebingen.ub.nppm.db.AbstractBase.getSession()) {
            GenerateEntitySitemap(QuelleDB.getStreamPublic(session), "quellen");
            GenerateEntitySitemap(PersonDB.getStreamPublic(session), "personen");
            GenerateEntitySitemap(LemmaDB.getStreamPublic(session), "lemmas");
            GenerateEntitySitemap(EinzelbelegDB.getStreamPublic(session), "einzelbelege");
        }
        GenerateIndex();

        // Exit successfully (we need this or the program will hang forever)
        System.exit(0);
    }

    private static Document InitDocument(String rootElementName) throws ParserConfigurationException {
        docFactory = DocumentBuilderFactory.newInstance();
        docBuilder = docFactory.newDocumentBuilder();
        Document document = docBuilder.newDocument();
        Element rootElement = document.createElement(rootElementName);
        rootElement.setAttribute("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9");
        document.appendChild(rootElement);
        return document;
    }

    private static Document InitSitemapIndexDocument() throws ParserConfigurationException {
        return InitDocument("sitemapindex");
    }

    private static Document InitSitemapDocument() throws ParserConfigurationException {
        return InitDocument("urlset");
    }

    private static void AddEntry(Document document, String url) throws Exception {
        AddEntry(document, url, null);
    }

    private static void AddEntry(Document document, String url, Date lastmodDate) throws Exception {
        Element urlElement = document.createElement("url");
        Element locElement = document.createElement("loc");
        locElement.setTextContent(url);
        urlElement.appendChild(locElement);
        if (lastmodDate != null) {
            Element lastmodElement = document.createElement("lastmod");
            lastmodElement.setTextContent(dateFormatter.format(lastmodDate));
            urlElement.appendChild(lastmodElement);
        }
        document.getDocumentElement().appendChild(urlElement);
    }

    private static void AddSitemapToIndex(Document document, String filename) throws Exception {
        Element sitemapElement = document.createElement("sitemap");
        Element locElement = document.createElement("loc");
        locElement.setTextContent(BASE_URL_SITEMAPS + filename);
        sitemapElement.appendChild(locElement);
        Element lastmodElement = document.createElement("lastmod");
        lastmodElement.setTextContent(dateFormatter.format(new Date()));
        sitemapElement.appendChild(lastmodElement);
        document.getDocumentElement().appendChild(sitemapElement);
    }

    private static void WriteDocument(Document document, String outputPath) throws IOException, TransformerException {
        try (FileOutputStream output = new FileOutputStream(outputPath)) {
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();

            if (outputPretty)
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");

            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(output);
            transformer.transform(source, result);
        }
    }

    private static void GenerateAndRegisterSitemap(Document sitemap, String name) throws Exception {
        int maxEntriesPerPart = 50000;
        if (sitemap.getDocumentElement().getChildNodes().getLength() <= maxEntriesPerPart) {
            // Generate single sitemap if possible
            System.out.println("Generate " + name + " as single sitemap");
            String filename = "sitemap-" + name + ".xml";
            sitemaps.add(filename);
            WriteDocument(sitemap, outputDirectory + "/" + filename);
        } else {
            // Split into parts if necessary
            int partNumberMin = 1;
            int partNumberMax = (sitemap.getDocumentElement().getChildNodes().getLength() / maxEntriesPerPart) + 1;

            for (int partNumber = partNumberMin; partNumber <= partNumberMax; ++partNumber) {
                int rangeStart = 1 + ((partNumber - 1) * maxEntriesPerPart);
                int rangeEnd = rangeStart + maxEntriesPerPart - 1;
                System.out.println("Generate " + name + " Part " + partNumber + " with entries " + rangeStart + " To " + rangeEnd);

                Document part = InitSitemapDocument();
                Node child = sitemap.getDocumentElement().getFirstChild();
                int childNumber = 1;
                while (child != null) {
                    if (childNumber >= rangeStart && childNumber <= rangeEnd) {
                        Node clone = child.cloneNode(outputPretty);
                        clone = part.importNode(clone, outputPretty);
                        part.getDocumentElement().appendChild(clone);
                    }
                    ++childNumber;
                    child = child.getNextSibling();
                }

                String partName = "sitemap-" + name + "-" + partNumber + ".xml";
                sitemaps.add(partName);
                WriteDocument(part, outputDirectory + "/" + partName);
            }
        }
    }

    private static void GenerateBase() throws Exception {
        Document document = InitSitemapDocument();

        // The base sitemap contains general static pages
        List<String> pages = Arrays.asList(
            // Startseite
            "gast/infos?sharedHtml=start&current=start",

            // Hilfe
            "gast/infos?sharedHtml=hilfe",

            // Footer-Einträge
            "gast/infos?sharedHtml=aktuelles",
            "gast/infos?sharedHtml=datenbank",
            "gast/infos?sharedHtml=quellenliste",
            "gast/infos?sharedHtml=mitglieder",
            "gast/infos?sharedHtml=kooperationen",
            "gast/infos?sharedHtml=publikationen"

            // Intentionally ommitted pages:
            // - Datenschutzerklärung
            // - Impressum
        );

        for (String page : pages) {
            AddEntry(document, BASE_URL + page);
        }
        GenerateAndRegisterSitemap(document, "base");
    }

    private static <T extends PersistentIdentifier & History> void GenerateEntitySitemap(Stream<T> entities, String name) throws Exception {
        Document document = InitSitemapDocument();
        entities.forEach(entity -> {
            Date lastmodDate = entity.getLetzteAenderung();
            if (lastmodDate == null) {
                lastmodDate = entity.getErstellt();
            }
            try {
                AddEntry(document, BASE_URL_RESOLVER + entity.getPersistentIdentifier(), lastmodDate);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        GenerateAndRegisterSitemap(document, name);
    }

    private static void GenerateIndex() throws Exception {
        Document document = InitSitemapIndexDocument();
        for (String sitemap : sitemaps) {
            AddSitemapToIndex(document, sitemap);
        }
        // If you ever rename this output, make sure to also change the reference in robots.txt!
        WriteDocument(document, outputDirectory + "/sitemapIndex.xml");
    }
}
